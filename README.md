# s3-mysql-backsup

Backup a mysql database server to Google Cloud Storate. This code is inspired by [Anil Saravade
](https://medium.com/searce/cronjob-to-backup-mysql-on-gke-23bb706d9bbf) but GPG symmetric encrypts the mysql dump file. 

This backup script container is on hub.docker.com at simonmassey/gcpmysqlbackup

## Usage

To run the script the following environment variables are required: 

 * DB_USER: database user
 * DB_PASS: database password
 * DB_HOST: database host
 * DB_NAME: database
 * GGP_PASS: symmetric password to encrypt backups
 * GCS_BUCKET: the bucket to upload into
 * GCS_SA: the location of the service account token e.g. '/gcp-credential/sa-key.json'


## Setting up on Kubernetes

```sh
oc login ...
oc project xyz
./create-openshift.sh
```

## Restoring the database

If you need to restore the files you first need to decrypt them with something like: 

```sh
gpg --batch --no-tty --yes --decrypt --passphrase $secret_key "$tmpfile"
```

Then load them with something like: 

```sh
find . -name '*.sql' | awk '{ print "source",$0 }' | mysql -u root -p$mysqlpass -h you.host.com -P 3306 --batch
```
