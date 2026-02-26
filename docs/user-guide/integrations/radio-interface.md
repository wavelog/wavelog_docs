# Radio Interface

The Radio Interface area of Wavelog allows you to control radios which are available within the Radio dropdown, at any time you can delete a radio if you no longer require it.

It's possible to interface Wavelog to amateur radio equipment via external APIs at the moment this is possible using the following tools.

These third-party tools require API keys which can be generated from _**Admin -> API**_

## CAT Control

Highly recommend checking the [Third Party Tools](../../user-guide/integrations/third-party-tools.md) page on the wiki for a full list of radio interface applications.

We recommend [WavelogGate](https://github.com/wavelog/WaveLogGate) created by Joerg (DJ7NT). This cross-platform tool works on Mac, Windows and Linux and provides a GUI tool to interface FlRig to Wavelog via the API.

Due the fact that Wavelog is a Fork of Cloudlog you also can use some Cloudlog Tools like:  

- [cloudlog-rigctl-interface](https://github.com/Manawyrm/cloudlog-rigctl-interface)
- [CloudlogBashCat](https://github.com/g0wfv/CloudlogBashCat)

## Select the Radio in the QSO Panel

<img width="1356" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/ff16adf8-e567-4a07-86bc-d3fc24fe99de">

After configuring the Radio, you need to select what you'd like to use for QSOs, to do this go to the QSO area, then the **Station** tab, then find **Radio** this is a drop-down select menu, select the correct radio then Log a QSO, this option will be set as a cookie and will be remembered in till you unselect it or the cookie expires.

## Configuring a callback URL for a radio

This feature allows sending data from Wavelog to a software which is connected to one of the configured radio, allowing new functionalities like clicking an entry in the Bandmap (a.k.a. cluster) and tuning the selected radio to that frequency.

!!! note
    The callback operation is performed on the same browser where the cluster entry is clicked, this means that using 127.0.0.1 as callback URL will send the frequency set request to the same PC where Wavelog is accessed

Once the radio devices are properly talking with Wavelog (see the sample code snippet below, or by using any supported third-party software), and listed in the `Hardware Interfaces` page, each radio can be configured with its own callback URL by clicking the `Edit` button.

Whenever an entry in the Bandmap is selected, the callback URL will be notified and whatever client software is used, should tune the radio to such frequency.

By default, the callback URL is the same address which is currently browsing the Wavelog instance, thus `127.0.0.1:54321`. A TCP server should be listening on that machine on port `54321`, where a GET request is performed as soon as an entry in the cluster is selected. The target URL will be something like: `http://127.0.0.1:54321/7010600/cw` to tune the transceiver to 7010.6 KHz in CW mode.

## Code snippets

### Sample python code to send radio data to Wavelog

The following code snippet can be used to send data to the Wavelog Radio interface.

!!! note
    This is just a demonstration/testing script, it is not reading frequency from any device. A proper connection routine to the transceiver should be added and some loop or other trigger should be used to send the update to the Wavelog instance

```python
import requests
from datetime import datetime

WAVELOG_API_URL = "http://wavelog.localhost/index.php/api/radio"
WAVELOG_API_KEY = "aaBBccDDeeFFgg"
RADIO_NAME = "ICOM IC-7850"

# Define required headers
headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
}

payload = {
   "key": WAVELOG_API_KEY, 
   "radio": RADIO_NAME,
   "frequency": 14075000,
   "mode": "SSB",
   "power": '', # Optional field defined in watts
   "timestamp": datetime.now().strftime("%Y/%m/%d %H:%M")
}

# Send the POST request
try:
    response = requests.post(WAVELOG_API_URL, json=payload, headers=headers)
    # Check if the request was successful
    if response.status_code == 200:
        print("Request successful!")
        print("Response:", response)
    else:
        print(f"Request failed with status code: {response.status_code}")
        print("Response:", response.text)
except requests.exceptions.RequestException as e:
    print("An error occurred:", e)

```

#### Test

Now we can check if everything was set up correctly.

First we need to make sure the python dependencies were installed

```bash
pip install requests
```

Then we can run the script

```bash
python ./main.py
```

If all the parameters in the configuration file were set up correctly, we should see:

```bash
$#> python .\main.py
Request successful!
Response: <Response [200]>
```

And when accessing the `Hardware interfaces` option in the user menu, we should see the new Radio device being listed with the right frequency.

### Receiving frequency tune requests

The following Python code starts a TCP server on port 54321 and will print to the console the data in the GET request and can be used to check if the callback is working as expected

```python
import socket

HOST = '127.0.0.1'
PORT = 54321

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
    server_socket.bind((HOST, PORT))
    server_socket.listen()
    print(f"Listening on {HOST}:{PORT}...")
    
    conn, addr = server_socket.accept()
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024)
            if not data:
                break
            print(f"Received: {data.decode()}")
            conn.sendall(data)  # Echo the received data back to the client
```

After accessing the Wavelog instance using the WebBrowser, and assuming the callback URL is properly configured for the radio selected in the Bandmap page, the following output should appear as soon as an entry is selected from the list:

```bash
PS F:\Documenti\GitHub\WaveLogGate> python .\test.py
Listening on 127.0.0.1:54321...
Connected by ('127.0.0.1', 51492)
Received: OPTIONS /7010600/cw HTTP/1.1
Host: 127.0.0.1:54321
Connection: keep-alive
Access-Control-Request-Method: GET
Access-Control-Request-Private-Network: true
Origin: https://log.example.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36
Sec-Fetch-Mode: cors
Sec-Fetch-Site: cross-site
Sec-Fetch-Dest: empty
Accept-Encoding: gzip, deflate, br, zstd
Accept-Language: it-IT,it;q=0.9,en-US;q=0.8,en;q=0.7,es-US;q=0.6,es;q=0.5
```
