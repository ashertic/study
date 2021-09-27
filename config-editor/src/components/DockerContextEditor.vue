<template>
  <div class="container">
    <FieldEditor v-for="(item, index) in fields" 
      :key="index" 
      :field="item" 
      @save="onFieldChange(index, $event)" />
  </div>
</template>

<script>
import FieldEditor from "@/components/FieldEditor";
import _ from "lodash"

export default {
  components: { FieldEditor },
  data() {
    let configMode = this.$store.state.mode
    let isTargetFieldsRequired = (configMode == "k8s")

    return {
      fields : [
        { label: "srcRegistryBase" , desc: "Docker镜像下载源地址前缀", value: "swr.cn-north-4.myhuaweicloud.com/meinenghua/" },
        { label: "targetRegistryBase" , isRequired: isTargetFieldsRequired, desc: "部署时本地私有Docker镜像仓库地址前缀", value: "" },
        { label: "targetRegistryUser" , isRequired: isTargetFieldsRequired, desc: "部署时本地私有Docker镜像仓库用户名", value: "testuser" },
        { label: "targetRegistryPassword" , isRequired: isTargetFieldsRequired, desc: "部署时本地私有Docker镜像仓库密码", value: "minerva" },
      ]
    };
  },
  methods: {
    onFieldChange(index, value) {
      this.fields[index].value = value
      console.log(JSON.stringify(this.fields[index]))

      let jsonObj = {
        '__type__': 'DockerContext'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setDockerContext", jsonObj);
    }
  },
  created() {
    let stockedConfig = this.$store.state.dockerContext
    if (stockedConfig == null) {
      let jsonObj = {
        '__type__': 'DockerContext'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setDockerContext", jsonObj);
    } else {
      _.forEach(this.fields, (f) => {
        f.value = stockedConfig[f.label]
      })
    }
  }
};
</script>

<style scoped>
</style>