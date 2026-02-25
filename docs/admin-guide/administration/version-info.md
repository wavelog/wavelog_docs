## Version Info

The **Version Info** introduces a feature in Wavelog to display current release information or messages from the admin directly to users. There are various ways to customize, show, and hide this dialog. Customizing the Version Info is reserved for administrators. In the global options, admins can choose the following display modes (Version Info Mode):

- **Only Release Notes:** Only the information from the latest release is fetched directly from Github and displayed.
- **Only Custom Text:** Only the custom text is displayed. This must be defined in the global options.
- **Both (Release Information and Custom Text):** Both the custom text and release information are displayed in the dialog.
- **Disabled:** The dialog is not automatically displayed. However, it can still be shown through the user menu.

The Version Info is triggered solely through the database. No session data or cookies are stored to trigger the display of the Version Dialog. An admin has the option to manually trigger the automatic show or hide of the dialog through the global options. This action will overwrite all confirmations stored in the database.
