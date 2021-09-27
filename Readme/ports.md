logging | ContainerPort | ClusterPort | NodePort
:---:|:---:|:---:|:---:
log-elasticsearch | 9200 | 9200 | none
log-fluent-bit    | 2020 | 2020 | none
log-kibana        | 5601 | 5601 | 30941

identity | ContainerPort| ClusterPort| NodePort
:---:|:---:|:---:|:---:
postgress         | 5432 | 5432 | 30001
home-page-pwc-css | 8801 | 8801 | 31001
homepage-ui       | 8082 | 8082 | 31001
identity-ui       | 9100 | 9100 | 31002
poseidon-homepage | 8085 | 8085 | 31003
token-mt          | 5100 | 5100 | none
identity-api      | 5200 | 5200 | 31004
identity-mt       | 5201 | 5201 | none
mock-api          | 5202 | 5202 | 31021


expert | ContainerPort  | ClusterPort | NodePort
:---:|:---:|:---:|:---: 
postgres        | 5432  | 5432  | 30003
rabbitmq        | 15672 | 15672 | 30011
redis           | 6379  | 6379  | 30012
privatization   | 7047  | 7047  | 31010
metis-ui        | 8200  | 8200  | 31008
metis-api       | 7046  | 7046  | 31009
metis-mt        | 7045  | 7045  | none
expert-api      | 7001  | 7001  | 32301
expert-ui       | 8082  | 8082  | 32302
oval-api        | 7001  | 7001  | 32311
poseidon-ui     | 8300  | 8300  | 30030
poseidon-api    | 7066  | 7066  | 30066
poseidon-mt     | 7068  | 7068  | 30068
pixie-api       | 7096  | 7096  | 31096
pixie-ui        | 7097  | 7097  | 31097
koala-api       | 7089  | 7089  | 31089
koala-ui        | 7090  | 7090  | 31090
mobile-expert   | 8081  | 8081  | 32303
libreoffice-api | 7088  | 7088  | none
labeling-ui     | 8082  | 8082  | 32305
information-extraction-mt | 5001 | 5001 | 32306
approval-ui         | 8100 | 8100 | 31005
approval-client-ui  | 8101 | 8101 | 31007
approval-api        | 7044 | 7044 | 31006
second-entry-api    | 7048 | 7048 | 31013
second-entry-ui     | 8102 | 8102 | 31014
search-api          | 7094 | 7094 | 31094
search-ui           | 7095 | 7095 | 31095


approval | ContainerPort| ClusterPort| LegacyNodePort | NodePort | Comments
:---:|:---:|:---:|:---:|:---:|:---:
postgres              | 5432 | 5432 | none | 30004 |
mt-shcn               | 7050 | 7050 | none | none |  |
api-rpa               | 7051 | 7051 | 31015 | 31151 | 园区:31151,昆山:31015 |
api-approval-v2       | 7052 | 7052 | 31016 | 31152 |
api-hightech          | 7053 | 7053 | none | 31153 |
mt-szxc               | 7054 | 7054 | none | none |
api-second-entry-v2   | 7055 | 7055 | none | 31155 |
api-drawing           | 7056 | 7056 | none | 31156 |
ui-approval-client    | 8101 | 8101 | 31007 | 31101 |
ui-approval-client-suzhou | 8104 | 8104 | 31022 | 31104 |
ui-rpa                | 8105 | 8105 | none | 31105 |
ui-approval-v2        | 8106 | 8106 | none  | 31106 |
ui-hightech           | 8107 | 8107 | none | 31107 |
ui-second-entry-v2    | 8108 | 8108 | none | 31108 |
ui-approval-sip       | 8101 | 8101 | none | 31109 | 园区智能审批专区 |
ui-drawing            | 8110 | 8110 | none | 31110 |  |
selenium              | 4444 | 4444 | none | 30100 | 之后会变成公共服务 |
schedule-server       | 7777 | 7777 | none | 30177 | 之后会变成公共服务 |


smart approval | ContainerPort | ClusterPort | NodePort | Comments
:---:|:---:|:---:|:---:|:---:
postgres                  | 5432 | 5432 | 30004 |
ui-info-deliver           | 6100 | 6100 | 31200 |
ui-smart-approval         | 6101 | 6101 | 31201 | 事项制作UI
ui-smart-approval-admin   | 6102 | 6102 | 31102 | 审批端UI
ui-smart-approval-client  | 6103 | 6103 | 31203 | 申请端UI
ui-smart-approval-result  | 6104 | 6104 | 31204 | 审批结果UI
api-info-deliver          | 6199 | 6199 | 31299 |
api-smart-approval        | 6198 | 6198 | 31298 |


search | ContainerPort| ClusterPort| NodePort | Comments
:---:|:---:|:---:|:---:|:---:
postgres                  | 5432 | 5432 | 30006 |
redis                     | 6379 | 6379 | none |
elasticsearch             | 9200 | 9200 | none |
sip-search-api            | 7878 | 7878 | 31048 |
sip-search-job            | none | none | none |
sip-search-data-receiver-api | 8900 | 8900 | 31089 |
sip-search-data-receiver-job | none | none | none |


dialog | ContainerPort| ClusterPort| NodePort
:---:|:---:|:---:|:---: 
postgress           | 5432  | 5432  | 30002
rabbitmq            | 15672 | 15672 | 30011
redis               | 6379  | 6379  | none
api-css             | 7012  | 7012  | 31010
api-css-admin       | 7007  | 7007  | 31011
gateway-agent       | 9500  | 9500  | 31012
gateway-client      | 9400  | 9400  | 31013
ui-css-admin        | 8080  | 9101  | 31014
ui-css-client       | 8080  | 9300  | 31015
mt-agent-manage     | 9401  | 9401  | none
mt-bot-dialog       | 7002  | 7002  | none
mt-bot-manage       | 7003  | 7003  | 31020
mt-client-manage    | 7008  | 7008  | none
mt-dialog-engine    | 7005  | 7005  | none
mt-dialog-message   | 7004  | 7004  | none
mt-dialog-report    | 7010  | 7010  | none
pl-dialog-report    | 7009  | 7009  | none
pl-nlp-service      | 7011  | 7011  | none


label | ContainerPort| ClusterPort| NodePort 
:---:|:---:|:---:|:---: 
labelstudio       | 8080 | 8080 | 32580
labelsupporter    | 8099 | 8099 | 32599
