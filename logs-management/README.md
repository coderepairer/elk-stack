# logs-management
(ELK) based Logs management solution is an easy to implement approach of dealing with large volume of computer-generated log messages (e.g. audit logs, trace logs, scheduler logs, applications logs etc.) It comprises of following features:  
* Large volume logs generation using shell script 
* Centralized logs collection & aggregation 
* Real-time logs parsing & transformation 
* Logs indexing, storing & retention 
* Logs search, analysis & visualization/reporting
 (ELK) Logs management solution uses ELK stack technology. ELK stands for **Elasticsearch**, **Logstash** and **Kibana**. ELK stack is a combination of three open-source products and Filebeat on top of it makes ELK Stack– 
 **Elasticsearch** is a Lucene based search engine. 
 
 **Logstash** is a log pipeline tool that accepts inputs from various sources, executes different transformations, and exports the data to various targets (here it is Elasticsearch). 
 
 **Kibana** is a visualization layer that works on top of Elasticsearch. 
 
 **Filebeat** is also an open source product of ELK stack, it is used as a logs shipper to aggregate & ship the logs to elastic search / logstash or any other target source. 
 
Together, these open source products are most commonly used in log analysis in IT environments (e.g. business intelligence, security and compliance, and web analytics). 

File-beat is installed as a shipper on each machine to collect all logs from each m/c and ship them to logstash for processing. Logstash collects logs from file-beat shippers, parses logs, apply filters & transformations, masks confidential data and create respective indexes in elasticsearch. Elasticsearch stores the information as indexes for later search queries. Kibana then presents the elasticsearch data in visualizations/dashboards that provide actionable insights into one’s environment and allow automatic reports generation.

![Technology Used](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/tech.png?raw=true)

## Pre-requisites

### Softwares
*	Java JDK 7+
*	Linux Operating system
*	File-beat 5.5.0
*	AWS Elasticsearch Service with Kibana
*	Logstash 2.4.0

### AWS Specifications
![AWS Specifications](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/aws.png?raw=true)

## Technical Design
![Technical Design](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/design.png?raw=true)

 In above design, four EC2 Instances (Node-1, Node-2, Node-3, Logs-Collector) are created in AWS. Each of these instances generate log events of following types:
* Application Logs
* Audit Logs
* Trace Logs
* Scheduled Logs 
On Node-1, Node-2 & Node-3 instances a logs-shipper (File beat client) is installed on each which ships the logs to logs-collector instance. Logs-collector instance has logstash installed on it. It listens on Port 5044 (Node-1 Log-shipper), Port 5045 (Node-1 Log-shipper) and Port 5046 (Node-1 Log-shipper) for any logs. All logs from these ports are taken as input. 
*logstash-input-plugin* collects all the logs and forwards them to Logstash-Filter-Plugin for filtering & parsing the logs from different sources into generic elastic search format. It also masks the logs if they have any MSISDN pattern starting with 38067 followed by 7 digits (e.g. 380670000052). After filtering & transformation process, *logstash-output-plugin* create elastic search indexes for each type of logs and output is sent to Amazon Elasticsearch service host. Amazon Elasticsearch service pushes the data to Kibana configured internally with elasticsearch service. Kibana is a GUI based application used for searching data existing in elasticsearch, analyse it, generate dashboards and reports. It can be accessed by analysts over the internet using the domain URL registered with AWS.

### Components 
**1. Logs shipper:**  It is a File beat client installed on each logs source machine from where logs need to be shipped. filebeat.yml configuration file of log shipper is used for defining Shipper properties and target source
 
**2. Logs collector:** It is an AWS EC2 instance with logstash installed. It is first step of Logstash pipeline. Logstash input plugins in  logstash.conf config file listens on different ports of logs shipper and takes logs as input.
![Logstash](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/logstash.png?raw=true)

**3. Logs parser:** It is second step of logstash pipeline. It parses & transforms Input logs as per the filters written in logstash config file logstash.conf .
![Logstash](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/logstash1.png?raw=true)
![Logstash](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/logstash2.png?raw=true)
![Logstash](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/logstash3.png?raw=true)

   MSISDN masking: It is a part of Logs parser component and masks every MSISDN in input message matching with pattern 38067[0-9]{7} where first 5 digits are 38067 followed by 7 any random digits within range of 9 to 9.
 ![Data masking](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/msisdn.png?raw=true)

**4. Data Visualization:** Once all the parsed logs are sent to elasticsearch. They can be visualised in Kibana GUI. Kibana is integrated with AWS elasticsearch service. Kibana GUI can be used for data search, queries & visualize data in dashboards.
  ![Kibana](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/kibana.png?raw=true)
  
  
## Setup Instructions 
**1. 

**1.** To start with 4 nodes node-1,node-2, node-3 & logs-collector need to be setup in AWS
##### Node 1 
PUBLIC DNS: ec2-13-127-40-166.ap-south-1.compute.amazonaws.com
PUBLIC IP: 13.127.40.166
PRIVATE IP: 172.31.8.173

##### Node 2 
PUBLIC DNS: ec2-52-66-139-10.ap-south-1.compute.amazonaws.com
PUBLIC IP: 52.66.139.10
PRIVATE IP: 172.31.6.181

##### Node 3
PUBLIC DNS: ec2-52-66-71-93.ap-south-1.compute.amazonaws.com
PUBLIC IP: 52.66.71.93
PRIVATE IP: 172.31.2.64

##### Logs Collector
PUBLIC DNS: ec2-13-126-181-174.ap-south-1.compute.amazonaws.com
PUBLIC IP: 13.126.181.174
PRIVATE IP: 172.31.2.50

Change of /etc/hosts/  on all nodes to use node names instead of IPs

**2.** Creation of directory structure on all nodes and grant them write permissions. 
`sudo mkdir -p /var/log/hackathon++/applogs /var/log/hackathon++/auditlogs /var/log/hackathon++/tracelogs /var/log/hackathon++/schedlogs
sudo chmod 777 -R /var/log/hackathon++/
tree /var/log/hackathon++/`
/var/log/hackathon++/
├── applogs
├── auditlogs
├── schedlogs
└── tracelogs

**3.** Copy generate-logs.sh script to automatically generate sample log files in bulk.
##### Scheduled Logs
2017-07-27T11:36:02.535+0300 [PmAggregator] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={"status":"FINISHED","hostName":"csua1-msv1","activityId":"PMAGG-DEL-SHORT","activityName":"PmAggregator","startTime":"2017-07-27 11:35:02.398","endTime":"2017-07-27 11:36:02.528","activityType":"shell","runScope":"global","startedBy":"system","exitValue":0}/=SLM
2017-10-11T11:16:13.039+0300 [PmAggregator] INFO  c.e.bss.ms.scheduler.util.MsvLogger ActivityHistory: SLM={"status":"FINISHED" "hostName":"csua1-msv1" "activityId":"PMAGG-DEL-SHORT" "activityName":"PmAggregator" "startTime":"2017-10-11 11:15:12.899" "endTime":"2017-10-11 11:16:13.033" "activityType":"shell" "runScope":"global" "startedBy":"system" "exitValue":0}/=SLM"

##### Audit Logs
type=USER_ACCT msg=audit(1470863005.114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct="msvsftpus" exe="/us/sbin/vsftpd" hostname=csua1-msv1.m.eclab.local addr=10.40.1.132 teminal=ftp res=success'
type=USER_ACCT msg=audit(1470863005.114:1393400): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:accounting acct="msvsftpus" exe="/us/sbin/vsftpd" hostname=csua1-msv1.m.eclab.local addr=10.40.1.132 teminal=ftp res=success'
type=CRED_ACQ msg=audit(1470863005.114:1393401): use pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_:ftpd_t:s0-s0:c0.c1023 msg='op=PAM:setced acct="msvsftpus" exe="/us/sbin/vsftpd" hostname=csua1-msv1.m.eclab.local addr=10.40.1.132 teminal=ftp res=success'

##### Trace Logs
Wed Jul 05 2017,15:52:57:888	cha	chaaccess1	/var/opt/log/cha/trace/cha_CHA0000000013_access-chaaccess1.dbss.local-00000015_380670000052_20170705T155257.log		
Message: 2017-07-05T15:52:57.888+03:00 - SLM={"TraceId": "CHA0000000013", "SubComponent": "access", "Hostname": "chaaccess1.dbss.local", "SequenceNo": "00000015", "MSISDN": "380670000052"}/=SLM
15:52:57.888 Tracing the execution of runtime flow CHA-OFL-BX

##### Application Logs
2017-10-11T11:10:41.662+0300 | ERROR | pool-51-thread-1 | c.e.b.r.c.a.p.o.s.i.i.SftpImpl | sftpstack.impl.internal.SftpImpl 383 | 239 - com.ericsson.bss.rm.charging.access.plugins.offlinestack.sftpstack.impl - 1.16.0 | raising alarm SFTP_CONNECTION_FAILED[ Unable to connect the configured MM]
2017-10-11T11:10:41.662+0300 | WARN | pool-51-thread-1 | b.r.c.a.p.o.i.i.OfflineStackImpl | nal.OfflineStackImpl$FileChooser 1300 | 229 - com.ericsson.bss.rm.charging.access.plugins.offlinestack.impl - 1.16.0 | Error connecting to server or checking directory in FileChooser

**4.** Filebeat setup
##### Node 1 :
- Install of filebeat 
- Edit filebeat.yml for paths location & logstash config (logs-collector:5044) 
- Start filebeat.yml daemon 
`sudo chown root /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml
sudo /opt/filebeat-5.5.0-linux-x86_64/filebeat -e -c /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml &>> ~/shipper.log &`

##### Node 2 :
- Install of filebeat 
- Edit filebeat.yml for paths location & logstash config (logs-collector:5045) 
- Start filebeat.yml daemon 
`sudo chown root /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml
sudo /opt/filebeat-5.5.0-linux-x86_64/filebeat -e -c /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml &>> ~/shipper.log &`

##### Node 3 :
- Install of filebeat 
- Edit filebeat.yml for paths location & logstash config (logs-collector:5046) 
- Start filebeat.yml daemon 
`sudo chown root /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml
sudo /opt/filebeat-5.5.0-linux-x86_64/filebeat -e -c /opt/filebeat-5.5.0-linux-x86_64/filebeat.yml &>> ~/shipper.log &`

**5.** Logstash setup
- Install Logstash on logs-collector 
- Copy logstash.conf
- Start logstash daemon [DONE]
`sudo /opt/logstash-2.4.0/bin/logstash -f /opt/logstash-2.4.0/logstash-hackathon++.conf &>> ~/logstash.log & `

**6.** Create a domain using AWS Elastic search Service. It will create Elastic search server Kibana server with url of each.

**7.** Edit logstash.conf file and add AWS hosted Elastic search cloud url.

**8.** Execute generate-logs.sh to start random sample logs to add data.

**9.** Open AWS hosted Kibana url to visualise & analyse logs data

###### Note: You may edit edit generate-logs.sh & logstash.conf to customise the solution for your project, .



