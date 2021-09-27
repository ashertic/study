<template>
  <div class="container">
    <!-- <FieldEditor v-for="(item, index) in fields" 
      :key="index" 
      :field="item" 
      @save="onFieldChange(index, $event)" /> -->
    
    <div class="databases" style="margin-top:10px; padding-right:25px;">
      <FieldSetSection 
        v-for="(item, index) in services" 
        :title="'服务配置' + (index + 1)" 
        :key="item.uniqueId"
        @remove="onServiceItemRemove(index)" >
        <FieldEditor v-for="(serviceItem, serviceIndex) in item" 
          :key="serviceIndex" 
          :field="serviceItem" 
          @save="onServiceItemFieldChange(index, dbIndex, $event)" />
      </FieldSetSection>
    </div>

    <div class="btn">
      <a-button type="primary" block @click="createNewServiceItem">
        增加新的服务配置项
      </a-button>
    </div>
  </div>
</template>

<script>
// import FieldEditor from "@/components/FieldEditor";
import _ from "lodash"
// import FieldSetSection from "@/components/FieldSetSection.vue";

const defaultServiceItem = [
  { label: "name" ,  desc: "针对的数据库的名字", value: "" },
  { label: "server" , desc: "数据库服务器地址", value: "" },
  { label: "port" , desc: "数据库服务器端口", value: "" },
  { label: "user" , desc: "数据库连接用户名", value: "" },
  { label: "password" , desc: "数据库连接密码", value: "" },
  { label: "diskDir" , desc: "数据库备份文件或者恢复文件存放根目录的相对路径", value: "" },
  { label: "useHostNetwork" , desc: "是否部署时访问数据库使用Host网络模式", value: "false", choices: ["true", "false"]  },
]

// function convertToJson(that) {
//   let jsonObj = {
//     '__type__': 'DBBackupAndRestoreContext'
//   }

//   _.forEach(that.fields, (f) => {
//     jsonObj[f.label] = f.value
//   })

//   jsonObj["databases"] = []
//   _.forEach(that.databases, (d) => {
//     let dObj = {
//       '__type__': 'DatabaseInfo'
//     }
//     _.forEach(d, (f) => {
//       if (f.label === 'useHostNetwork') {
//         dObj[f.label] = (_.toLower(f.value) ==='true')
//       } else {
//         dObj[f.label] = f.value
//       }
//     })
//     jsonObj["databases"].push(dObj)
//   })

//   return jsonObj
// }

export default {
  components: { 
    // FieldEditor,
    // FieldSetSection 
  },
  data() {
    return {
      fields : [
        // { label: "imageCategory" , desc: "DB Docker镜像所属的Category,帮助拼接完整的Docker Image Tag", value: "thirdparty" },
        // { label: "srcImage" , desc: "DB Image的名字，不包括前缀", value: "postgres:11.5-alpine" },
      ],
      services: []
    };
  },
  methods: {
    // onFieldChange(index, value) {
    //   this.fields[index].value = value

    //   let jsonObj = convertToJson(this)
    //   this.$store.commit("setDbBackupAndRestoreContext", jsonObj);
    // },
    onServiceItemFieldChange(index, fieldIndex, value) {
      // this.databases[index][fieldIndex].value = value

      // let jsonObj = convertToJson(this)
      // this.$store.commit("setDbBackupAndRestoreContext", jsonObj);
    },
    createNewServiceItem() {
      // let newDbItem = _.cloneDeep(defaultDatabaseItem)
      // newDbItem.uniqueId = _.uniqueId()
      // this.databases.push(newDbItem)

      // let jsonObj = convertToJson(this)
      // this.$store.commit("setDbBackupAndRestoreContext", jsonObj);
    },
    onServiceItemRemove(index) {
      // this.databases.splice(index, 1)

      // let jsonObj = convertToJson(this)
      // this.$store.commit("setDbBackupAndRestoreContext", jsonObj);
    }
  },
  created() {
    let stockedConfig = this.$store.state.services
    if (stockedConfig == null) {
      // let jsonObj = convertToJson(this)
      // this.$store.commit("setDbBackupAndRestoreContext", jsonObj);
    } else {
      // _.forEach(this.fields, (f) => {
      //   f.value = stockedConfig[f.label]
      // })

      // _.forEach(stockedConfig["databases"], (dbItem) => {
      //   let newDbItem = _.cloneDeep(defaultDatabaseItem)
      //   newDbItem.uniqueId = _.uniqueId()
      //   _.forEach(newDbItem, (dbItemField) => {
      //     if (dbItemField.label == "useHostNetwork") {
      //       dbItemField.value = dbItem[dbItemField.label].toString()
      //     } else {
      //       dbItemField.value = dbItem[dbItemField.label]
      //     }
      //   })
      //   this.databases.push(newDbItem)
      // })
    }
  }
};
</script>

<style scoped>
.container .btn {
  margin-right: 25px;
}
</style>