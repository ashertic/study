1. 20201012
    需求: 因为ui卡顿, 清理db数据
    操作: 清理db, ref: declaration_clean_db/README.md
    PM:  Shucheng

2. 20201215
    需求: 脱敏字段从之前的8个('条形码', '海关编号', '预录入编号', '境内收货人', '申报单位', '单价', '总价', '商品编号'),变为4个('条形码', '海关编号','单价', '总价')
    操作: 
        1. 更新swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_api:latest到客户那里
        2. 清理db, , ref: declaration_clean_db/README.md
    PM:  Shucheng