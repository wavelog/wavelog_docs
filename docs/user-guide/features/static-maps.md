# Static Map API 

The Static Map API offers an easy way to get static map images in JPG format. This URL can configured with some options how you want the map to look like and the paste it somewhere in the World Wide Web. For example in your QRZ.com bio. 

## Usage

You set the options as `GET` parameter in the URL. The base URL looks like:  
  
`https://[wavelog url]/index.php/staticmap/render/[slug]`

[slug] can be defined in _Visitor site_ at the _Station Setup_
See:
![Enable Visitor site](https://github.com/user-attachments/assets/8802fbbb-e097-4de7-857b-7cbaf784f693)
![Define a public slug](https://github.com/user-attachments/assets/8fef9577-b6f3-470c-9752-2434bf26ddab)

Options:  
  
`https://[wavelog url]/index.php/staticmap/render/[slug]/?[option0]=[value]&[option1]=[value]&[option2]=[value]`

Possible `GET` Options currently implemented:

!!! note
    All Options are optional! 
    The `qsocount` option overrides the user option for exportmaps

| option | value | default |
|----|----|----|
| `qsocount`     | amount of QSOs displayed on the map  | value in exportmap options or `250` |
| `band`     | display `qsocount` QSOs of the certain band  |  | 
| `continent`     | you can display a dedicated continent view.  recommended to use with `qsocount`, use continent format like `AF`, `AS`, `EU`, `NA`, `OC`, `SA`, `AN` |   | 
| `hide_home`     | set to `1` if you want to hide your location on the map  |  `0` | 
| `theme` | overrides the global appeance theme. Set `light` or `dark` | global appearance option |
| `ns` | Enabled the Nightshadow Overlay. Set `1` or `0` | value in exportmap options or `0` | 
| `wm` | Enabled/Disabled Wavelog Logo Watermark. Set `1` or `0` | `1` |
| `pl` | Shows the Pathlines Overlay. Set `1` or `0` |  value in exportmap options or `0` |
| `cqz` | Shows the CQ Zones Overlay. Set `1` or `0`. **Attention**: This one needs some time to render. Make sure Development Mode is disabled to use caching |   value in exportmap options or `0` |
| `ituz` | Shows the ITU Zones Overlay. Set `1` or `0`. **Attention**: This one needs some time to render. Make sure Development Mode is disabled to use caching |   value in exportmap options or `0` |
| `orbit` | shows satellite qso's based on an orbit filer. Set `GEO`, `MEO` or `LEO` |  | 
| `contest` | shows only qso's with this contest id. Set accordingly to contest adif name (see in admin menu -> contests) |  | 
| `start_date` | shows qso's after this date. Set `YYYY-MM-DD` |  | 
| `end_date` | shows qso's before this date. Set `YYYY-MM-DD` |  | 
| `day` | valid values either `today` or `yesterday` |  |

### Example

Definition: Show the last 500 QSO on the 160m Band with Pathlines enabled but Nightshadow disabled

`https://[wavelog url]/index.php/staticmap/render/[slug]?qsocount=500&band=160m&pl=1&ns=0`

### Caching

This feature uses four caches. 

The icons which are used in the map based on the user settings.
The maptiles are cached based on theme and maparea.
The CQ or ITU Zone Overlay for the requested map.
The Image itself is cached based on all options and logbook. 

To temporarily disable caching, enable the Development mode. To clear the image cache you can:

- log a qso or import an adif
- edit user settings
- edit the logbook
- edit a station location

To completely clear the cache remove the three folders: `fas_icons_cache`, `staticmap_images`, `tilecache`
