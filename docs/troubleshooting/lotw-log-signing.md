# Issues Signing (and Uploading) LoTW Logs

## Signing fails on RHEL 9/10-based systems

On recent OS versions like Alma Linux 10 (and probably Red Hat 9/10) LoTW uploads fail and the UI shows an error saying that singing the log failed. The error log contains a line like:

```bash
Error signing LoTW log: error:03000098:digital envelope routines::invalid digest
```

Reason for this is that LoTW still uses SHA-1 algorithms for signing the logs. This is deprecated and therefore not available per default on recent Linux versions.

### Workaround

The fix for this is to allow SHA-1 signatures. If `php-fpm` is in use this can be done as follows:

Copy `/etc/pki/tls/openssl.cnf` to `/etc/pki/tls/openssl-php-fpm.cnf`. Then edit the file and add the following line under `[ evp_properties ]`:

```bash
rh-allow-sha1-signatures = yes
```

Then edit/create `/etc/systemd/system/php-fpm.service.d/openssl-sha1.conf` to contain:

```bash
[Service]
Environment=OPENSSL_CONF=/etc/pki/tls/openssl-php-fpm.cnf
```

Lastly restart the `php-fpm` services:

```bash
systemctl daemon-reload && systemctl restart php-fpm
```

This fix should allow LoTW logs to be signed and uploaded again.

!!! note
    RHEL 10 no longer ships the `DEFAULT:SHA1` subpolicy, so this scoped approach avoids switching the whole server to `LEGACY`.

This was tested/reported on Alma Linux 10.2, nginx and php-fpm. Wavelog was installed on bare metal (i.e. no Docker container).
