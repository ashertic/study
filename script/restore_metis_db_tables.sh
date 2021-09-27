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

if [ $ip == "121.36.34.189" ]; then
  echo "Cannot operate on SaaS environment"
  exit 1
fi

pgPassword=Kt4C4TCHJ3
pgPort=30003

workdir=`pwd`
targetDir=customer-db-update-files-20210707
backupDir=$workdir/$targetDir

cat > $backupDir/restore-cmd.sh <<EOF
#!/usr/bin/env bash

PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" --command='DROP TABLE IF EXISTS "tagModule" RESTRICT;'
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" --command='DROP TABLE IF EXISTS "module" RESTRICT;'
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" -f /dbbackup/metis-public.tagModule-table.sql
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" -f /dbbackup/metis-public.module-table.sql

PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" --command='DROP TABLE IF EXISTS "tagWorkflow" RESTRICT;'
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" --command='DROP TABLE IF EXISTS "workflow" RESTRICT;'
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" -f /dbbackup/metis-public.tagWorkflow-table.sql
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" -f /dbbackup/metis-public.workflow-table.sql

EOF

sed -i "s/pgPassword_placeholder/$pgPassword/g" $backupDir/restore-cmd.sh
sed -i "s/ip_placeholder/$ip/g" $backupDir/restore-cmd.sh
sed -i "s/port_placeholder/$pgPort/g" $backupDir/restore-cmd.sh

docker run --rm -it \
-v $backupDir:/dbbackup \
swr.cn-north-4.myhuaweicloud.com/meinenghua/postgres:11.5-alpine \
sh /dbbackup/restore-cmd.sh

rm -f $backupDir/restore-cmd.sh
