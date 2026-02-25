# Important (for all 3rd party services)
Wavelog WON'T Download your full log.
You need to have the QSO already in your log. Wavelog ONLY uses the 3rd party-services for QSL (confirmations).
Once a confirmation (for a logged entry) is fetched you'll see a "green downpointing arrow" indicating the QSO has been confirmed.

# Clublog
Club Log integration at the moment inside Wavelog is a bit clunky I'll admit, but we will improve it over time, to set up syncing within Wavelog edit the user you have logged in with.
In the edit screen at the bottom, you will see it requesting

* Club Log Email/Callsign
* Club Log Password

Provide these and save, These details are what you will use to allow Club Log to accept communication from Wavelog.

Next, you can test it works by going to `<url-to-wavelog> /index.php/clublog/upload/> `you should see a success message if it worked, Wavelog will need write access to the /uploads folder.
We recommend you run this as a cronjob

`0 */6 * * * curl --silent https://<url-and-path-to-wavelog>/index.php/clublog/upload/> &>/dev/null`

The code will look through all station locations with username and password set. It will then upload QSOs from these locations.

## Club Log Real-Time
Wavelog supports sending to the Club Log realtime API, due to the design of Wavelog to run on a web server, you need to setup a cronjob to run every minute or so

```bash
*/2 * * * * curl --silent https://<url-and-path-to-wavelog>/index.php/clublog/realtime/<The-Wavelog-Username-You-Just-Added-Logins-To>  &>/dev/null
```

## Club Log SCP File

Wavelog can use the Club log SCP file to hint at what a callsign might be when logging which can be helpful you can download this from `https://<url-and-path-to-wavelog>/index.php/update/update_clublog_scp` we could recommend running this on a weekly cronjob to keep it current.

```bash
@weekly curl --silent https://<url-and-path-to-wavelog>/index.php/update/update_clublog_scp &>/dev/null
```