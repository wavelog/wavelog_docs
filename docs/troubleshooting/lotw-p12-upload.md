# Issues Uploading a LoTW p12 Certificate

## Certicates Exported from tqsl on MacOS

In some cases certificates exported from tqsl on MacOS seem to be using deprecated encryption algorithms which are not supported on recent OpenSSL versions used in Wavelog. The typical error message on a LoTW p12 certificate upload is `test` as shown on the following screenshot:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/be26ad1e-53d3-4248-9ba1-a603e8e79946" />

This can also be tested on the command line of a recent Linux system using OpenSSL:

```bash
$ openssl pkcs12 -info -in <LOTW_CERT_FILENAME>.p12
Enter Import Password:
MAC: sha1, Iteration 2048
MAC length: 20, salt length: 8
PKCS7 Encrypted data: pbeWithSHA1And40BitRC2-CBC, Iteration 2048
Error outputting keys and certificates
40C7FEE22E760000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:../crypto/evp/evp_fetch.c:386:Global default library context, Algorithm (RC2-40-CBC : 0), Properties ()
```

It shows `sha1` as MAC and `RC2-40-CBC` as encryption algorithm which both are deprecated and not supported on recent OpenSSL versions. For comparison a working certificate export would show:

```bash
$ openssl pkcs12 -info -in <LOTW_CERT_FILENAME>.p12
Enter Import Password:
MAC: sha256, Iteration 2048
MAC length: 32, salt length: 8
PKCS7 Encrypted data: PBES2, PBKDF2, AES-256-CBC, Iteration 2048, PRF hmacWithSHA256
Certificate bag
Bag Attributes
localKeyID: 37 A0 F5 EC 88 2A 3F F2 22 9A 8E ED 4D FC 1D 02 2A 4B BD F8
friendlyName: TrustedQSL user certificate
subject=1.3.6.1.4.1.12348.1.1 = <CALLSIGN>, CN = <NAME>, emailAddress = <EMAILADDRESS>
issuer=C = US, ST = CT, L = Newington, O = American Radio Relay League, OU = Logbook of the World, CN = Logbook of the World Production CA, DC = arrl.org, emailAddress = lotw@arrl.org
-----BEGIN CERTIFICATE-----
[...]
```

This shows `sha256` and `ARS-256-CBC` which are both recent and acceptable algorithms.

To be able to upload the certificate created on MacOS with deprecated algorithms there is a simple hack: Import the broken certificate into tqsl on a recent Linux (or Windows) system and re-export it (without password) from there. This way it should now make use of the non-deprecated algorithms and import into Wavelog just fine.

## Wavelog on Windows Platforms (WAMP)

There are various reasons why the upload of a LoTW p12 certificate fails. Here are a few hints that solve most issues.

If you are using Wavelog on a Windows WAMP platform you might need to configure your environment properly. In some cases the upload fails with the messge `error:10000080:BIO routines::no such file` like the following screenshot shows:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/7fafdb4d-70c6-474d-a8f8-60ad12a7715e" />

In this case you have to check if the OpenSSL extension is installed and activated in in your PHP configuration:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/5ed5bb6a-8278-457a-87a9-a3add83ae3f1" />

In a WAMP server (Windows) you have also to create an environment variable. But TAKE CARE WITH THE PATH OF THE FILE: It must be the path of the PHP version you are using (PHP 8.3.6 in this case):

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/7cf8754a-a71a-44d6-80aa-baa3d81fca64" />

**Make sure that the path to the environment variable is correct!**

If still does not work you can download and install OpenSSL for Windows from [https://slproweb.com/products/Win32OpenSSL.html](https://slproweb.com/products/Win32OpenSSL.html) depending on your Windows version. You can download the light version and install it as usual.

<img width="1021" height="451" alt="image" src="https://github.com/user-attachments/assets/46edfd73-e3c0-4578-8dbc-5b35ba291998" />

You also have to edit the PATH variable adding a wew line with the path of openssl.exe: C:\Program Files\OpenSSL-Win64\bin

<img width="1322" height="979" alt="image" src="https://github.com/user-attachments/assets/892f1ce7-1c41-4ac7-ac06-05ea9f944262" />

Restart your server and it should work.
