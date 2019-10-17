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
 * GCS_BUCKET: 'uniqkey-mysql-backups'
 * GCS_SA: '/gcp-credential/sa-key.json'

The aws cli for S3 uploads also needs a `~/.aws/credentials` which can be created using `aws configure`. You then simply run: 

```sh
s3mysqlbackup.sh
```

This tools is availabe on hub.docker.com at simonmassey/gcp-mysql-backup

## Setting up on OpenShift Kubernetes

The `openshift.yaml` sets the job to run daily at 2:30am. You need to run `aws configure` and save the generated `$HOME/.aws/*` into the root of this repo. (Ours our hidden by `git secret` so if you know the secret just `git secret reveal`.) You also need a `.env` file with the environment variabiles listed above. Then simply: 

```sh
oc login ...
oc project xyz
./create-openshift.sh
```

## Restoring the database

If you need to restore the files you first need to decrypt them with something like: 

```
gpg --batch --no-tty --yes --decrypt --passphrase $secret_key "$tmpfile"
```

Then load them with something like: 

```
find . -name '*.sql' | awk '{ print "source",$0 }' | mysql -u root -p$mysqlpass -h you.host.com -P 3306 --batch
```


