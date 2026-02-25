# Error Logging Threshold

To enable or change the logging threshold, you need to edit your `config.php` file. This file is located in the `application/config/` folder.
Look for the line with `$config['log_threshold']`.

!!! tip
    If you are using the Docker image, the config file is located at `application/config/docker/config.php`. A restart of the container might be needed after changing the values.

You can enable error logging by setting a threshold over zero. The threshold determines what gets logged. Threshold options are:

```
0 = Disables logging, Error logging TURNED OFF
1 = Error Messages (including PHP errors)
2 = Debug Messages
3 = Informational Messages
4 = All Messages
```

You can also pass an array with threshold levels to show individual error types

```
array(2) = Debug Messages, without Error Messages
```

For a live site you'll usually only enable Errors (1) to be logged otherwise  your log files will fill up very fast.

!!! tip
    The logs are located in the application/logs folder.

To be able to figure out an error or a bug, change the logging level to 4. AFter that, reproduce the error and look in the log file to see if you can find anything that is related to the problem you are experiencing. Posting the log when you create an issue, is always helpful.