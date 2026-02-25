# Windows (WAMP)

!!! warning
    Running Wavelog on Windows does work, but it is not recommended. Windows was not designed with web server hosting in mind (depending on Windows version), and running the full LAMP/LEMP stack (Linux, Apache/Nginx, MySQL, PHP) natively on Windows introduces unnecessary complexity, compatibility issues, and performance overhead. Most dependencies Wavelog relies on are built and tested primarily for Linux environments, meaning you may encounter subtle bugs, missing features, or unexpected behaviour that would simply not occur on a Linux system.

## Installing Wavelog on Windows using a local web server
!!! note
    Older guides and tutorials may reference WAMP or XAMPP as the recommended local web server stack for Windows. Both projects have become increasingly outdated and are no longer actively maintained at the same pace as modern alternatives. We now recommend using [Laragon](https://laragon.org/) instead, which is actively developed, easier to configure, and provides a much smoother experience for running PHP applications like Wavelog on Windows.

### Step 1: Download and Install WAMP

There are many tutorials available online, such as [this guide on Developer Drive](https://www.developerdrive.com/installing-and-configuring-a-wamp-server-on-your-computer/).

After installing WAMP, you will have a `WAMP` folder on your hard drive containing a `www` subfolder, which is where your web projects live. For Wavelog, create a dedicated folder inside `www` — for example, `wavelog`. Your final path should look like this:

```
C:\wamp\www\wavelog
```

This is where all Wavelog files will be placed after completing Step 2.

!!! tip
    If you want to access Wavelog from outside your local network, you will need to open **port 80** on your router (refer to your router's manual) and either know your public IP address or use a dynamic DNS service such as [No-IP](https://www.noip.com/) (free) or [DynDNS](https://dyndns.com/) (paid).

---

### Step 2: Download and Install Git

Download and install Git for Windows from [git-scm.com](http://git-scm.com/download/win) like any normal Windows application.

---

### Step 3: Clone the Wavelog Repository

Open **Git CMD** and navigate to your `www` folder:

```
cd C:\wamp\www
```

Then clone the Wavelog repository:

```
git clone https://github.com/wavelog/Wavelog.git
```

Once complete, you will have a `Wavelog` subfolder inside `C:\wamp\www` containing all the necessary files.

---

### Step 4: Run the Install Wizard

Open your browser and navigate to:

```
http://localhost/wavelog/install
```

Follow the on-screen instructions. The database details are as follows:
* URL: localhost
* Username: root
* Database name: wavelog
* The default password is blank, so unless you changed it, leave it blank.

!!! warning
    Remember to remove or rename the `install` folder inside your Wavelog directory after the installation is finished.

---

### Accessing Wavelog

Once installation is complete, you can open Wavelog in your browser at:

```
http://localhost/wavelog
```

Or, if accessing from another network, replace `localhost` with your public IP address. Log in and navigate to **ADIF Import/Export** to import your existing QSOs.

!!! warning
    If you have problems to upload your LoTW Certicate (P12 file) take a look at the [Troubleshooting](https://github.com/wavelog/wavelog/wiki/LoTW-P12-file-%E2%80%90-Not-possible-to-upload) on this wiki

!!! warning
    QRZ Callbook lookup will not work unless you install a certificate.
    Proper fix:

    * Download the latest CA certificate bundle from: https://curl.se/ca/cacert.pem

    * Save it somewhere on your system (e.g., C:\wamp64\bin\php8.3.14\cacert.pem) (PHP version may differ, so make sure you choose correct folder)
    * Edit your php.ini file (you can access it via WAMP tray icon → PHP → php.ini)
    * Find the line ;curl.cainfo = and change it to:

    inicurl.cainfo = "C:\wamp64\bin\php\cacert.pem"

    * Restart WAMP
