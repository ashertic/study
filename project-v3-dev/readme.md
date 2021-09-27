## metis-v3 部署

#### 部署步骤

前置工作，复制数据和镜像到服务器
- images
    - redis
    - postgres
    - metis_db_migration
    - metis_runtime(区分cuda版本)
- dependencies
    - wheels
    - resource

执行部署脚本
    
### 目录结构
挂载资源存放路径  

/data/project_demo/data_root/metis_runtime/  
- dependencies
    - resource
    - wheels
- data
    - static
    - resource
- module_library