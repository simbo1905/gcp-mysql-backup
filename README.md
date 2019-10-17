# s3-mysql-backsup

Backup a mysql database server to Google Cloud Storate. This code is inspired by [Anil Saravade
](https://medium.com/searce/cronjob-to-backup-mysql-on-gke-23bb706d9bbf) but GPG symmetric encrypts the mysql dump file. 

This backup script container is on hub.docker.com at simonmassey/gcpmysqlbackup

## Setting up on Kubernetes

Install the sa credential, the connection details, and the cronjob with: 

```sh
oc login ...
oc project xyz
# save the service account credential as sa-key.json then install it as secret gcp-crential
kubectl create secret generic gcp-credential --from-file=sa-key.json
# install database secrets. see example below
kubectl apply -f db-secret.yaml 
# install the job 
kubectl apply -f crontab.yaml
```

See examples below for the secret. 

# How it works

The `Dockerfile` creates an image with the GCP tools and `gcpmysqlbackup.sh`

To run the backup script the following environment variables are required: 

 * DB_USER: database user
 * DB_PASS: database password
 * DB_HOST: database host
 * DB_NAME: database
 * GGP_PASS: symmetric password to encrypt backups
 * GCS_BUCKET: the bucket to upload into
 * GCS_SA: the location of the service account token e.g. '/gcp-credential/sa-key.json'

This can be done with a secret such as the following `db-secret.yaml`: 

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: gcp-mysql-backup
type: Opaque
stringData:
  DB_USER: 'xxx'
  DB_PASS: 'yyyy'
  DB_HOST: 'zzz.cluster-ro-blah.eu-west-1.rds.amazonaws.com'
  DB_NAME: 'ddddd'
  GGP_PASS: 'ggggg'
  GCS_BUCKET: 'your-mysql-backups'
  GCS_SA: '/gcp-credential/sa-key.json'
```

## Restoring the database

If you need to restore the files you first need to decrypt them with something like: 

```sh
gpg --batch --no-tty --yes --decrypt --passphrase $GGP_PASS "$tmpfile"
```

Then load them with something like: 

```sh
find . -name '*.sql' | awk '{ print "source",$0 }' | mysql -u root -p$mysqlpass -h you.host.com -P 3306 --batch
```
