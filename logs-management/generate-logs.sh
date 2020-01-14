#!/bin/bash
# Script to automate generation of variety of logs
# It includes application logs, audit logs,
# scheduled logs & trace logs

hostname=`hostname`
echo " Script started  on Host : ($hostname)"


######################################################## APPLICATION LOGS ##################
echo "-------------Started Application logs-----------------"
applogDate=`date --iso-8601=seconds`

for i in {1..50}
do
line1="$applogDate | WARN  | pool-51-thread-1 | b.r.c.a.p.o.i.i.OfflineStackImpl | nal.OfflineStackImpl\$FileChooser\ 1300 | 229 - com.ericsson.bss.rm.charging.access.plugins.offlinestack.impl - 1.16.0 | Error connecting to server or checking directory in FileChooser"
echo $line1 >> /var/log/hackathon++/applogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

for i in {1..10}
do
line2="$applogDate | ERROR | pool-51-thread-1 | b.r.c.a.p.o.i.i.OfflineStackImpl | k.impl.internal.OfflineStackImpl 1789 | 229 - com.ericsson.bss.rm.charging.access.plugins.offlinestack.impl - 1.16.0 | error connecting to [ HOST: 127.0.0.1 PORT: 22 USERNAME: root PASSWORD: ******** MAXRETRIES: 3 RETRYINTERVAL: 3 seconds] Could not perform SFTP CONNECT. Could not Login to the Host   :Auth fail com.ericsson.bss.rm.charging.access.plugins.offlinestack.sftpstack.service.exceptions.FtpException: Could not perform SFTP CONNECT. Could not Login to the Host   :Auth fail"
echo $line2 >> /var/log/hackathon++/applogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

sed "" </home/ec2-user/sample-logs/application.txt >>/var/log/hackathon++/applogs/application_$(date +"%d-%m-%Y_%I_%p").log
echo "xxxxxxxxxxxx Finished Application logs xxxxxxxxxxxxxxxx"


######################################################## AUDIT LOGS ##################
echo "-------------Started Audit logs-----------------"
auditlogDate=`date +%s`
ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

for i in {1..80}
do
event1="type=PATH msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='"root"' exe="/usr/sbin/vsftpd" hostname="$hostname" addr="$ip" teminal=ftp res=success'"

event2="type=CRED_ACQ msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='"root"' exe="/usr/sbin/vsftpd" hostname="$hostname" addr="$ip" teminal=ftp res=success'"

event3="type=PATH msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='"root"' exe="/usr/sbin/vsftpd" hostname="$hostname" addr="$ip" teminal=ftp res=failed'"

echo $event1 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event2 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event3 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log

done

for i in {1..70}
do
event4="type=CRED_ACQ msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='"root"' exe="/usr/sbin/vsftpd" hostname="$hostname" addr="$ip" teminal=ftp res=failed'"

event5="type=SYSCALL msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=success'"

echo $event4 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event5 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

for i in {1..20}
do
event6="type=SYSCALL msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=failed'"

event7="type=USER_ACCT msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=success'"

event8="type=CWD msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=failed'"

echo $event6 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event7 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event8 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

for i in {1..100}
do
event9="type=USER_ACCT msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=failed'"

event10="type=CRED_ACQ msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=success'"

event11="type=CWD msg=audit("$auditlogDate".114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct='root' exe=/usr/sbin/vsftpd hostname="$hostname" addr="$ip" teminal=ftp res=success'"

echo $event9 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event10 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event11 >> /var/log/hackathon++/auditlogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

echo "xxxxxxxxxxxx Finished Audit logs xxxxxxxxxxxxxxxx"



######################################################## SCHEDULED LOGS ################################
echo "-------------Started Scheduled logs-----------------"

schedLogdate=`date +"%Y-%m-%dT%T.888%z"`

for i in {1..30}
do

event1=""$schedLogdate" [PmAggregator] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"FINISHED\",\"hostName\":\"$hostname\",\"activityId\":\"PMAGG-DEL-SHORT\",\"activityName\":\"PmAggregator\",\"startTime\":\"2017-10-11 11:15:12.899\",\"endTime\":\"2017-10-11 11:16:13.033\",\"activityType\":\"shell\",\"runScope\":\"global\",\"startedBy\":\"system\",\"exitValue\":0}/=SLM"

event2=""$schedLogdate" [localActivity] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"NOT_STARTED\" ,\"hostName\":\"$hostname\" ,\"activityId\":\"PMAGG-DEL-SHORT\" ,\"startTime\":\"2017-10-11 11:15:57.220\" ,\"runScope\":\"global\" ,\"errMsg\":\"Service: msvPMParser is not available on this node\"}/=SLM"

event3=""$schedLogdate" [msvPMCollect] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"FINISHED\" ,\"hostName\":\"$hostname\" ,\"activityId\":\"PM-csua1-ntf1\" ,\"activityName\":\"msvPMCollect\" ,\"startTime\":\"2017-10-11 11:15:22.736\" ,\"endTime\":\"2017-10-11 11:15:22.818\" ,\"activityType\":\"shell\" ,\"runScope\":\"local\" ,\"startedBy\":\"system\" ,\"exitValue\":0}/=SLM"

event4=""$schedLogdate" [msvPMCollect] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"FINISHED\" ,\"hostName\":\"$hostname\" ,\"activityId\":\"PM-csua1-ntf1\" ,\"activityName\":\"msvPMCollect\" ,\"startTime\":\"2017-10-11 11:15:22.736\" ,\"endTime\":\"2017-10-11 11:15:22.818\" ,\"activityType\":\"shell\" ,\"runScope\":\"local\" ,\"startedBy\":\"system\" ,\"exitValue\":0}/=SLM"

event5=""$schedLogdate" [EditMapRDBTableForPermission] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"FINISHED\" ,\"hostName\":\"$hostname\" ,\"activityId\":\"EPS-005\" ,\"activityName\":\"EditMapRDBTableForPermission\" ,\"startTime\":\"2017-10-11 11:10:40.198\" ,\"endTime\":\"2017-10-11 11:10:59.200\" ,\"activityType\":\"shell\" ,\"runScope\":\"local\" ,\"startedBy\":\"system\" ,\"exitValue\":0}/=SLM"

event6=""$schedLogdate" [EditMapRDBTableForPermission] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={\"status\":\"STARTED\" ,\"hostName\":\"$hostname\" ,\"activityId\":\"EPS-005\" ,\"activityName\":\"EditMapRDBTableForPermission\" ,\"startTime\":\"2017-10-11 11:10:40.198\" ,\"activityType\":\"shell\" ,\"runScope\":\"local\" ,\"startedBy\":\"system\"}/=SLM"

echo $event1 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event2 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event3 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event4 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event5 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
echo $event6 >> /var/log/hackathon++/schedlogs/file_$(date +"%d-%m-%Y_%I_%p").log
done

sed "" </home/ec2-user/sample-logs/scheduler.txt >>/var/log/hackathon++/schedlogs/scheduler_$(date +"%d-%m-%Y_%I_%p").log
echo "xxxxxxxxxxxx Finished Scheduled logs xxxxxxxxxxxxxxxx"


######################################################## SCHEDULED LOGS ################################
echo "-------------Started Trace logs-----------------"
traceLogdate=`date +"%Y-%m-%dT%T.888%:z"`

for i in {1..10}
do
cha_line1="Wed Jul 05 2017,15:52:57:888	cha	chaaccess1	/var/opt/log/cha/trace/cha_CHA0000000013_access-node-1-00000015_380670000052_20170705T155257.log		"
cha_line2="Message: "$traceLogdate" - SLM={\"TraceId\": \"CHA0000000013\", \"SubComponent\": \"access\", \"Hostname\": \"$hostname\", \"SequenceNo\": \"00000015\", \"MSISDN\": \"380670000052\"}/=SLM"

echo $cha_line1 >> /var/log/hackathon++/tracelogs/CHA-OFL_$(date +"%d-%m-%Y_%I_%p").log
echo $cha_line2 >> /var/log/hackathon++/tracelogs/CHA-OFL_$(date +"%d-%m-%Y_%I_%p").log
sed "" </home/ec2-user/sample-logs/CHA-OFL.txt >>/var/log/hackathon++/tracelogs/CHA-OFL_$(date +"%d-%m-%Y_%I_%p").log


refill_line1="Wed Jul 05 2017,15:42:26:751	cha	chacore1	/var/opt/log/cha/trace/cha_CHA0000000008_core-chacore1.dbss.local-00000008_380674700549_20170705T154226.log	"
refill_line2="Message: "$traceLogdate" - SLM={\"TraceId\": \"CHA0000000008\", \"SubComponent\": \"core\", \"Hostname\": \"chacore1.dbss.local\", \"SequenceNo\": \"00000008\", \"MSISDN\": \"380674700549\"}/=SLM"

echo $event1 >> /var/log/hackathon++/tracelogs/Refill_$(date +"%d-%m-%Y_%I_%p").log
echo $event2 >> /var/log/hackathon++/tracelogs/Refill_$(date +"%d-%m-%Y_%I_%p").log

sed "" </home/ec2-user/sample-logs/Refill.txt >>/var/log/hackathon++/tracelogs/Refill_$(date +"%d-%m-%Y_%I_%p").log
done
echo "xxxxxxxxxxxx Finished Trace logs xxxxxxxxxxxxxxxx"
echo "Completed successfully !!"
