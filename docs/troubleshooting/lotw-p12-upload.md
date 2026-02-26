# LoTW P12 File – Not Possible to Upload

Some times, as in my case, uploading p12 file is not possible:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/7fafdb4d-70c6-474d-a8f8-60ad12a7715e" />

In this case, first you must check if openssl extension is installed in your PHP:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/5ed5bb6a-8278-457a-87a9-a3add83ae3f1" />

In a WAMP server (Windows) you have also to create an environment variable, but TAKE CARE WITH THE PATH OF THE FILE, it must be the path of the php version you are using:

<img width="1280" alt="image" src="https://github.com/user-attachments/assets/7cf8754a-a71a-44d6-80aa-baa3d81fca64" />

**Make sure that the path to the environment variable is correct!**

If still doesn't work, you can install openssl for windows downloaded from [https://slproweb.com/products/Win32OpenSSL.html](https://slproweb.com/products/Win32OpenSSL.html) depending on your windows version. You can download the light version and install it as usual.

<img width="1021" height="451" alt="image" src="https://github.com/user-attachments/assets/46edfd73-e3c0-4578-8dbc-5b35ba291998" />

You also have to edit the PATH variable adding a New Line with the path of openssl.exe: C:\Program Files\OpenSSL-Win64\bin

<img width="1322" height="979" alt="image" src="https://github.com/user-attachments/assets/892f1ce7-1c41-4ac7-ac06-05ea9f944262" />

Restart your server and it should work

73 de EA5WA
