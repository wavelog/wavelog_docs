# Label Printing

Label features are now integrated into Wavelog.

# General Usage:

To use it, go to "Labels" under the user menu.
If you haven set up anything, you will need to at least set up one label by clicking on the "Create New Label Type" at the top.
Once that is done, save it and click on "Use For Print".

To print some labels, make sure that you have added the QSOs to the queue by either setting them to "Requested" or "Queued". Both statuses will show up in the queue. 

To print, click on the printer symbol. A dialog with a options are now presented to you.

If you have a sheet with several labels, you can choose to start at the first unused label if you have used some labels before. 
Click on include grid if you want your location grid printed.

If you own a dedicated label printer, you need to set up the size for that label in the paper type first. When that is done, add the size of the label in label types.

Happy printing!

## Label-Printer / Workflow e.g. for Brother-Printers with 38 x 90 Stickers

Printing with a label-printer is sometimes tricky. there are a few things that should be considered.

1. Go to Labels at User-Menu and click "Create Paper-Type". The following dialog will pop-up. Fill it as shown:

<img width="1308" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/a55d2b8d-f9c7-417a-9d4d-240f7b38a776">


2.) Now save that, and Click on "Create Label-Type". Fill in the values as given and select the previous created Paper-Type at Paper-Type
You'll recognize, that width <-> length are swapped. That's because the Brother-printer sometimes wants portrait-mode instead of landscape-mode. Otherwise it wont print.

<img width="1312" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/efb92f16-cb9c-4d8e-8d8e-d507b9906e83">


3.) Save that also. If there are now QSOs for label-printing in the Queue (The QSO has to be marked as "Requested") you can select the label, by ticking the checkbox next to it and print the labels (at the bottom of the label-page)
There's one more thing: Use your systems printing dialog. Browsers tend to ignore landscape/portrait-settings of the generated PDF.


