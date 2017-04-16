# still under construction

# rsync
rsync 3.1.2 - freshly complied from official stable releases on debian:jessie

# Source Code
Check the following link for a new version: https://www.samba.org/ftp/rsync/src/

## Environment variables and defaults

### default /etc/rsyncd.conf

    log file = /dev/stdout
    use chroot = yes
    list = yes
    uid = nobody
    gid = nogroup
    transfer logging = no
    timeout = 600
    ignore errors = no
    refuse options = checksum dry-run
    dont compress = *.gz *.tgz *.zip *.z *.rpm *.deb *.iso *.bz2 *.tbz

### rsync

RSYNC_SECRET_

* __RSYNC\_SECRET\_mysecretname__
    * adds a new secret to /etc/rsyncd.secrets
    * multiple secrets possible by adding unique name to RSYNC_SECRET_
    * examples
        * "rsyncclient:passWord"
        * "alice:PassWord"

to enable authentication add the following to your volume config (inside or outside the location tag):

    auth users = alice;

* __RSYNC\_VOLUME\_CONFIG\_myconfigname__
    * adds a new rsyncd volume configuration
    * multiple variables/confgurations possible by adding unique configname to RSYNC_VOLUME_CONFIG_
    * examples
        * "[alice]; path = /shares/alice; comment = alices public files; read only = yes"
        * "[timemachine]; path = /shares/timemachine; comment = timemachine files; ignore errors = yes"

* __RSYNC\_GLOBAL\_CONFIG\_optionname__
    * adds a new rsyncd option to configuration file
    * multiple options possible by adding unique optionname to RSYNC_GLOBAL_CONFIG_
    * examples
        * "max connections = 0"
        * "read only = no"

# Usage

    rsync servername::volume # lists files in volume
    
    rsync alice@servername::volume # lists files in volume with user alice

# Links
* https://linux.die.net/man/5/rsyncd.conf
* http://www.jveweb.net/en/archives/2011/01/running-rsync-as-a-daemon.html
