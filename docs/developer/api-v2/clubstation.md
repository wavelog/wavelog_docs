# API v2 in Clubstations

A [clubstation](../../admin-guide/administration/clubstations.md) lets several operators
share one club or special callsign. API v2 supports that, but a token created
inside a clubstation session behaves differently from a personal one — it is
bound to the **permission level** the member holds on the club.

!!! note
    None of this applies to a personal token, and none of it applies at all when
    the instance has the clubstation feature (`special_callsign`) switched off.
    If you only ever use your own account, you can skip this page.

## Personal tokens vs. club tokens

Every token records two users:

| | Personal token | Club token |
| --- | --- | --- |
| Owner (whose data it reaches) | you | the **clubstation** |
| Creator (who acts through it) | you | the **member** who created it |

A club token is created by switching into the clubstation in the web UI and
then minting a token from the API page as usual. Everything the token reaches
belongs to the club; everything it *writes* is attributed to the member.

Use the [Token](token.md) resource to tell them apart — `owner` is the
clubstation's callsign for a club token:

```bash
curl https://<WAVELOG_URL>/index.php/api/v2/token \
     -H "Authorization: Bearer wl2_your_token_here"
```

## Permission levels

The level is set per member on the club's permission page and is re-read on
**every** API request — a change takes effect immediately, with no need to
recreate the token.

| Level | Name | Through the API |
| --- | --- | --- |
| 3 | Club Member | Log and manage your own QSOs; read station locations |
| 6 | Club Member ADIF | Same as level 3 (the extra ADIF rights are a UI distinction) |
| 9 | Club Officer | Unrestricted access to the whole club logbook |

Levels 3 and 6 are treated identically by the API. The difference between them
in the web UI is about which ADIF screens a member may open; over the API both
are simply "not an officer".

!!! note "Wavelog administrators"
    A club token created by a Wavelog administrator works even when they hold no
    permission level on that club — they are treated as an officer, the same way
    the web UI lets them manage every clubstation. An administrator who *does*
    have an explicit level is treated by that level instead, so setting yourself
    to Club Member stays meaningful.

## What a member below officer level may do

### Their own QSOs only

For levels 3 and 6 every QSO operation is scoped to the member's own callsign
(`OPERATOR`):

- `GET /api/v2/qso` lists only their QSOs. `meta.total` counts only those, too.
- `GET /api/v2/qso?format=adif` exports exactly the same set — the format does
  not widen the result.
- `GET`, `PATCH` and `DELETE` on `/api/v2/qso/{id}` of another operator's QSO
  return **`404 not_found`**, not `403`. A QSO the token may not see is reported
  as if it did not exist, rather than confirming its existence.

An officer sees and edits every operator's QSO; `GET /api/v2/qso?operator=CALL` narrows the
list to one operator, and every QSO carries its `operator` field (Wavelog versions > 3.2.5).

### The operator is assigned, not chosen

When a member creates a QSO, `operator` is always set to their own callsign.
Sending a different one has no effect — the value is overwritten, on all three
create paths (single JSON, bulk `qsos[]` and `import_type=adif`):

```bash
# Sent by a level-3 member of HB9CLUB whose own callsign is HB9ABC
curl -X POST https://<WAVELOG_URL>/index.php/api/v2/qso \
     -H "Authorization: Bearer wl2_club_token" \
     -H "Content-Type: application/json" \
     -d '{"station_profile_id": 4, "call": "N9EAT", "band": "20m",
          "mode": "SSB", "qso_date": "2026-06-16", "time_on": "1706",
          "operator": "HB9XYZ"}'
# -> the QSO is stored with OPERATOR = HB9ABC
```

An officer may set `operator` freely, which is how QSOs are logged on behalf of
another operator.

### Station locations are officer-only

Station locations are shared club infrastructure, and deleting one removes all
of its QSOs along with it. Creating, updating and deleting them therefore
requires level 9:

| Request | Level 3 / 6 | Level 9 |
| --- | --- | --- |
| `GET /api/v2/station` | ✅ | ✅ |
| `GET /api/v2/station/{id}` | ✅ | ✅ |
| `POST /api/v2/station` | `403` | ✅ |
| `PATCH /api/v2/station/{id}` | `403` | ✅ |
| `DELETE /api/v2/station/{id}` | `403` | ✅ |

The refusal carries the codes and levels involved:

```json
{
  "error": {
    "code": "insufficient_club_permission",
    "message": "This operation requires clubstation permission level 9",
    "details": { "required_level": 9, "granted_level": 3 }
  }
}
```

### Logbooks are officer-only, reads included

A [logbook](logbook.md) groups the club's station locations, so it is shared infrastructure
too — but unlike station locations, even **reading** one takes level 9:

| Request | Level 3 / 6 | Level 9 |
| --- | --- | --- |
| `GET /api/v2/logbook` | `403` | ✅ |
| `GET /api/v2/logbook/{id}` | `403` | ✅ |
| `POST` / `PATCH` / `DELETE` | `403` | ✅ |

The web UI draws the same line — its whole logbook management screen is officer-only — so the
`logbook:*` scopes are not even offered when a member below that level creates a token.

### Radios belong to their operator

Each member registers their own rigs into the shared club account, so
[Radio](radio.md) is scoped the same way: a member below officer level lists,
reads and deletes only the radios they registered themselves. Another member's
radio returns `404 not_found`.

### Lookups follow the same boundary

A [lookup](lookup.md) answers "have I worked this before" out of the logbook, so
it honours the same restriction — otherwise it would hand back the name, QTH and
locator recorded in a QSO the member is not allowed to list:

- `?callsign=` reports `workedBefore: false` (and `call_worked: false` with
  `detail=full`) when the only matching QSO belongs to another operator.
- `?grid=` and `?grid=all` only consider the member's own QSOs.

### Club membership is officer-only

The whole [Club](club.md) resource stays officer-only — both reading the member
list (no disclosure of member information to non-officers) and managing
permissions:

| Request | Level 3 / 6 | Level 9 |
| --- | --- | --- |
| `GET /api/v2/club` | `403` | ✅ |
| `GET /api/v2/club/{user_id}` | `403` | ✅ |
| `POST /api/v2/club` | `403` | ✅ |
| `PATCH /api/v2/club/{user_id}` | `403` | ✅ |
| `DELETE /api/v2/club/{user_id}` | `403` | ✅ |

The refusal is a plain `forbidden` rather than the
`insufficient_club_permission` used elsewhere: the resource turns away everything
that is neither an officer nor a Wavelog administrator, and a personal token
gets the same code with a message naming the other missing role.

```json
{
  "error": {
    "code": "forbidden",
    "message": "Token is not a club officer"
  }
}
```

An officer cannot change or remove their **own** membership through the API, so
they cannot lock the club out of its permission management. See
[Club](club.md#guard-rails).

A Wavelog administrator reaches the same resource from the outside, with a
personal token and `?club_id=`, and is not bound by that rule — see
[Wavelog administrators](club.md#wavelog-administrators). The `club:*` scopes
are only offered to sessions that match one of the two roles, so a regular user
is not shown them at all.

## Statistics are club-wide

One deliberate exception: [Statistic](statistic.md) reports **club-wide**
figures for every member, regardless of level. The counters are aggregates, not
QSO data, and they are shared with the dashboard.

This means the numbers can legitimately disagree with what the QSO resource
returns to the same token:

```text
GET /api/v2/statistic?profile=qso   ->  total: 412   (the whole club)
GET /api/v2/qso                     ->  total: 57    (this member's QSOs)
```

Do not use the statistic totals to paginate or reconcile a QSO list.

## Losing membership

Removing a member from the club **deletes every club token they created for it**
— including tokens that were set to never expire. This is the same cleanup the
v1 API keys have always had, and it takes effect at once. Any call made with
such a token afterwards is refused:

```json
{
  "error": {
    "code": "invalid_token",
    "message": "Invalid or revoked API token"
  }
}
```

The status is `401`: the token no longer exists. Re-adding the member restores
their permission, but not the token — they have to create a new one.

Two things are *not* affected:

- The member's **personal** tokens (`owner == creator`). Those belong to their
  own account, not to the club.
- Tokens other members created for the same club. The cleanup is per member.

!!! tip "Handling this in a client"
    Treat `401 invalid_token` as permanent and stop retrying — unlike
    `rate_limited` it will not resolve on its own. Surface it to the user: they
    need a new token, and only the club can grant the membership behind it.

!!! note "`club_access_revoked` still exists"
    A second, independent check re-reads the membership on every request. It
    guards the cases the cleanup above cannot reach — a membership removed
    directly in the database, for instance — and answers `403
    club_access_revoked` with the token left intact. A client should handle both
    codes; in day-to-day use it will see the `401`.

## Summary

| | Personal | Level 3 / 6 | Level 9 |
| --- | --- | --- | --- |
| Read own QSOs | ✅ | ✅ | ✅ |
| Read other operators' QSOs | — | `404` | ✅ |
| Choose the `operator` field | ✅ | overwritten | ✅ |
| Read station locations | ✅ | ✅ | ✅ |
| Write/delete station locations | ✅ | `403` | ✅ |
| Logbooks (read and write) | ✅ | `403` | ✅ |
| Own radios | ✅ | ✅ | ✅ |
| Other operators' radios | — | `404` | ✅ |
| Lookups across all operators | ✅ | own only | ✅ |
| Club member list | — | `403` | ✅ |
| Manage club permissions | — | `403` | ✅ (not your own) |
| Statistics | own | club-wide | club-wide |
