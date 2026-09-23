# LoTW P12 File – Not Possible to Upload

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
