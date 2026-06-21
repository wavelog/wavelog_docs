# QSL Postcard Designer — User Guide

The **QSL Postcard Designer** lets you design your own physical QSL postcards in
Wavelog and print them as a ready-to-print PDF. You drag contact details (callsign,
band, date, address, etc.) onto a card, save the design as a reusable template,
and then generate a multi-page PDF — one postcard per callsign.

Cards are **standard 5.5 × 3.5 inch** (≈ 13.97 × 8.89 cm) landscape QSL cards, the
size most bureaus and printers expect.

---

## 1. Before you start (prerequisites)

- You must be **logged in**.
- The feature needs the `userdata` directory to be configured in Wavelog (this is
  where your uploaded background images are stored). If it isn't set, the page
  shows a message telling you to compare your `config.php` with `config.sample.php`.
- **Mailing addresses** are looked up automatically from your callbook (e.g. QRZ /
  HamQTH). A postcard is only produced for a callsign that has a usable mailing
  address on file. If a callsign has no address, its card is silently skipped.

> **Units:** the designer follows your measurement preference. If you use
> **kilometres**, dimensions are shown in **centimetres**; otherwise **inches**.
> Either way the printed PDF is always correct.

---

## 2. Opening the designer

Open the user menu -> **QSL Postcard Designer**
(the card icon). You land on a three-pane editor with a toolbar across the top.

---

## 3. Quick start (5 steps)

1. **(Optional)** Upload a background image — see [§7](#7-background-images).
2. **Drag fields** from the **Fields** list on the left onto the card (or just click
   a field to drop it on the canvas).
3. **Click a field** on the card and use the **Properties** panel on the right to
   set font, size, colour, position, etc.
4. Set the **Template Options** (right side): how many QSOs per card, whether to
   print the background, whether to print the address.
5. **Save** — type a name and click **Save**.

You now have a template you can print from, described in [§11](#11-printing-postcards-for-real).

---

## 4. Toolbar

| Control | Purpose |
|---------|---------|
| **Template** dropdown | Pick an existing template, or `(new)` for a blank card. |
| **Template name** | Name for the template when saving. |
| **Save** | Save (or update) the current template. |
| **Delete** (trash) | Delete the selected template. |
| **Background image** + **Upload** | Upload a JPG/PNG to use as the card background. |
| **PDF** | Generate a **demo PDF** using a few of your recent QSOs so you can proof the design. |
| **Undo / Redo** | Step backwards/forwards through your changes. |
| **Zoom** − / reset / + | Zoom the canvas. Also **Ctrl + mouse wheel**. |
| **Print offset X / Y** | Global calibration offset applied to **every** element at print time. See [§9](#9-calibration--print-offset). |

---

## 5. Placing and arranging fields

### Adding a field

- **Drag** a field from the left list onto the card and drop it where you want it.
- Or **click** a field to drop it at the next free spot.
- Use the **search box** at the top of the list to filter fields by name.
- **Add Custom Text** puts a free-text element on the card (e.g. your name, "73",
  a QSL manager note). Edit its wording in the Properties panel.

### Field categories

| Category | Examples |
|----------|----------|
| **Address** | Recipient name, address lines, city/state/zip, country |
| **QSO Core** | Callsign, band, mode, satellite, frequency, RST sent/rcvd, summary |
| **Date & Time** | Date, time (UTC), separate day / month / year |
| **Station & Equipment** | TX power |
| **My References** | Your POTA / SOTA / IOTA refs and grid |
| **Markers** | "PSE QSL", "TNX QSL", "Portable", "Mobile" checkboxes (print an **X** when true) |
| **Other** | Comment, QSL message, QSL via |

### Selecting

- **Click** an element to select it.
- **Shift-click** or **Ctrl-click** to add/remove from the selection (multi-select).
- **Drag on empty canvas** to rubber-band select everything in a rectangle.
- **Ctrl + A** selects all; **Esc** clears the selection.
- The Properties panel always reflects the **last-selected** element. Font, size,
  bold, colour, wrap and the "repeats" toggle apply to *all* selected elements.

### Moving & snapping

- **Drag** elements to move them. Whole groups move together when several are
  selected.
- Elements **snap** to a ¼-inch grid and to the edges/centres of other elements —
  faint guide lines appear while snapping.
- Hold **Alt** while dragging to move freely without snapping (temporary).
- Nudge with the **arrow keys** (hold **Shift** for a bigger grid-sized step).

### Right-click menu

Right-click an element for **Duplicate**, **Delete**, and (with 2+ selected)
**Align & distribute**: align left/centre/right, top/middle/bottom, distribute
evenly, or centre the group on the page.

---

## 6. The Properties panel

When an element is selected, edit it here:

| Property | Notes |
|----------|-------|
| **Text** | Shown only for custom-text elements. |
| **X / Y** | Position of the element's top-left corner. |
| **Font** | Helvetica, Times, or Courier. |
| **Font Size** | 6–36 pt. |
| **Bold** | Toggle bold weight. |
| **Color** | Text colour (colour picker). |
| **Wrap width** | Max width before the text wraps onto more lines (good for addresses/comments). |
| **Repeats per QSO** | For multi-QSO cards — see [§8](#8-multi-qso-cards-several-contacts-per-card). |
| **Disable Auto-Snap** | Lets this element move freely, ignoring the grid and other elements. |
| **Duplicate / Delete** | Quick actions for the selected element(s). |

---

## 7. Background images

1. In the toolbar, **choose a file** (`.jpg`, `.jpeg`, or `.png`, up to 5 MB).
2. Click **Upload**. The image becomes the card's background in the canvas.

- Whether the background is **printed** on the final PDF is controlled by the
  **Print background image** option ([§8](#8-multi-qso-cards-several-contacts-per-card)).
  Uncheck it if you'll be printing onto **pre-printed card stock**.
- Background images are tied to your templates: when you delete the last template
  that uses an image, the file is removed from disk automatically.

---

## 8. Multi-QSO cards (several contacts per card)

Use **Template Options -> Number of QSOs per QSL card** to put more than one
contact on a single card (e.g. several bands/modes with the same station).

When this is greater than 1:

- **Set "Row spacing"** — the vertical distance between each repeated QSO row.
- Mark any field that should print **once per QSO** (callsign, band, date, RST…)
  with **Repeats per QSO** in its Properties. Faded **ghost copies** appear below
  it in the editor so you can see how the rows will line up.
- Fields **without** "Repeats per QSO" (your header text, return address, etc.)
  print **once per card**.
- **Address fields always print once per card** — a card is always addressed to a
  single station.

> Cards are **always grouped by callsign**. One postcard never mixes contacts with
> different callsigns. If a callsign has more QSOs than fit on one card, the extras
> spill onto a second card for the same station.

### Other template options

- **Print background image** — include the uploaded background on the PDF. Uncheck
  for pre-printed cards.
- **Skip address printing** — **checked by default.** Uncheck it when you want the
  recipient's mailing address printed on the card (i.e. you're mailing the cards
  yourself, not using pre-addressed stock).

---

## 9. Calibration & print offset

Printers rarely feed a sheet perfectly centred. Rather than nudging every field,
use the toolbar's **Print offset X / Y** to shift **all** elements together by a
fixed amount at print time.

**Recommended workflow:**

1. Set offsets to **0 / 0**, generate a **demo PDF**, and print one test sheet.
2. Measure how far everything is off.
3. Enter the correction in **Print offset X / Y** (positive moves elements right /
   down).
4. Re-print to confirm. Save the template so the calibration is remembered.

---

## 10. Saving, loading & deleting templates

- **Save:** type a name in **Template name** and click **Save**. Saving again with
  the same template loaded updates it in place.
- **Load:** choose a template from the **Template** dropdown. Your most recently
  used template and zoom level are remembered between visits.
- **Delete:** load the template, then click the **trash** button and confirm.
  Deleting a template also cleans up its background image if nothing else uses it.

Templates are private to your user account.

---

## 11. Printing postcards for real

Once you have a saved template, there are two ways to print real postcards from
your logbook:

1. User menu -> QSL Queue page.
2. Advanced logbook. Check which contacts to generate a PDF, then selected "Print QSL card" from the Actions menu.

### A. All QSOs awaiting a card

Click **"Print Postcards for all QSOs"**. This gathers every QSO in your QSL print
queue (requested or not-yet-sent), picks a template, and produces a PDF — one
qslcard per callsign.

### B. Specific QSOs you selected

In the QSL print list, tick the QSOs you want, then click **"Print Selected QSO
Postcards"**. Choose a template and generate the PDF for just those contacts.

> **All print options come from the template**, not from the print screens. The
> number of QSOs per card, background, and address settings are whatever you saved
> in the designer.

### C. Quick proof / demo PDF

From the designer toolbar, the **PDF** button produces a demo PDF using a handful
of your most recent QSOs — handy for checking layout and calibration before a real
print run.

> **Generating a PDF does not mark QSOs as "sent".** After you've actually mailed
> the cards, mark them sent separately from the QSL print page
> (**"Mark requested QSLs as sent"**).

---

## 12. Keyboard & mouse reference

| Action | Shortcut |
|--------|----------|
| Undo / Redo | **Ctrl+Z** / **Ctrl+Y** (or Ctrl+Shift+Z) |
| Select all | **Ctrl+A** |
| Duplicate selected | **Ctrl+D** |
| Delete selected | **Delete** / **Backspace** |
| Nudge selected | **Arrow keys** (Shift = bigger step) |
| Move without snapping | Hold **Alt** while dragging |
| Add to / remove from selection | **Shift-click** or **Ctrl-click** |
| Zoom canvas | **Ctrl + mouse wheel** |
| Clear selection / close menu | **Esc** |
| Right-click element | Context menu (align, distribute, duplicate, delete) |

---

## 13. Tips & troubleshooting

- **A station's card is missing from the PDF.** That callsign had no usable mailing
  address in your callbook, so it was skipped. Look the address up and it'll appear
  next time (addresses are cached for ~20 days).
- **Everything prints slightly off-centre.** Use **Print offset X / Y** ([§9](#9-calibration--print-offset))
  rather than moving individual fields.
- **Text runs off the card edge.** Lower the font size, or set a **Wrap width** so
  long values (addresses, comments) wrap onto multiple lines.
- **Using pre-printed card stock.** Turn **off** "Print background image" and leave
  "Skip address printing" **on**, then place only the QSO detail fields you need.
- **Mailing the cards yourself.** Turn **off** "Skip address printing" so the
  recipient address prints on each card.
- **More than one contact per station.** Raise "Number of QSOs per QSL card" and
  tick **Repeats per QSO** on the per-contact fields ([§8](#8-multi-qso-cards-several-contacts-per-card)).
