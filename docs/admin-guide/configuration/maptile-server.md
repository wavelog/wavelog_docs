## Maptile Server Options

You can configure another maptile server then the default one. Especially interesting is this for chinese hams. 
Settings can be found at **Admin > Global Options > Maptile Server**

### Tested Map Servers

**OpenStreetMap International**
```
Maptiles Server URL:                                         
https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png

Maptiles Server URL for Dark Tiles - ONLY Static Map API:    
https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png

Subdomain System of Maptile Server:                          
abc

URL of the Copyright Source:                                 
https://www.openstreetmap.org/

Name of the Copyright Source:                                
OpenStreetMap
``` 

**OpenStreetMap German Map Descriptions**
```
Maptiles Server URL:                                         
https://tile.openstreetmap.de/{z}/{x}/{y}.png

Maptiles Server URL for Dark Tiles - ONLY Static Map API:    
use default (No good provider for dark tiles, but the default has english describers instead international. So at least it's readable)

Subdomain System of Maptile Server:                          
abc

URL of the Copyright Source:                                 
https://www.openstreetmap.de/

Name of the Copyright Source:                                
OpenStreetMap DE
``` 

**Chinese Autonavi**
```
Maptiles Server URL:
https://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=7&x={x}&y={y}&z={z}

Maptiles Server URL for Dark Tiles - ONLY Static Map API:
unknown - use default (There's no usable provider offering dark tiles. The cartocdn works in China.)

Subdomain System of Maptile Server: 
1234

URL of the Copyright Source:
https://lbs.amap.com/

Name of the Copyright Source:
AutoNavi
```