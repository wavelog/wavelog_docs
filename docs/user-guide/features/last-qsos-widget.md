# Last QSOs Widget

Wavelog offers a widget that lists that last logged QSOs for a logbook. This can be included in a qrz.com page for example.

## Usage

You set the options as `GET` parameter in the URL. The base URL looks like:  
  
`https://[wavelog url]/index.php/widgets/qsos/[slug]`

[slug] can be defined in _Visitor site_ at the _Station Setup_
See:
![Enable Visitor site](https://github.com/user-attachments/assets/8802fbbb-e097-4de7-857b-7cbaf784f693)
![Define a public slug](https://github.com/user-attachments/assets/8fef9577-b6f3-470c-9752-2434bf26ddab)

Options:  
  
`https://[wavelog url]/index.php/widgets/qsos/[slug]?[option0]=[value]&[option1]=[value]&[option2]=[value]`

Possible `GET` Options currently implemented:

!!! note
    All Options are optional! 

| option | value | default |
|----|----|----|
| `qso_count`     | Number of QSOs listed  | `15` |
| `theme` | overrides the global appeance theme. Set `light` or `dark` |  |
| `text_size` | Text size (1-7) | `1` |

### Example

Definition: Show the last 50 QSOs with dark theme and text size of 5

`https://[wavelog url]/index.php/widgets/qsos/[slug]?qso_count=50&theme=dark&text_size=5`

Example for QRZ-Embedding:

```
<p style="text-align:center"><br />
Last 25 Contacts (Tabular)<br />
<iframe align="top" frameborder="0" height="525" id="last_25" name="last_25" scrolling="yes" src="https://[wavelog_url]/index.php/widgets/qsos/[slug]?qso_count=25&theme=dark&text_size=5" width="100%"></iframe></p>
```