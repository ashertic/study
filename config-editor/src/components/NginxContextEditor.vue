<template>
  <div class="container">
    <FieldEditor v-for="(item, index) in fields" 
      :key="index" 
      :field="item" 
      @save="onFieldChange(index, $event)" />
    
    <div class="databases" style="margin-top:10px; padding-right:25px;">
      <FieldSetSection 
        v-for="(item, index) in servers" 
        :title="'服务配置' + (index + 1)" 
        :key="item.uniqueId"
        @remove="onDatabaseItemRemove(index)" >
        <FieldEditor v-for="(dbItem, dbIndex) in item" 
          :key="dbIndex" 
          :field="dbItem" 
          @save="onDatabaseItemFieldChange(index, dbIndex, $event)" />
      </FieldSetSection>
    </div>
    <div class="btn">
      <a-button type="primary" block @click="createNewDBItem">
        增加新的服务配置项
      </a-button>
    </div>
  </div>
</template>

<script>
import FieldEditor from "@/components/FieldEditor";
import _ from "lodash"
import FieldSetSection from "@/components/FieldSetSection.vue";

const defaultDatabaseItem = [
  { label: "comment" ,  desc: "本NGINX服务的注释，会写入NGINX配置文件中，方便调试", value: "" },
  { label: "sslListenPort" , desc: "开启HTTPS时，对应的SSL的监听端口", value: "" },
  { label: "serverName" , desc: "本NGINX服务的URL地址，不同服务可能共用同一个，对应不同的端口", value: "" },
  { label: "proxyPass" , desc: "本NGINX服务要转发请求的目标服务的全路径", value: "" },
]

function convertToJson(that) {
  let jsonObj = {
    '__type__': 'NginxContext'
  }

  _.forEach(that.fields, (f) => {
    jsonObj[f.label] = f.value
  })

  jsonObj["servers"] = []
  _.forEach(that.servers, (d) => {
    let dObj = {
      '__type__': 'NginxServerConfig'
    }
    _.forEach(d, (f) => {
      if (f.label == 'sslListenPort') {
        dObj[f.label] = _.toInteger(f.value)
      } else {
        dObj[f.label] = f.value
      }
    })
    jsonObj["servers"].push(dObj)
  })

  return jsonObj
}

export default {
  components: { 
    FieldEditor,
    FieldSetSection 
  },
  data() {
    return {
      fields : [
        { label: "certDir" , desc: "安全证书所在路径，当使用了HTTPS时一般都需要，可以用相对路径", value: "" },
        { label: "targetNginxDir" , desc: "NGINX容器运行时需要挂在的NGINX数据的磁盘路径", value: "" },
        { label: "containerName" , desc: "NGINX容器的实例名字", value: "" },
        { label: "imageCategory" , desc: "NGINX Docker镜像的类别", value: "thirdparty" },
        { label: "srcImage" , desc: "NGINX Docker镜像的名字，不包含镜像源的路径", value: "nginx:1.17.6" },
      ],
      servers: []
    };
  },
  methods: {
    onFieldChange(index, value) {
      this.fields[index].value = value

      let jsonObj = convertToJson(this)
      this.$store.commit("setNginxContext", jsonObj);
    },
    onDatabaseItemFieldChange(index, fieldIndex, value) {
      this.servers[index][fieldIndex].value = value

      let jsonObj = convertToJson(this)
      this.$store.commit("setNginxContext", jsonObj);
    },
    createNewDBItem() {
      let newDbItem = _.cloneDeep(defaultDatabaseItem)
      newDbItem.uniqueId = _.uniqueId()
      this.servers.push(newDbItem)

      let jsonObj = convertToJson(this)
      this.$store.commit("setNginxContext", jsonObj);
    },
    onDatabaseItemRemove(index) {
      this.servers.splice(index, 1)

      let jsonObj = convertToJson(this)
      this.$store.commit("setNginxContext", jsonObj);
    }
  },
  created() {
    let stockedConfig = this.$store.state.nginxContext
    if (stockedConfig == null) {
      let jsonObj = convertToJson(this)
      this.$store.commit("setNginxContext", jsonObj);
    } else {
      _.forEach(this.fields, (f) => {
        f.value = stockedConfig[f.label]
      })

      _.forEach(stockedConfig["servers"], (dbItem) => {
        let newDbItem = _.cloneDeep(defaultDatabaseItem)
        newDbItem.uniqueId = _.uniqueId()
        _.forEach(newDbItem, (dbItemField) => {
          if (dbItemField.label == 'sslListenPort') {
            dbItemField.value = dbItem[dbItemField.label].toString()
          } else {
            dbItemField.value = dbItem[dbItemField.label]
          }
          
        })
        this.servers.push(newDbItem)
      })
    }
  }
};
</script>

<style scoped>
.container .btn {
  margin-right: 25px;
}
</style>