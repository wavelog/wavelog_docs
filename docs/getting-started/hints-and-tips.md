## Chrome Browser (Windows Desktop) Shortcut

If you use Google Chrome to use Wavelog you can create a desktop shortcut with the following properties

`"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
--app="<URL-To-Wavelog>"`

This will open a browser window with no menu, address bar and tabs giving you a kind of desktop feel to your logging.

## If you want to host your Wavelog in China mainland

### ICP record number

Due to legal requirements in China mainland, all websites hosted in China mainland should post its ICP record number. You may edit `./application/views/interface_assets/footer.php` to add the required information for website registration.

### Map Provider

Another issue is that the default map provider of Wavelog does not have a license in China mainland. To avoid potential risk, a map provider with map review number like Tianditu/Baidu Map/AutoNavi will become a much better selection.

To change the default provider, you may have to update the value of row `map_tile_server` of table `option` in the database


## API-Ratelimiting (Requires Wavelog V2.2.3 at least)
You can now rate-limit API-Calls. Note: It isn't enabled by default!

The Ratelimiter checks the API-Key. Reading-Example for `'lookup' => ['requests' => 100, 'window' => 60],`:
- Allow 100 Requests for ONE API-Key within a sliding 60sec. Windows
- Exceeded? 429 returned
- This is per key/session. So if you have two Users doing 150 or up to 200 requests per 60seconds in sum, it is fine.

Edit your `config.php` and add the following entries to it / adjust it to your needs:

```
$config['api_rate_limits'] = [
     'private_lookup' => ['requests' => 60, 'window' => 60],
     'lookup'         => ['requests' => 100, 'window' => 60],
     'qso'            => ['requests' => 20, 'window' => 60],
     'radio'          => ['requests' => 60, 'window' => 60],
     'statistics'     => ['requests' => 30, 'window' => 60],
     'default'        => ['requests' => 50, 'window' => 60],
 ];
```