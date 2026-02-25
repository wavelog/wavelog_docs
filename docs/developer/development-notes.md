# Development Notes
## Coding standards
Work in progress to define coding standards & rules to make things easier.

### General coding practices
* **ALL** Code must be commented - pull requests without code comments will not be merged till added
* Code shall be Tabbed 4 times 
* New Controllers must have an associated method to match, this must contain **ALL** features for this item, do not add items to other models
* Pull Request must be tested and if they aren't they will be rejected, no time frames given for merging its best efforts only
* `curl` shall be used instead deprecated `file_get_contents`
* Assets must be stored locally not CDNs and placed correctly within the `/assets` folder

### Javascript
* Any Javascript where possible must be stored within a separate file within `assets/js/sections` unless otherwise not suitable; jQuery is preferred

### SQL
* SQL queries must be limited and designed to be fast as possible; this keeps Wavelog as fast as possible
* SQL queries must use bind-variables wherever possible
* Plain SQL syntax is prefered over Codeigniter query builder

### Global Options
If you have a feature that requires a global configuration option - that is something that is needed for logged in or logged out, but isn't for just one user only then this should be placed in the Global 'options' table

The table has the following fields
* option_name - the name of the option
* option_value - the options value
* autoload - this is either `yes` or `no`, and will mean the options loaded for everyone or not, things like usernames and passwords shouldn't be autoloaded

### i18n
* Use gettext wherever possible
* Use `echo __("This is a string");` instead of `echo "This is a string";`
* If there are variable parts of the string, use the following: `echo sprintf(__("This is a %s text. It it's simple %s."), $variable, "<br/>");`
* `__([String])` method cannot be used on variables 
* Double quotes shall be used for translations `echo __("This is a string");`
* Javascript translation can be made by setting required i18n strings in [wavelog/application/views/interface_assets/footer.php](https://github.com/wavelog/wavelog/blob/7261290151912b25bc385b874f73c0a0d580be35/application/views/interface_assets/footer.php#L29-L58)

See [Translations](https://github.com/wavelog/wavelog/wiki/Translations) for more information

### Security guideline
* Never trust user input, this means: double check posted variables for scope. E.g.: page for Logbook-Editing shows only Logbook of logged in User. If you want to edit the book you pass the id of the Log to a function within the controller. The passed ID **MUST** be checked if it belongs to the User before processing
* All controllers, which modify data and which are invoked only by Users/Admin, **MUST** check if the User is authorized to call the functions. This is best done at the constructor
* All other controllers for visitors **MUST** check not to leak (protected) data
* All other controllers, invoked by cron, **MUST** not disclose any data to the User/cron which invokes the script. e.g.: LotW-Upload invoked by cron **MUST** not show which QSOs are uploaded
* Never assume default-values to critical functions
* The user inputs can be cleaned by `xss_clean([user input])` function of security module or by `input->get([user input], "TRUE")`

### Version Info Dialog
The Version Info Dialog is triggered only by the database, data is stored in two datatables:

* Datatable `options` - contains basic configuration of the version dialog

| option_name             | option_value                                       | autoload     |
|-------------------------|----------------------------------------------------|--------------|
| version_dialog          | release_notes, custom_text, both or disabled       | yes          |
| version_dialog_header   | Contains the header, can be edited in admin menu   | yes          |
| version_dialog_text     | Contains the custom text                           | yes          |

* Datatable `user_options` - contains the trigger, if `false` dialog will shown to the user. If the user click's "Don't show again" the `option_value` will be overwritten to `true`

| option_type     | option_name | option_key | option_value      |  
|-----------------|-------------|------------|-------------------|
| version_dialog  | confirmed   | boolean    | true or false     |

To trigger/overwrite the database for all users remotely (for an update) just use the following three lines in a migration script in the `functiopn up()`. 

```
// Trigger Version Info Dialog
$this->db->where('option_type', 'version_dialog');
$this->db->where('option_name', 'confirmed');
$this->db->update('user_options', array('option_value' => 'false'));
```

## Frontend
### Page Design
* Page functional headings are H2

### Button colors
- Blue = Solid = Add something, activate something, or perform any other primary action.
- Blue = Outline = Edit, change or update something.
- Red = Delete something or make an irreversible change.
- Grey = Deactivate something.
- Yellow = Reset something or clear a field (no permanent delete).
- Green = Search.

## Contribution:
* Is always welcome 😉 
* Must be _based_ on the latest **dev** (e.g. `git clone [your fork]`,`git checkout dev`, `git pull`, `git checkout -b my_contribution`)
* PullRequests must be created _against_ **dev** (e.g. `git request-pull my_contribution https://github.com/wavelog/wavelog.git dev` - or via the github gui **(recommended)**)