## Clubstations

Since **Version 2.0**, Wavelog has provided sophisticated support for Clubstations and Special Callsign Operations. This documentation explains everything you need to know, from setup and configuration to usage.

!!! info "Important"
    This feature replaces the Operator Callsign Popup feature (config item: `'special_callsign'`).

---

### Prerequisites

Before setting up Clubstations in Wavelog, there are some important points to understand about how the Clubstation feature works.

- **Clubstations** are essentially normal users in the database with an additional flag that marks them as a Clubstation account. This flag can only be modified by a Wavelog Administrator (`user_type == 99`).
- Once a Clubstation is created, either Admins or **Club Officers** (we’ll discuss permissions in the next section) can add, remove, or edit users associated with the Clubstation.
- These users can then **"impersonate"** the club account. For example, the user HB9AAA can switch to the clubstation account HB9BBB.

---

### Permission Levels

There are currently two permission levels for Clubstations. These levels are **independent** of the core permission levels in Wavelog and are defined in the `club_permissions` table for each user per club.

#### Club Members

Club Members can switch to a Clubstation and log QSOs. They cannot edit or delete QSOs made by another operator and have other restrictions.

#### Club Members ADIF (since v.2.2.1)

Club Members ADIF receive the same grants like a Club Member. On Top they're allowed to upload ADIFs and Download ADIFs for the QSOs they made

#### Club Officers

Club Officers act as managers of the Clubstation. They have access similar to a normal Wavelog **Operator** account (but without Admin rights for the Wavelog installation). They can manage the Clubstation by adding existing users or modifying their permission levels. However, they cannot create new user accounts—this must still be done by an Admin. A user can be both a Wavelog Admin and a Club Officer for one or more Clubstations simultaneously.

#### Overview

<img width="1024"  alt="image" src="https://github.com/user-attachments/assets/cfcb29b0-c392-4f6d-9952-f9cb26722673" />


---

### Setting Up a Clubstation

To set up a Clubstation, you need to be a Wavelog Admin with access to the `config.php` file.

1. **Enable the Clubstation feature** by editing your `config.php` and setting:

    ```php
    $config['special_callsign'] = true;
    ```

    In newer installations, you can find this value in **line 691**. If not, you may need to update your `config.php` manually based on `config.sample.php`.  
    If this config item was already enabled for the old "Operator Callsign Popup" feature, no changes are needed.

    !!! note
        The config item `$config['sc_hide_usermenu']` is no longer in use.

2. Go to **User Management** (Admin → User Accounts).

    If you previously set up a Clubstation using the Operator Dialog, you may already have a user account for the Clubstation. You can convert this existing account to a Clubstation by selecting the **"Other Actions"** button.

    Otherwise, create a new Clubstation account in the second table below the users table.

3. After creating a Clubstation, click the button for **Club Permissions**.

    <img width="217" alt="Club Permissions Button" src="https://github.com/user-attachments/assets/725fd5e4-8bda-41ec-92ab-55c08af3e651" />

    This will take you to the **Club Permissions Page**, which is the same view accessible by a Club Officer.

    <img width="1330" alt="Club Permissions Page" src="https://github.com/user-attachments/assets/189684a0-3564-4b27-8ef8-310dfc1356f6" />

    Here, you can add existing users to the Clubstation or modify their permission levels.  
    **Note:** A Club Officer cannot create new users; this must be done by an Administrator.

    Added users can now access the Clubstation with their assigned permission level.

---

### Accessing a Clubstation

As mentioned earlier, Clubstations are normal user accounts with a special flag in the database. To access a Clubstation, you must be a member of it. Once you have been added, you will see an additional menu item in the upper right header.

<img width="487" alt="Switch to Clubstation" src="https://github.com/user-attachments/assets/f6d27a15-4f64-4db8-8854-b7d34a045859" />

After clicking this button and confirming the action, you will successfully switch to the Clubstation.

<img width="487" alt="Clubstation Confirmation" src="https://github.com/user-attachments/assets/f08df0d6-31d7-45e4-a9ee-71500c96902e" />

To switch back, either **log out and log in again** or use the **"Switch back to XY"** button located above the logout button.

---

### API Keys and Radios

Each user who switches into a Clubstation can have their own API keys and radios. Club Members can only see the API keys and radios they created themselves. Club Officers can see all API keys, including who created them, though the keys of others are masked.

<img width="1259" alt="API Keys and Radios" src="https://github.com/user-attachments/assets/e7d1f39e-58a6-423f-85fe-d8c14fb7a4cb" />

---
## Special Cases

### Direct Clubstation Login

In some cases, for example public accessible stations it's cumbersome to create for each operator it's own user account. This would be normally required in a regular clubstation setup. In such cases you can use a "hidden" config option which allows to directly login into the clubstation

```php
$config['club_direct'] = true;
```
This option is default `false` to preserve the normal behaviour or clubstations. If it set to yes you can directly login into a clubstation account. This will trigger a modal dialog after login since the user callsign (clubstation are user accounts aswell) of the clubstation and the currently set operator callsign in the session data is equal. Since this is not wanted in clubstations you are forced to provide an operator callsign. 

<img width="520" height="391" alt="grafik" src="https://github.com/user-attachments/assets/220b5a24-8c49-41ed-ac5a-3e53895a8a49" />
