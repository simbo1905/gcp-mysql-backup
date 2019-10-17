FROM google/cloud-sdk
LABEL maintainer="Simon Massey <simbo1905@60hertz.com>" \
      io.k8s.description="MySQL GCP GCS backups" \
      io.k8s.display-name="MySQL GCP GCS backups" \
      io.openshift.tags="mysql,gcp,gcs,backups"
RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt
ENV HOME="/var/backups"
RUN chmod a+rw "/var/backups"
COPY gcpmysqlbackup.sh /usr/local/bin
USER 1001
CMD /bin/bash