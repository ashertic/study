<template>
  <a-modal
    :destroyOnClose="true"
    :visible="visible"
    :closable="false"
    :centered="true"
    :maskClosable="false"
    :footer="null"
    @cancel="() => $emit('cancel')"
    @ok="onCreateItem"
  >
    <!-- destroyOnClose可重置a-select的值 -->
    <a-input placeholder="请输入服务的名字" v-model="serviceName"></a-input>
    <div>
      <a-select placeholder="请选择要创建的类型" style="width: 80%" @change="onChange">
        <a-select-option value="ServiceK8SConfig">ServiceK8SConfig</a-select-option>
        <a-select-option value="EFKLoggingServiceK8SConfig">EFKLoggingServiceK8SConfig</a-select-option>
        <a-select-option value="RabbitMQServiceK8SConfig">RabbitMQServiceK8SConfig</a-select-option>
        <a-select-option value="RedisServiceK8SConfig">RedisServiceK8SConfig</a-select-option>
      </a-select>

      <div v-if="type==='ServiceK8SConfig'">
        <a-checkbox-group @change="onCheckBoxChange" v-model="itemAttrs">
          <a-row>
            <a-col :span="8">
              <a-checkbox disabled value="deployment">*deployment</a-checkbox>
            </a-col>
            <a-col :span="8">
              <a-checkbox value="clusterIPPorts">clusterIPPorts</a-checkbox>
            </a-col>
            <a-col :span="8">
              <a-checkbox value="nodePortPorts">nodePortPorts</a-checkbox>
            </a-col>
            <a-col :span="8">
              <a-checkbox value="ingressInfo">ingressInfo</a-checkbox>
            </a-col>
            <a-col :span="8">
              <a-checkbox value="volumes">volumes</a-checkbox>
            </a-col>
            <a-col :span="8">
              <a-checkbox value="externalName">externalName</a-checkbox>
            </a-col>
          </a-row>
        </a-checkbox-group>
      </div>
      <div v-else-if="type==='EFKLoggingServiceK8SConfig'"></div>
      <div v-else-if="type==='RabbitMQServiceK8SConfig'"></div>
      <div v-else-if="type==='RedisServiceK8SConfig'"></div>
    </div>
    <div class="button-group">
      <a-button-group>
        <a-button @click="$emit('cancel')">取消</a-button>
        <a-button type="primary" @click="onCreateItem" v-if="type!==''&& serviceName!==''">确认</a-button>
      </a-button-group>
    </div>
  </a-modal>
</template>

<script>
import _ from "lodash";

const servicesItem = {
  __type__: "Service",
  name: "",
  namespace: "",
  imageCategor: "",
  srcImage: "",
  deployImage: ""
};
const emptyServicesK8sConfigItem = {
  __type__: "ServiceK8SConfig",
  clusterIPPorts: [],
  nodePortPorts: [],
  volumes: [],
  ingressInfo: "",
  deployment: {
    __type__: "K8SDeployment",
    nodeTag: "",
    envs: [],
    volumes: [],
    needPrivilegedPermission: false,
    livenessProbe: ""
  },
  externalName: {
    __type__: "K8SExternalName",
    name: "",
    externalName: "",
    port: "",
    targetPort: ""
  }
};
const emptyEFKLoggingServiceK8SConfigItem = {
  __type__: "EFKLoggingServiceK8SConfig",
  nodeTag: ""
};
const emptyRabbitMQServiceK8SConfigItem = {
  __type__: "RabbitMQServiceK8SConfig",
  nodeTag: "",
  nodePort: 0,
  rabbitMQErlangCookie: "",
  rabbitMQUser: "",
  rabbitMQPassword: ""
};
const emptyRedisServiceK8SConfigItem = {
  __type__: "RedisServiceK8SConfig",
  nodeTag: "",
  redisPassword: ""
};
export default {
  name: "CreateServicesK8sItemModal.vue",
  props: {
    visible: Boolean
  },
  data() {
    return {
      type: "",
      itemAttrs: ["deployment"],
      emptyServicesK8sConfigItem,
      emptyEFKLoggingServiceK8SConfigItem,
      emptyRabbitMQServiceK8SConfigItem,
      emptyRedisServiceK8SConfigItem,
      servicesItem: {},
      serviceName: ""
    };
  },
  methods: {
    onChange(value) {
      this.type = value;
    },
    onCheckBoxChange(values) {
      console.log("check-box  this.itemAttrs,values", this.itemAttrs, values);
    },
    onCreateItem() {
      switch (this.type) {
        case "ServiceK8SConfig":
          const k8s = {};
          _.forEach(this.emptyServicesK8sConfigItem, (val, key) => {
            if (key === "__type__" || _.includes(this.itemAttrs, key)) {
              k8s[key] = val;
            }
          });
          this.servicesItem.k8s = k8s;
          break;
        case "EFKLoggingServiceK8SConfig":
          this.servicesItem.k8s = this.emptyEFKLoggingServiceK8SConfigItem;
          break;
        case "RabbitMQServiceK8SConfig":
          this.servicesItem.k8s = this.emptyRabbitMQServiceK8SConfigItem;
          break;
        case "RedisServiceK8SConfig":
          this.servicesItem.k8s = this.emptyRedisServiceK8SConfigItem;
          break;
      }
      this.servicesItem.name = this.serviceName;
      this.$emit("create", { item: this.servicesItem });
    },
    resetVal() {
      this.servicesItem = {};
      this.itemAttrs = ["deployment"];
      this.type = "";
      this.serviceName = "";
      this.servicesItem = _.clone(servicesItem);
    }
  },
  watch: {
    visible(newVal) {
      if (newVal) this.resetVal();
    }
  }
};
</script>

<style lang="less" scoped>
.button-group {
  text-align: right;
}
</style>
