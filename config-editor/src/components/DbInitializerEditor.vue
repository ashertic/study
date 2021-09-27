<template>
  <div class="container">
    <div class="databases" style="margin-top:10px; padding-right:25px;">
      <FieldSetSection 
        v-for="(item, index) in databases" 
        :title="'数据库配置' + (index + 1)" 
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
        增加新的数据库配置项
      </a-button>
    </div>
  </div>
</template>

<script>
import FieldEditor from "@/components/FieldEditor";
import _ from "lodash"
import FieldSetSection from "@/components/FieldSetSection.vue";

const defaultDatabaseItem = [
  { label: "name" , desc: "针对的数据库的名字", value: "" },
  { label: "imageCategory" , desc: "Docker镜像所属类别", value: "" },
  { label: "srcImage" , desc: "Docker镜像名字（非完整镜像名称，不包含镜像源地址信息）", value: "" },
  { contentType: "array", label: "envs" , desc: "数据库连接用户名", value: "" },
]

function convertToJson(that) {
  let jsonObj = []

  _.forEach(that.databases, (d) => {
    let dObj = {
      '__type__': 'DatabaseInitializer'
    }
    _.forEach(d, (f) => {
      dObj[f.label] = f.value
    })
    jsonObj.push(dObj)
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
      databases: []
    };
  },
  methods: {
    onDatabaseItemFieldChange(index, fieldIndex, value) {
      this.databases[index][fieldIndex].value = value
      console.log(index, fieldIndex, value)

      let jsonObj = convertToJson(this)
      this.$store.commit("setDbInitializers", jsonObj);
    },
    createNewDBItem() {
      let newDbItem = _.cloneDeep(defaultDatabaseItem)
      newDbItem.uniqueId = _.uniqueId()
      this.databases.push(newDbItem)

      let jsonObj = convertToJson(this)
      this.$store.commit("setDbInitializers", jsonObj);
    },
    onDatabaseItemRemove(index) {
      this.databases.splice(index, 1)

      let jsonObj = convertToJson(this)
      this.$store.commit("setDbInitializers", jsonObj);
    }
  },
  created() {
    let stockedConfig = this.$store.state.dbInitializers
    console.log(stockedConfig)
    if (stockedConfig == null) {
      let jsonObj = convertToJson(this)
      this.$store.commit("setDbInitializers", jsonObj);
    } else {
      _.forEach(stockedConfig, (dbItem) => {
        let newDbItem = _.cloneDeep(defaultDatabaseItem)
        newDbItem.uniqueId = _.uniqueId()
        _.forEach(newDbItem, (dbItemField) => {
          dbItemField.value = dbItem[dbItemField.label]
        })
        this.databases.push(newDbItem)
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