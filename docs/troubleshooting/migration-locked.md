# Migration Is Locked

If you see such a warning, it can have several causes.

<img width="611" alt="image" src="https://github.com/user-attachments/assets/57313903-3efa-4540-9377-72760e832f00">

The main reason is that the lock file, which locks the migration process to prevent it from running twice, wasn't properly deleted. This can happen if the web server does not have write access to the specific path or if a migration failed for some reason.

You can try to delete the lock file manually if the warning persists after the maximum lifetime of the lock file (default: 300 seconds).

The lock file is located in the web server's `/tmp` folder. Depending on your system, this can be the actual path `/tmp` or a sandbox tmp folder. For example, on a standard Debian installation with Apache2, the `/tmp` folder exists in a systemd subfolder (like a sandbox). Therefore, you may find the migration lock file in a path like:

`/tmp/systemd-private-09d13ddfc33841b5f63d1bb26a7e6a99-apache2.service-gZiG7a/tmp/.migration_running`

To find this file more quickly, you can use the following command (example command for a standard Linux installation):

```bash
find /tmp -name ".migration_running" -type f -print
```

Returns for example: `/tmp/systemd-private-09d13ddfc33841b5f63d1bb26a7e6a99-apache2.service-gZiG7a/tmp/.migration_running`

You can delete this file with:

```bash
rm [the path shown from the find command]
```

Then reload the debug information page and check if the warning persists. If you still have problems to get it running, create a new discussion in the [Wavelog GitHub discussions](https://github.com/wavelog/wavelog/discussions).
