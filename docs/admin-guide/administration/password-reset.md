# Password Reset

For the unlikely case that you forgot the password of your user account in Wavelog and also deleted m0abc's account here is some help. This requires that you have access to the underlying MySQL database and are able to modify the stored password hashes.

Passwords are hashed using standard PHP mechanism. So there is an easy way to generate a new password using some PHP code.

Here is a quick and dirty example:

```php
<?php
defined('PASSWORD_BCRYPT') OR define('PASSWORD_BCRYPT', 1);
defined('PASSWORD_DEFAULT') OR define('PASSWORD_DEFAULT', PASSWORD_BCRYPT);
if ($argc == 2) {
        print password_hash($argv[1], PASSWORD_DEFAULT)."\n";
} else {
        print "No password provided! Exiting ...\n";
}
?>
```

This way you can execute the PHP script locally and provide your password as commandline argument. E.g. (you stored the code as password.php):

```bash
php password.php thisismynewpassword
```

Use the output string as value for the column user_password for the desired user account in the MySQL table (wavelog.)users.

## Quick Solution

And here is the hint for the even lazier OM:

Set the hash to `$2y$10$GEC9KcLJae5Bhwtabd5jJOi49h0uODskozZ2vrrnJZ1EY5BB6NyYq` and use `AskDK9JCforThePassword` as password. Don't forget to change your password after login ;-)
