# Station-Locations

## What is it?

- It's a template for locations, calls, and references you're operating from.
- It's the organizational system Wavelog uses to differentiate QSOs by grid, callsign, and reference.

## But why?

This organizational layer allows Wavelog to assign QSOs to different third-party systems such as awards, contests, and activities. It also allows you to claim credit for QSOs you worked with special event or foreign reciprocal callsigns.

One could say: But that information is already in an ADIF, so it’s nice to have a template, but not a must-have.

!!! info Nice explaination by DB4SCW
    DB4SCW wrote a great description about Station Locations in Wavelog. We highly recommend that: <a target="_blank" href="https://www.db4scw.de/station-locations-in-wavelog-and-pota/">https://www.db4scw.de/station-locations-in-wavelog-and-pota/</a>

### What about these (necessary) things

- You’re able to add custom eQSL information to each location (have a look at eQSL; it works also with locations).
- You can provide a custom QRZ key, because QRZ differentiates between calls/locations as well.
- You can switch off/on several third-party services for a specific location.
- You’re doing a special call activation and want to log with Wavelog? No problem: add a location with the call, don't provide third-party information, and start being QRV.

Once you see the advantages of this logic, you’ll see why we use Station-Locations.

The station-location principle is deep coded within Wavelog. Nearly everything is based on those locations. That means that Wavelog would need to be rewritten to change this. We have no such plans.

### But what about my ADIFs from previous logbooks?

Not all logging applications understand multiple third-party accounts of the same type (e.g. eQSL).

To import from applications such as these, there are two options. Either:

- Split those ADIFs up, one for each Station-Location. Create the corresponding Station-Locations and upload each ADIF separately. Or,
- Use a third-party tool to automate the upload.

#### But why is there no "automatic station creation" when a new QSO appears?

Simple answer: There are too many possible configurations, and Wavelog cannot maintain compatibility with every new award, contest, and activity. Example:

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
Now think about adding a different eQSL-Image/Card for every activation. With Refs printed on it and maybe a nice picture (very common). The possibilities are endless, and so Wavelog delegates these highly specific scenarios to the user.

Manual Station-Location management is usually the most foolproof. However, automated third-party tools can use the API to attempt to assign Station-Locations to QSO uploads. When creating an API token for such applications, a preset for the necessary scopes is available: "Log and Station Upload". You must keep your Station-Locations in order, so always be careful with automated tools.
