# OQRS - Online QSL Request System

What is OQRS?
The Online QSL Request System (OQRS) is a convenient web-based service that allows amateur radio operators to request QSL cards for confirmed contacts (QSOs) without the need to send a traditional paper QSL or postal mail. It streamlines the process by allowing users to:

* Submit QSL requests electronically
* Choose between direct or bureau QSL options
* Save time, reduce postage costs, and improve accuracy

OQRS is commonly used by DXpeditions, contest stations, and operators with high QSO volumes to manage QSLing efficiently while offering a reliable service to those who want confirmation of their contacts.

# How to enable
* Go to station setup
* Edit visitor site and fill a slug to be used in the url. This can be your callsign if you want. Click save when done.
* Edit the locations, and enable OQRS for those locations where you want to use OQRS.

# User Options

### Global text
The text set here, will be shown at the top of the public OQRS page.

### Grouped search
When enabled, all locations enabled for the user will be searched. If disabled, the user must select the location to search.

### Show station location name in grouped search results
When enabled, the name of the location will be show in the QSO search result table.

### Automatic OQRS matching
If disabled, you need to manually check the log and add the label for printing.

# Location Options

### OQRS Enabled
To enable OQRS for a location, set this to on.

### OQRS Email alert
Email must be set up in the client for this to work. Once this option is enabled, you will receive an email when someone submits an OQRS. The email will be sent to the email set in your user preferences.

### OQRS Text
If you want some text to be displayed for this location when a user enters the OQRS for this location. 


## Add iframe of OQRS Request
Simple iFrame Widget which can be placed in a QRZ.com Bio or on any other website which allows iframes
image:


To use this widget place it somewhere with this iframe code:

`<iframe name="iframe" src="[WAVELOG URL]/widgets/oqrs/[SLUG]" height="220" width="670" frameborder="0"></iframe>`

Important

Due the fact that this HTML is not responsive yet I recommend to stick with height="220" width="670" in the iframe. You may have to play a little bit with these settings to find the right spot.
Options

The Widget is customizable. Currently available options:

* `theme`

Choose the theme widget with one of the themes in Wavelog
Example: `theme=darkly`


The Widgetlogo is a link which shows per default on Wavelog's Github Repo (https://github.com/wavelog/wavelog).

To add options just place them as GET parameter in the URL like this:

`[WAVELOG URL]/widgets/oqrs/[SLUG]?theme=darkly`

# OQRS View
View and manage submitted QSL requests.

Filter by location, callsign and status. This is the main view where you can see the incoming OQRS requests, and process them as needed.

### Print Label
The OQRS will be set to done when you print the label and mark the QSL card as sent.
You can also use the OQRS view to set the status of a request to done.

# F.A.Q.

### What is automatch?
For this to work, the automatch option needs to be on. If someone requests a QSL card, and it is found in the system within 30 minutes from the given time, it will automatically be matched to this QSO.

Without it on, you need to find and link the QSO in your logbook to the OQRS request.

### Why do I need to have a QSO match set on the OQRS request?
You need to have a match so that the system can print a label for you, and you can have the QSL marked as sent. If no match, you have no connection between the QSO and the request.

### Why is no email sent?
Make sure the email is set up in the global options, and the email address is correct in the user settings.

### What does the different statuses mean?
* Open request - The request is currently open, and needs to be reviewed by you.
* Not in log request - The request is not in the log, so you need to check your log and process the request.
* Done / sent - The request has been processed and the QSL has been sent.
* Pending - The request is still being processed.
* Rejected - The request has been rejected and will not be processed.

### What does the check log buttons do?
* Call - displays all QSOs in the log for the callsign
* Date / Time - displays all QSOs on the given date with time +- 3000 seconds

### The request never shows up
* A duplicate check is implemented so that a new request on the same date/band and mode can't be done.

### But what about not in log requests?
You process them as you would any other OQRS requests. You need to check your log if you can find a QSO at all. If might be a busted call, wrong band, wrong mode, wrong date or time. Use the check log features.

# OQRS Scenario
The requester enters your OQRS page. The page can be presented with either:
1. A dropdown to choose the location to search
2. Just a search box to search all locations at once. This is enabled with the grouped search option.

When the requester is done with searching, and have filled in necessary information, the OQRS request will be stored in the database waiting to be processed. If you have automatch enabled, Wavelog will try to find the corresponding QSO to match to the request. The status will be set to "Pending", and a label is added to the print queue. Once the label is printed and the QSL is set to sent, the request will be set as "Done". If a match is not found, the status will be set to "Open request".

If automatch is disabled, the status will be set to "Open request".

For "Open request", you will need to check the log with "Call" or "Date/Time" buttons. When you find the correct QSO, you click on the "Match QSO" button. The QSO will be added to the print queue, and can now be printed and sent.