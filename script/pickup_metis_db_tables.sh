#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

ip=$1
if [ -z $ip ]; then
  echo "please provide postgres server IP as parameter"
  exit 1
fi

pgPassword=Kt4C4TCHJ3
pgPort=30003

workdir=`pwd`
targetDir=customer-db-update-files-20210707
backupDir=$workdir/$targetDir

mkdir -p $backupDir

cat > $backupDir/backup-cmd.sh <<EOF
#!/usr/bin/env bash

PGPASSWORD=pgPassword_placeholder pg_dump --file "/dbbackup/metis-public.module-table.sql" --host "ip_placeholder" --port "port_placeholder" --username "postgres" --verbose --format=p --table "public.\"module\"" "metis"
PGPASSWORD=pgPassword_placeholder pg_dump --file "/dbbackup/metis-public.tagModule-table.sql" --host "ip_placeholder" --port "port_placeholder" --username "postgres" --verbose --format=p --table "public.\"tagModule\"" "metis"
PGPASSWORD=pgPassword_placeholder pg_dump --file "/dbbackup/metis-public.workflow-table.sql" --host "ip_placeholder" --port "port_placeholder" --username "postgres" --verbose --format=p --table "public.\"workflow\"" "metis"
PGPASSWORD=pgPassword_placeholder pg_dump --file "/dbbackup/metis-public.tagWorkflow-table.sql" --host "ip_placeholder" --port "port_placeholder" --username "postgres" --verbose --format=p --table "public.\"tagWorkflow\"" "metis"

EOF

sed -i "s/pgPassword_placeholder/$pgPassword/g" $backupDir/backup-cmd.sh
sed -i "s/ip_placeholder/$ip/g" $backupDir/backup-cmd.sh
sed -i "s/port_placeholder/$pgPort/g" $backupDir/backup-cmd.sh

docker run --rm -it \
-v $backupDir:/dbbackup \
swr.cn-north-4.myhuaweicloud.com/meinenghua/postgres:11.5-alpine \
sh /dbbackup/backup-cmd.sh

rm -f $backupDir/backup-cmd.sh
