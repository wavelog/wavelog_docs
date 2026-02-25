# Third-Party Tools

Directory of all third-party tools that can integrate with Wavelog.

!!! warning
    Remember, these are not our work. If you need support, go to the authors pages and ask there.

# Rig Control

* [WLGate](https://github.com/wavelog/WaveLogGate) FLRig and UDP-Integration for CAT Connectivity (e.g.: WSJT-X and CAT to Wavelog). Available for Win, Mac and Linux
* [Wavelog_CI_V](https://github.com/dg9vh/Wavelog_CI_V) Wavelog CI-V (Icom) Connector on ESP32
* [WLBridge4TRX](https://github.com/zone11/WLBridge4TRX) WLbridge for Yaesu, Elecraft and other radios
* [CloudlogTCI](https://github.com/anthonydiiorio/CloudlogTCI) TCI bridge for [Expert Electronics](https://eesdr.com/en/)
* [WavelogGoat](https://github.com/johnsonm/WaveLogGoat) Lightweight Gate without UI
* [Wave-Flex Integrator](https://github.com/tnxqso/wave-flex-integrator) A direct bridge for FlexRadio users without requiring CAT middleware.

# Third Party Platforms

* **[Umbrel](https://umbrel.com/umbrelos)** is a personal server OS that lets you easily run self-hosted apps on your own hardware.  
You can now easily install Wavelog on your Umbrel server from the [Umbrel App Store](https://apps.umbrel.com/app/wavelog).

# Offline Logbooks

* [cloudLogOffline](https://github.com/myzinsky/cloudLogOffline)

# Tools
## Important Information (even if obvious!)
If you're using multiple 3rd-party tools (e.g. Gridtracker in combination with WSJT-X and WavelogGate) make sure that **ONLY ONE** Tool emits the QSOs to Wavelog. Otherwise you may receive errors regarding dupes, because every tool tries to send the same QSO to Wavelog.

Furthermore: QSOs from 3rd party tools won't be looked up in callbook automatically. This has serveral reasons. The important ones:
1. The API can be used for bulk-uploads, e.g. like POLO is doing. Bulk-Lookup would block whole instance.
2. If the information isn't given in a Computer to computer QSO (like FT8), why add them automatically?
3. Workaround: Mark those QSOs at Logbook-Advanced, press actions, press "Update from Callbook" --> Done.

* [GridTracker](https://gridtracker.org/) Automatically log and map WSJT modes
* [fldigi_log](https://github.com/DL3EL/FLDigi_Log) synch qrg & mode and automatically upload new entries from FLDigi
* [sparksdr_log](https://github.com/DL3EL/SparkSDR_Log) synch qrg & mode and automatically upload new entries from SparkSDR
* [wsjtx_log](https://github.com/DL3EL/WSJTX_Log) synch qrg & mode and automatically upload new entries from WSJT X
* [adif2cloud](https://github.com/imlonghao/adif2cloud) monitor ADIF file changes and distribute new QSO to multi destinations
* [DX Cluster Web](https://github.com/oliverbross/dx-cluster-web) Extended DX Cluster gui that works with Wavelog
