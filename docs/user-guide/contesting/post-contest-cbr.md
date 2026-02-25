# The post-contest workflow using the CBR importer.

Let's imagine a contest logged in N1MM+. The exchange is Serial-No, DOK and 4-digit Gridsquare. After importing in wavelog, you'll see the following message:

<img width="1304" height="562" alt="Infoscreen" src="https://github.com/user-attachments/assets/fc1a66d7-6076-49e9-9915-52be153aae12" />

The infoscreen mentions that your exchanges may not be properly imported. And we can see that in the logbook view - the DOK and Gridsquares seem to be missing:

<img width="867" height="132" alt="incomplete_import" src="https://github.com/user-attachments/assets/fd89938d-88d2-4dec-952f-af8b853162b7" />

So, to fix this, head over to ADIF Import/Export again, switch to the CBR-import tab, fill out the form there and import the CBR file you got from N1MM+. While you can import as many times as you like with different options until it looks right, please read the options carefully!

<img width="1314" height="557" alt="CBR_Import" src="https://github.com/user-attachments/assets/d686f6e7-ec11-4d2c-a4ec-edec0989cdf3" />

Afterwards, we see the full exchange in the logbook view:

<img width="864" height="136" alt="fixed_import" src="https://github.com/user-attachments/assets/cf942f27-f0ba-42e9-b5ca-60f02d0750b2" />

## Why can't we just import the CBR then?

See the full breakdown of the reasons [in this article](https://github.com/wavelog/wavelog/wiki/CBR%E2%80%90Import-%E2%80%90-Why-we-need-to-import-ADIF-first,-then-CBR-later). 