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
