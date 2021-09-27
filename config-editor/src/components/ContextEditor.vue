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
    return {
      fields: [
        { label: "customer" , desc: "所属客户名称", value: "" },
        { label: "project" , desc: "项目名称", value: "" },
        { contentType: "select", label: "env" , desc: "目标环境类型", choices: ["development", "production"],  value: "production" },
        { label: "description" , desc: "关于本配置的描述说明", value: "" },
        { contentType: "select", label: "mode" , desc: "部署的模式", choices: ["k8s", "docker"],  value: "" },
        { contentType: "select", label: "os" , desc: "目标机器操作系统", choices: ["centos", "ubuntu"],  value: "" },
        { label: "osVersion" , desc: "机器操作系统版本号", value: "" },
        { label: "dataPathRoot" , desc: "数据挂载根目录路径", value: "" },
        { label: "imageOutputRootDir" , desc: "服务Docker镜像文件存储根目录路径", value: "" },
      ],
    };
  },
  methods: {
    onFieldChange(index, value) {
      this.fields[index].value = value
      console.log(JSON.stringify(this.fields[index]))

      let jsonObj = {
        '__type__': 'Context'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setContext", jsonObj);
    }
  },
  created() {
    let storedContext = this.$store.state.context
    if (storedContext == null) {
      let jsonObj = {
        '__type__': 'Context'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setContext", jsonObj);
    } else {
      _.forEach(this.fields, (f) => {
        f.value = storedContext[f.label]
      })
    }
  }
};
</script>

<style lang="less" scoped>
</style>