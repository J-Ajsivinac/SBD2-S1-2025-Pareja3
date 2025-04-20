mkdir /backups
chown -R oracle.oinstall /backups


export NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'
rman target / <<EOF
run{
    backup format '/backups/dbf_%d_%s_%p_%T_%U.bkp' database;
    backup format '/backups/arch_%d_%s_%p_%T_%U.bkp' archivelog from time 'sysdate-1;
    backup format '/backups/arch_%d_%s_%p_%T_%U.bkp' current controlfile for standby;
    backup format '/backups/arch_%d_%s_%p_%T_%U.bkp' archivelog from time 'sysdate-1'; 
}