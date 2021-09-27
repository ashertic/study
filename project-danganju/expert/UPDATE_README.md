
##metis从v1升级到v2的过程

### 172dev环境

1. 重新构建工作流, 工作流都保留在dags上面

    | 原工作区名称 | 新工作流名称（172） | 对应标准母工作流（172） |备注 |
    | ------------- |:-------------:| -----:| -----:|
    | 通用文档识别 | 档案局通用文档识别 | http://192.168.1.172:31028/workflow/Eyv1wnXvf | OCR-SDK【词组输出】, 去掉libreoffice部分 |
    | 表格读取模型 | 档案局表格读取 | http://192.168.1.172:31028/workflow/dzi6zBJIL | OCR-SDK【表格检测】, 去掉libreoffice部分|
    | 表单抽取 | 档案局表单抽取 | http://192.168.1.172:31028/workflow/z84f9xLd- | 模板制作预设工作区, ocr为1.7.0, 去掉libreoffice部分 |
    | 能手OCR模板制作 | 档案局模板制作平台OCR | http://192.168.1.172:31028/workflow/motGKsHIy | ocr同表单抽取工作流一致为1.7.0 |

2. 导出相应的module
    1. 利用private_deploy里面的脚本 download_modules_by_dag 获取所有的modules
        ```
            packing_name = 'danganju'
            dag_ids = ['bsLzkABb3', 'TWv8t6Axp', 'UimCY8U-r', 'motGKsHIy']
            encrypt_mark = 'release'
            download_modules_by_dag(packing_name, dag_ids, encrypt_mark)
        ```
    2. 手动导出这些modules, 放在migrations目录下, 去掉libreoffice部分
    
        | module_name | path |  备注 |
        | ------------- |:-------------:|  -----:|
        | module_image_rotation 1.0.0 | http://192.168.1.172:31028/module/detail/IQ3G0qQOGwj| |
        | module_check_pdf_type-1.1.0 | http://192.168.1.172:31028/module/detail/g8Wg45SyA| 包含 档案局通用文档识别 dag | 
        | module_check_pdf_type-1.1.0 | http://192.168.1.172:31028/module/detail/mO-03TI0s| |
        | module_pdf_xml_to_texts-1.1.0 | http://192.168.1.172:31028/module/detail/XYbFpRhJh| |
        | module_pdf_split_pages-1.0.0 | http://192.168.1.172:31028/module/detail/-hki0Cort| |
        | module_intelligence_ocr_direction-1.7.0 | http://192.168.1.172:31028/module/detail/UffPFUvZH| |
        | module_intelligence_ocr_direction-1.6.0 | http://192.168.1.172:31028/module/detail/Asux__TMw| 档案局模板制作平台OCR |
        | ~~module_excel_to_html-1.1.0~~ | http://192.168.1.172:31028/module/detail/DUNG8OVKo| |
        | module_check_excel_textbox-1.0.0 | http://192.168.1.172:31028/module/detail/QBj22lddW| |
        | module_box_to_region-1.0.0 | http://192.168.1.172:31028/module/detail/BAZSDQiVV| |
        | module_image_preprocess-1.0.0 | http://192.168.1.172:31028/module/detail/cKKuOsHYU| |
        | ~~module_libreoffice_server-1.0.0~~ | http://192.168.1.172:31028/module/detail/gBNPnHIP_| |
        | module_check_file_type-1.2.0 | http://192.168.1.172:31028/module/detail/7c_9cKJtj | |
        | module_intelligence_ocr_text-1.8.0 | http://192.168.1.172:31028/module/detail/r-LZdinhI | |
        | module_intelligence_dag_creation-1.0.0 | http://192.168.1.172:31028/module/detail/dm5p6QsWtPh | 表格读取模型 dag|
        | module_intelligence_table_structure-1.0.0 | http://192.168.1.172:31028/module/detail/42Vif0nCnWU | |
        | module_intelligence_table_analysis-1.0.0 | http://192.168.1.172:31028/module/detail/toB4IlyOJ1Y | |
        | module_intelligence_ocr_tableline-1.7.0 | http://192.168.1.172:31028/module/detail/4fbWVy7pw | |
        | module_intelligence_blocks_to_html-1.0.1 | http://192.168.1.172:31028/module/detail/Tad3EsMPv | |
        | module_json_to_array-1.0.0 | http://192.168.1.172:31028/module/detail/9pBPygi_h | |
        | module_template_rule_extractor-1.5.0 | http://192.168.1.172:31028/module/detail/jos_ivpEL | 档案局表单抽取 |
        | module_split_pdf-1.1.0 | http://192.168.1.172:31028/module/detail/4FXwGSK5I | |
        | module_check_file_type-1.0.0 | http://192.168.1.172:31028/module/detail/0tzLKktKsj | |
        | module_merge_educts-1.0.0 | http://192.168.1.172:31028/module/detail/TVek8JNZq | |
        | module_intelligence_ocr_consignation-1.7.0 | http://192.168.1.172:31028/module/detail/Wuj_7axXy | 能手OCR模板制作 |
        | module_split_pdf-1.2.0 | http://192.168.1.172:31028/module/detail/SFjwM3wnA | |
        | module_lines_detect_tables-1.0.0 | http://192.168.1.172:31028/module/detail/g5rVKXlIH |  档案局表格读取 |
        | module_intelligence_extract_searchable_pdf-1.3.0 | http://192.168.1.172:31028/module/detail/gDYbQUjMf |   |
        | module_generate_searchable_pdf-1.0.0 | http://192.168.0.69:8200/module/detail/dU9uQ8PrYav |   |
    

###本地
1. 产生新的local-docker.json
>
    expert-ui:latest
    expert-api:latest
    metis-ui:v2.2.0
    metis-mt:v2.2.0
    metis-api:v2.2.0
    metis_workder_manager:v2
    metis_worker_gpu:v1.5_no_subtask
    metis_worker:v2
    metis_worker:crypt

2. redis接口为6380
3. 本地存储images
    ```
   cd /data/projects/deployment/deploy-script
   python3 deploy.py ../project-danganju/local-docker.json
   5- [2, 3] - 1 - [17,18,19,20,21,22,23,24,25]
    ```
###0.69
ssh 192.168.0.69

1. 停止旧的服务
    ```
   cd /data1/deploy-scrip
   python3 deploy.py ../project-danganju/prod-docker.json
   7 - [2, 3] - 4 - [17,18,19,20,21,22,23,24,25]
    ```
2. 用copy的手段备份旧的images和data_root/intelligence/expert目录
    ```
   cd /data1/project-danganju/data_root/intelligenc
   cp -r expert expert.bak
   cd /data1/project-danganju/data_root/intelligence/expert/modules
   sudo rm * 
   
   cd /data1/project-danganju/images/minerva
   cp -r expert expert.bak
   cd /data1/project-danganju/images/minerva/expert
   sudo rm expert-expert_*
   sudo rm expert-metis_*
   sudo rm metis-metis_*
   
    ```
3. 复制本地内容到0.69 [在本地执行]
    ```
   
   替换172的wheels/resource
   备份172的到本地
   scp -r root@192.168.1.172:/data1/project-dev/data_root/expert/wheels /data/backup/dev
   scp -r root@192.168.1.172:/data1/project-dev/data_root/expert/resource /data/backup/dev
   
   传到0.69
   scp -r /data/backup/dev/wheels root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
   scp -r /data/backup/dev/resource root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
   
   部署脚本更新
    scp /data/projects/deployment/project-danganju/local-docker.json root@192.168.0.69:/data1/project-danganju
   
    scp /data1/project-danganju/images/minerva/expert/* root@192.168.0.69:/data1/project-danganju/images/minerva/expert
    scp -r /data/projects/deployment/project-danganju/expert/configs root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
    scp -r /data/projects/deployment/project-danganju/expert/modules_v1 root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
   ```

4. 重启meits_gpu_worker_v1
    ```
   不再用wheels 统一更换为wheel
   cd /data1/project-danganju/data_root/intelligence/expert
   mv wheels wheel 
   
    cd /data1/deploy-script
    python3 deploy.py ../project-danganju/local-docker.json
    2 - 25 - 3 - 25
    ```

5. db重新构建
    ```
    1. 手动通过pgadmin对expert、metis两个db进行drop
   
   cd /data1/deploy-script
   python3 deploy.py ../project-danganju/local-docker.json
   6 - [2,3]
   
    ```

6. 重启expert 全套
   
   **[注意]** metis_ui:v2.2.0有ui导航栏跳转bug
    ```
    cd /data1/deploy-script
    python3 deploy.py ../project-danganju/local-docker.json
    2 - [17,18,19,20,21,22,23,24,25] - 3 - [17,18,19,20,21,22,23,24,25]
    ```
   
7. 用super.admin账户登录metis
    1. 手动导入migrations里面的modules

8. 用super.admin账户登录能手，为tenant2上海档案局创建工作区，完成工作流，创建api
9. 用pgadmin修改appkey appsecrect为之前提供的版本
10. 模板制作工作流的id nUNhK35Cn
11. 更新api_tests
    ```
    scp -r /data/projects/deployment/project-danganju/expert/api_tests root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
    ```

12. 备份到本地
    ```
    scp -r root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert/* /data/projects/deployment/project-danganju/expert
    ```
13. 重新部署

    ```
     部署脚本更新
    scp /data/projects/deployment/project-danganju/local-docker.json root@192.168.0.69:/data1/project-danganju
   
    scp /data1/project-danganju/images/minerva/expert/* root@192.168.0.69:/data1/project-danganju/images/minerva/expert
    scp -r /data/projects/deployment/project-danganju/expert/* root@192.168.0.69:/data1/project-danganju/data_root/intelligence/expert
   
    cd /data1/deploy-script
    python3 deploy.py ../project-danganju/local-docker.json
    2 - [17,18,19,20,21,22,23,24,25] - 3 - [17,18,19,20,21,22,23,24,25]
    ```
    
14.  backup db

    ```
        cd /data1/deploy-script
        python3 deploy.py ../project-danganju/local-docker.json
        7 - [2,3]
     ```


  