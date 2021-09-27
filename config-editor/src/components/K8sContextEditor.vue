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
      fields : [
        { contentType: "array", label: "namespaces" , desc: "K8S命名空间列表", value: ["logging", "identity", "expert"] },
        { label: "yamlOutputRootDir" , desc: "K8S YAML配置文件输出根路径", value: "" },
        { label: "imagePullSecrets" , desc: "K8S POD拉去Image的密钥", value: "meinenghua" },
      ]
    };
  },
  methods: {
    onFieldChange(index, value) {
      this.fields[index].value = value
      console.log(JSON.stringify(this.fields[index]))

      let jsonObj = {
        '__type__': 'K8SContext'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setK8sContext", jsonObj);
    }
  },
  created() {
    let stockedConfig = this.$store.state.k8sContext
    if (stockedConfig == null) {
      let jsonObj = {
        '__type__': 'K8SContext'
      }

      _.forEach(this.fields, (f) => {
        jsonObj[f.label] = f.value
      })

      this.$store.commit("setK8sContext", jsonObj);
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