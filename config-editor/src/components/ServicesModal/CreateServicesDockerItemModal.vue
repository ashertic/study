<template>
  <a-modal
    :destroyOnClose="true"
    :visible="visible"
    :closable="false"
    :centered="true"
    :maskClosable="false"
    :footer="null"
  >
    <a-input placeholder="请输入服务的名字" v-model="serviceName"></a-input>
    <br />
    <br />
    <a-checkbox-group v-model="itemAttrs">
      <a-checkbox value="privileged">privileged</a-checkbox>
    </a-checkbox-group>
    <br />
    <br />
    <div class="button-group">
      <a-button-group class="button-group">
        <a-button @click="$emit('cancel')">取消</a-button>
        <a-button type="primary" @click="onCreateItem" v-if="serviceName!==''">确认</a-button>
      </a-button-group>
    </div>
  </a-modal>
</template>

<script>
import _ from "lodash";

export default {
  name: "CreateServicesDockerItemModal",
  props: {
    visible: Boolean
  },
  data() {
    return {
      itemAttrs: [],
      serviceName: ""
    };
  },
  computed: {},
  methods: {
    onCreateItem() {
      const servicesItem = {
        __type__: "Service",
        name: this.serviceName,
        namespace: "",
        imageCategor: "",
        srcImage: "",
        deployImage: ""
      };
      const docker = {
        __type__: "ServiceDockerConfig",
        containerName: "",
        restart: "",
        useHostNetwork: true,
        ports: [],
        envs: [],
        volumes: [],
        command: ""
      };
      if (_.includes(this.itemAttrs, "privileged")) {
        docker.privileged = true;
      }
      servicesItem.docker = docker;
      this.$emit("create", { item: servicesItem });
    }
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.itemAttrs = [];
        this.serviceName = "";
      }
    }
  }
};
</script>

<style lang="less" scoped>
.button-group {
  text-align: right;
}
</style>
