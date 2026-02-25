# Station-Locations

## What is it?
- It's a template for your locations/calls you're operating from.
- It's the easiest way to organize your QSOs.

## But why?
- You can easily provide information to your QSO that belongs to the used call/location, such as award references (e.g. POTA, WWFF, COTA, etc.).

One could say: But that information is already in an ADIF, so it’s nice to have a template, but not a must-have.

### What about these (necessary) things:
- You’re able to add custom eQSL information to each location (have a look at eQSL; it works also with locations).
- You can provide a custom QRZ key, because QRZ differentiates between calls/locations as well.
- You can switch off/on several third-party services for a specific location.
- You’re doing a special call activation and want to log with Wavelog? No problem: add a location with the call, don't provide third-party information, and start being QRV.

Once you see the advantages of this logic, you’ll see that’s fine.

### But what about my ADIFs from previous logbooks?
Bad news. Most other logs aren’t able to handle multiple third-party accounts of the same type (e.g. eQSL). To get your logbook clean, you have to split those ADIFs into locations. Once this is done, you’ll be able to benefit.

#### But why is there no "automatic station creation" when a new QSO appears?
Simple answer: How should Wavelog know about your third-party configurations? They’re not part of the ADIF. Even if one says, "Ignore it, just create a location," it’ll lead to huge problems. Example:

- You have multiple activations, let's say in GRID JO30:
    - with POTA
    - with WWFF
    - without a ref

Even these three attributes would lead to four possible combinations:
1. JO30 / POTA-Ref
2. JO30 / WWFF-Ref
3. JO30 / POTA-Ref and WWFF-Ref
4. JO30 / No Ref

And that example was only for one grid, one POTA, and one WWFF. Imagine the chaos if you're a rover.
Now think about adding a different eQSL-Image/Card for every activation. With Refs printed on it and maybe a nice picture (very common). This won't work via automatism

To create the best possible user experience, it's up to the user to organize their station-locations.

PS: The station-location principle is deep coded within Wavelog. Nearly everything is based on those locations. That means that Wavelog would need to be rewritten to change this. We have no such plans.