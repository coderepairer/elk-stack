# ldap-security
 Please follow below steps to start with ldap security using ELK stack
 
 Pre-requisites :
 1. An OpenLDAP account or An AWS account for setting up OpenLDAP
 2. Elasticsearch 7.4.2
 3. Kibana 7.4.2
 
# Steps: 
 
**1.** Here we have not focussed on setting up OpenLDAP. If you do not have your own OpenLDAP setup, You may use AWS account and do LDAP Setup using [AWS OpenLDAP Marketplace](https://aws.amazon.com/marketplace/pp/B01KVGYEY0?ref_=aws-mp-console-subscription-detail). It will setup an OpenLDAP server within minutes and it wil cost ~1.0 INR for 1 hour for free-tier accounts.
 
 I did a LDAP server on AWS (Url : https://ec2-34-238-39-255.compute-1.amazonaws.com/cmd.php?server_id=1&redirect=true )
 
![OpenLDAP](https://github.com/coderepairer/elk-stack/blob/master/ldap-security/images/open-ldap.png?raw=true)
 
**Created 2 groups** :
     **developers** (users : kapil, anil)
     **users** (users : alice, george,lisa)
     

**2.** Add following entry in ELK **config/role_mapping.yml**
![Role Mapping](https://github.com/coderepairer/elk-stack/blob/master/ldap-security/images/role-mapping.png?raw=true)
 
 This maps LDAP DN groups with ELK roles created in Step2. Instead of file, these roles can also be created using ELK Security API. In that case, mapping will be added in **.security** index. 



**3.** Enabled ELK stack security feature "x-pack" add following configurarion in **config/elasticsearch.yml** and restart Elasticsearch
  
![Elasticsearch config](https://github.com/coderepairer/elk-stack/blob/master/ldap-security/images/elasticsearch.jpg?raw=true)


**4.**	Disabled all ELK reserved users(except superuser : **elastic** ) using [Disable Users API](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-disable-user.html). Now all users to access the ELK portals exist only in LDAP


**5.** Login to Kibana -> Management -> Security -> Roles portal using superuser: **elastic** and create 2 roles(developers, users) and add relevant privileges from Kibana UI. 
For e.g. **developers** have read/write permissions and access "Dev Tools" and **users** have read-only permissions and no Dev console.
###### Note: There are no "users" created in Kibana. Only 2 new roles to map ELK privileges.


**6.** Check the Kibana view for users of both roles
  
  **a)** user : anil (role=developers)
  ![Anil Kibana View](https://github.com/coderepairer/elk-stack/blob/master/ldap-security/images/kibana1.jpg?raw=true)
  
  **b)** user : lisa (role=users)
  ![Lisa Kibana View](https://github.com/coderepairer/elk-stack/blob/master/ldap-security/images/kibana2.jpg?raw=true)


Refer [ELK User Authorization](https://www.elastic.co/guide/en/elasticsearch/reference/current/authorization.html) for documentation.
