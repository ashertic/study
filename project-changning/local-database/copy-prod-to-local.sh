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

workdir=`pwd`
targetDir=temp_dir_copy_prod_to_local
backupDir=$workdir/$targetDir
mkdir -p $backupDir

prod_db_ip=114.116.249.251
prod_db_passwd=GiM6G53ZsnSQ
prod_db_port=30003

cat > $backupDir/backup-cmd.sh <<EOF
#!/usr/bin/env bash

PGPASSWORD=pgPassword_placeholder pg_dump --file "/dbbackup/metis-public.module-table.sql" --host "ip_placeholder" --port "port_placeholder" --username "postgres" --verbose --format=p --table "public.\"module\"" "metis"

EOF

sed -i "s/pgPassword_placeholder/$prod_db_passwd/g" $backupDir/backup-cmd.sh
sed -i "s/ip_placeholder/$prod_db_ip/g" $backupDir/backup-cmd.sh
sed -i "s/port_placeholder/$prod_db_port/g" $backupDir/backup-cmd.sh

docker run --rm -it \
-v $backupDir:/dbbackup \
swr.cn-north-4.myhuaweicloud.com/meinenghua/postgres:11.5-alpine \
sh /dbbackup/backup-cmd.sh

echo -e "\n\n\nalready get data from prod db\n\n\n"

local_db_ip=$ip
local_db_passwd=Kt4C4TCHJ3
local_db_port=5432

cat > $backupDir/restore-cmd.sh <<EOF
#!/usr/bin/env bash

PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" --command='DROP TABLE IF EXISTS "module" RESTRICT;' 
PGPASSWORD=pgPassword_placeholder psql -h "ip_placeholder" -p "port_placeholder" -U "postgres" --dbname="metis" -f /dbbackup/metis-public.module-table.sql

EOF

sed -i "s/pgPassword_placeholder/$local_db_passwd/g" $backupDir/restore-cmd.sh
sed -i "s/ip_placeholder/$local_db_ip/g" $backupDir/restore-cmd.sh
sed -i "s/port_placeholder/$local_db_port/g" $backupDir/restore-cmd.sh

docker run --rm -it \
-v $backupDir:/dbbackup \
swr.cn-north-4.myhuaweicloud.com/meinenghua/postgres:11.5-alpine \
sh /dbbackup/restore-cmd.sh

echo -e "\n\n\nalready update prod data to local db\n\n\n"
# rm -f $backupDir/backup-cmd.sh
# rm -f $backupDir/restore-cmd.sh
