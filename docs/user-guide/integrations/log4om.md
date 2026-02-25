# log4OM Integration


# Log4OM Integration

## Log4OM
[Log4OM](https://www.log4om.com/) is a free, modern logging software for amateur radio operators. It runs on Windows and provides complete station management, including:
- **QSO logging** with award tracking and contest support
- **Integration** with services like LOTW, eQSL, QRZ.com, Clublog, HamQTH, HRDlog.net
- **CAT control** via OmniRig or Hamlib
- **Propagation analysis** using VOACAP
- **UDP inbound/outbound support** for external applications
## Integration with Wavelog
Log4OM can automatically publish QSOs to a Wavelog instance using WaveLogGate.

### Steps:
1. **Download and run WaveLogGate** ([Download Link](https://github.com/wavelog/WaveLogGate))
   Get the application from its GitHub repository, install and configure as in [ReadMe](https://github.com/wavelog/WaveLogGate/blob/master/README.md) and ensure it is running.

2. **Configure Log4OM settings**  
   Go to **Settings → Software Integration / Connection** and create a new **UDP outbound entry**:
   - **Name:** `wavelog`
   - **Port:** `2333`
   - **Type:** `ADIF_MESSAGE`

   Configure everything as shown in the screenshot below:

<img width="1134" height="578" alt="image" src="https://github.com/user-attachments/assets/8409807a-39f4-4ee9-970f-eeb01abc71bd" />

---

**Tip:** Ensure WaveLogGate is running before enabling the integration in Log4OM
