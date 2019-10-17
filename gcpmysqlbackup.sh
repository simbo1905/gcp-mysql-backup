#!/bin/bash
set -euxo pipefail
gcloud config set project env-uniqkey-live-gcp;
gcloud auth activate-service-account --key-file "${GCS_SA}" 
mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" | gpg --batch --no-tty --yes --output "/var/backups/${DB_NAME}-$(date '+%Y%m%d-%H%M%S')".sql.gpg --symmetric --passphrase "${GGP_PASS}" ; 
gsutil cp /var/backups/*.sql.gpg gs://"${GCS_BUCKET}"