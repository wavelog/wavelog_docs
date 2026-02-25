# WSJT-X Integration

The WSJT-X software written by K1JT, G4WJS and K9AN is widely used for FT8, FT4, MSK144 and other modes. It can be downloaded from [https://physics.princeton.edu/pulsar/k1jt/wsjtx.html](https://physics.princeton.edu/pulsar/k1jt/wsjtx.html)

Because it logs the contacts you make in both text and ADIF formats on the computer on which WSJT-X is installed, this can be used as a simple means of integrating with Wavelog.

By default, WSJT-X will save these files in the following folder c:\users\<name>\AppData\Local\WSJT-X

The plain text log file is named WSJTX.LOG and the ADIF file is named WSJTX_LOG.ADI.

You have a variety of options for integrating WSJT-X with Wavelog and these are outlined in the following sections.

## Manual Integration
At the most basic level of integration, you can grab the ADIF file and upload it into Wavelog manually from the "ADIF Import/Export" page.

## Wavelog Gate
Our new application, Wavelog Gate, is now available for use. It provides a user-friendly Windows interface that enables seamless communication between WSJT-X and JTDX applications with Wavelog. Check out [https://github.com/wavelog/WaveLogGate](https://github.com/wavelog/WaveLogGate) to learn more.

## WSJT-X improved plus versions by DG2YCB
There is a WSJT-X improved version available that is compiled by DG2YCB (part of the WSJT-X dev team) and contains a patch by DF2ET aka @phl0 that integrates Wavelog logging into the WSJT-X program directly. Be sure to enter only the base URL into the config (i.e. omit trailing slashes or further path specifications like index.php/api/qso). 

If you want to use it under Windows and your Wavelog is hosted on an SSL-enabled platform (i.e. access via HTTPS) you have to install the OpenSSL libraries for Windows separately. The version [Win64 OpenSSL v1.1.x Light](https://slproweb.com/products/Win32OpenSSL.html) should do fine. The v3.x branch does not work.

The WSJT-X improved versions can be downloaded from [sourceforge](https://sourceforge.net/projects/wsjt-x-improved/files/). Be sure to grab the PLUS or AL PLUS variant. The improved version itself lacks the Wavelog patch.

The relevant details can be found in the `Advanced` tab within the WSJT-X improved configuration. You have to specify the URL, an API key and a station profile number to log to.

## ADIFPUSH by M0LTE
M0LTE has written a file watcher program called adifpush which can be found at [https://github.com/M0LTE/adifpush](https://github.com/M0LTE/adifpush). This software requires .Net 2.1. Installation is well described in M0LTE's instructions. You will need a Wavelog API key (from Wavelog's ADMIN/API menu). Once installed, this program will monitor your WSJTX_LOG.ADI file for new contacts and upload them into Wavelog.

## Gridtracker
[Gridtracker](https://gridtracker.org/) is a popular companion application to WSJT-X and its derivatives. Its main feature is plotting decoded messages on a map but it also offers integrations with a variety of software, Wavelog included. To set up the integration:
1. First generate an API key within Wavelog (with read+write privileges)
2. Within Gridtracker click the gears icon in the right-hand tool palette to open the settings window
3. Select the _Logging_ tab
4. Check the _Log?_ checkbox in the Wavelog row of the table
5. Set the Wavelog URL appropriately. If Wavelog is running on the same machine as Gridtracker then the default IP of 127.0.0.1 is probably correct, otherwise you will need to change it to point to your Wavelog server.
6. Paste the API key that you generated in step 1 into the _API Key_ field underneath the URL
7. Press the _Test_ button to check that Gridtracker is able to connect to Wavelog using the API key

## Python Uploader

Cadair (M7STJ) has written a Python script which connects to WSJT via UDP and uploads ADIF QSO records to Wavelog: https://gist.github.com/Cadair/1e0a555deac70938b099b60097acde72

## Do you use JTDX?
There is a variant of WSJT-X called JTDX available at [https://sourceforge.net/projects/jtdx/files/](https://sourceforge.net/projects/jtdx/files//). You can still use any of the above methods if you are a JTDX user. However, if you need to locate the log and/or ADIF files then you will need to look in a different folder as JTDX saves its files in c:\users\<name>\AppData\Local\JTDX rather than c:\users\<name>\AppData\Local\WSJT-X 

In this case, you will need to make a small program change to ADIFPUSH if you are using this method. You'll need to edit program.cs to point at the JTDX directory rather than WSJT-X (take a backup copy, just in case!). Search for WSJT-X and you'll find a line containing 
Environment.SpecialFolder.LocalApplicationData),"WSJT-X","wsjtx_log.adi"

Simply change "WSJT-X" to "JTDX" and save the file. You should not need to recompile the .Net code.

Run ADIFPUSH and you should find it is now pointing at the JTDX AppData directory to find its' version of the wsjt-x.log file

## Important
Whenever you post QSOs to the API (via WavelogGate, via WSJT-X Improved, via $tool):
- it doesn't live post the QSO to QRZ (even if enabled), because of performance/errrorhandling/etc.
- it doesn't lookup the QSO-Partner at $callbook, because of performance/errrorhandling/etc.