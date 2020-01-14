# logs-management
(ELK) based Logs management solution is an easy to implement approach of dealing with large volume of computer-generated log messages (e.g. audit logs, trace logs, scheduler logs, applications logs etc.) It comprises of following features:  
	Large volume logs generation using shell script 
	Centralized logs collection & aggregation 
	Real-time logs parsing & transformation 
	Logs indexing, storing & retention 
	Logs search, analysis & visualization/reporting
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
	Java JDK 7+
	Linux Operating system
	File-beat 5.5.0
	Elasticsearch 5.5.0
	Kibana 5.5.2
	Logstash 2.4.0

### AWS Specifications
![AWS Specifications](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/aws.png?raw=true)

## Technical Design
![Technical Design](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/design.png?raw=true)

 In above design, four EC2 Instances (Node-1, Node-2, Node-3, Logs-Collector) are created in AWS. Each of these instances generate log events of following types:
•	Application Logs
•	Audit Logs
•	Trace Logs
•	Scheduled Logs 
On Node-1, Node-2 & Node-3 instances a logs-shipper (File beat client) is installed on each which ships the logs to logs-collector instance. Logs-collector instance has logstash installed on it. It listens on Port 5044 (Node-1 Log-shipper), Port 5045 (Node-1 Log-shipper) and Port 5046 (Node-1 Log-shipper) for any logs. All logs from these ports are taken as input. 
Logstash – Input- Plugin collects all the logs and forwards them to Logstash-Filter-Plugin for filtering & parsing the logs from different sources into generic elastic search format. It also masks the logs if they have any MSISDN pattern starting with 38067 followed by 7 digits (e.g. 380670000052). After filtering & transformation process, logstash-output-plugin create elastic search indexes for each type of logs and output is sent to Amazon Elasticsearch service host. Amazon Elasticsearch service pushes the data to Kibana configured internally with elasticsearch service. Kibana is a GUI based application used for searching data existing in elasticsearch, analyse it, generate dashboards and reports. It can be accessed by analysts over the internet using the domain URL registered with AWS.

### Components 
**1. Logs shipper:**  It is a File beat client installed on each logs source machine from where logs need to be shipped. filebeat.yml configuration file of log shipper is used for defining Shipper properties and target source
 
**2. Logs collector:** It is an AWS EC2 instance with logstash installed. It is first step of Logstash pipeline. Logstash input plugins in  logstash.conf config file listens on different ports of logs shipper and takes logs as input.
![Logstash](https://github.com/coderepairer/elk-stack/blob/master/logs-management/images/logstash.png?raw=true)

**3. Logs parser:** It is second step of logstash pipeline. It parses & transforms Input logs as per the filters written in logstash config file logstash.conf .

 
## Setup Instructions 
**generate-logs.sh** is a script to automatically generate random log files . It generates 4 type of logs  : application logs, scheduled logs, audit logs, trace logs etc. To start with 4 nodes are needed node-1,node-2, node-3 & logs-collector. node-1 , node-2 & node-3 will be installed with filebeat

1. Install Filebeat 5.5.0 on node-1, node-2, node-3 and edit filebeat.yml on each. filebeat-nodeX.yml contains configuration details of node-X .It ships generated logs to logs-collector machine.node-1 uses port 5044, node-2 uses 5045 & node-3 uses 5046.

2. Install Logstash 2.4.0 on another node(logs-collector) and copy logstash.conf file. This file contains configuration details to parse

3. Create a domain using AWS Elastic search Service. It will create Elastic search server Kibana server with url of each.

4. Edit logstash.conf file with correct Elastic search host url.

5. Execute generate-logs.sh to start random sample logs to add data.

6. Start filebeat on node1, node-2 & node-3

7. Start logstash server on logs-collector node.

8. Open Kibana url to visualise & analyse logs data

Note: To customise the solution for your project, edit generate-logs.sh & logstash.conf accordingly.



