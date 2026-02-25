# LoTW Synchronisation

> This is the start of the documentation for setting up LOTW synchronisation within Wavelog probably not for the faint-hearted.

## Server Setup

### Folder for P12 Keys

For Wavelog to process LOTW uploads, it has to hold the .p12 key, this needs to be stored within a folder outside of the website root and security held and within ARRL LoTWs guidance encrypted on the file system.

* You can select the location to upload these files within /config/lotw.php