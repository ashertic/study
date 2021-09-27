<template>
  <div>
    <a-modal
      :destroyOnClose="true"
      :visible="visible"
      :closable="false"
      :centered="true"
      :maskClosable="false"
      @cancel="() => $emit('cancel')"
      @ok="handleOk"
      width="1300px"
    >
      <div v-if="dataSource.__type__==='ServiceK8SConfig'">
        <a-collapse>
          <a-collapse-panel key="1" header="clusterIPPorts" v-if="k8s.clusterIPPorts">
            <div>
              <create-array-item-modal
                :keys="clusterIPPorts"
                :visible="createModalVisible.clusterIPPorts"
                @show="onShowCreateModal('clusterIPPorts')"
                @cancel="onCancelCreateModal('clusterIPPorts')"
                @create="item=>onCreateArrayItem(item,'clusterIPPorts')"
              />
              <render-array-item-table
                :dataSource="k8s.clusterIPPorts"
                :titles="clusterIPPorts"
                @change="(newData)=>onChangeArrayItem(newData,'clusterIPPorts')"
              />
            </div>
          </a-collapse-panel>
          <a-collapse-panel key="2" header="nodePortPorts" v-if="k8s.nodePortPorts">
            <div>
              <create-array-item-modal
                :keys="nodePortPorts"
                :visible="createModalVisible.nodePortPorts"
                @show="onShowCreateModal('nodePortPorts')"
                @cancel="onCancelCreateModal('nodePortPorts')"
                @create="item=>onCreateArrayItem(item,'nodePortPorts')"
              />
              <render-array-item-table
                :dataSource="k8s.nodePortPorts"
                :titles="nodePortPorts"
                @change="(newData)=>onChangeArrayItem(newData,'nodePortPorts')"
              />
            </div>
          </a-collapse-panel>
          <a-collapse-panel key="3" header="volumes" v-if="k8s.volumes">
            <div>
              <create-array-item-modal
                :keys="volumes"
                :visible="createModalVisible.volumes"
                @show="onShowCreateModal('volumes')"
                @cancel="onCancelCreateModal('volumes')"
                @create="item=>onCreateArrayItem(item,'volumes')"
              />
              <render-array-item-table
                :dataSource="k8s.volumes"
                :titles="volumes"
                @change="(newData)=>onChangeArrayItem(newData,'volumes')"
              />
            </div>
          </a-collapse-panel>
          <a-collapse-panel key="4" header="ingressInfo" v-if="k8s.ingressInfo">
            <a-input v-model="k8s.ingressInfo"></a-input>
          </a-collapse-panel>
          <a-collapse-panel key="5" header="externalName" v-if="k8s.externalName">
            <div v-for="(item,index) in k8s.externalName" :key="index">
              <div v-if="index!=='__type__'">
                {{index|required(k8s.externalName.__type__)}}:
                <a-input v-model="k8s.externalName[index]"></a-input>
              </div>
            </div>
          </a-collapse-panel>
          <a-collapse-panel
            key="6"
            header="*deployment"
            v-if="k8s.deployment"
            class="deployment-items"
          >
            <div>
              <a-row>
                <a-col :span="2">
                  <h3>*nodeTag:</h3>
                </a-col>
                <a-col :span="20">
                  <a-input v-model="k8s.deployment.nodeTag"></a-input>
                </a-col>
              </a-row>
            </div>
            <div v-if="haveDeploymentKey('needPrivilegedPermission')">
              <a-row class="radio-group">
                <a-col :span="4">
                  <h3>needPrivilegedPermission:</h3>
                </a-col>
                <a-col :span="12">
                  <a-radio-group
                    :defaultValue="k8s.deployment.needPrivilegedPermission"
                    @change="e => handleRadioChange(e.target.value)"
                  >
                    <a-radio :value="true">true</a-radio>
                    <a-radio :value="false">false</a-radio>
                  </a-radio-group>
                </a-col>
              </a-row>
            </div>
            <div v-if="k8s.deployment.livenessProbe">
              <a-row>
                <a-col :span="2">
                  <h3>livenessProbe</h3>
                </a-col>
                <a-col :span="20">
                  <a-input v-model="k8s.deployment.livenessProbe"></a-input>
                </a-col>
              </a-row>
            </div>
            <div v-if="k8s.deployment.envs">
              <h3>*envs:</h3>
              <create-array-item-modal
                :keys="k8sDeploymentEnvs"
                :visible="createModalVisible.deployment.envs"
                @show="onShowDeploymentCreateModal('envs')"
                @cancel="onCancelDeploymentCreateModal('envs')"
                @create="item=>onCreateDeploymentArrayItem(item,'envs')"
              />
              <render-array-item-table
                :dataSource="k8s.deployment.envs"
                :titles="k8sDeploymentEnvs"
                @change="(newData)=>onChangeDeploymentArrayItem(newData,'envs')"
              />
            </div>
            <div v-if="k8s.deployment.volumes">
              <h3>volumes:</h3>
              <create-array-item-modal
                :keys="k8sDeploymentVolumes"
                :visible="createModalVisible.deployment.volumes"
                @show="onShowDeploymentCreateModal('volumes')"
                @cancel="onCancelDeploymentCreateModal('volumes')"
                @create="item=>onCreateDeploymentArrayItem(item,'volumes')"
              />
              <render-array-item-table
                :dataSource="k8s.deployment.volumes"
                :titles="k8sDeploymentVolumes"
                @change="(newData)=>onChangeDeploymentArrayItem(newData,'volumes')"
              />
            </div>
          </a-collapse-panel>
        </a-collapse>
      </div>
      <div v-else>
        <div v-for="(item,index) in k8s" :key="index">
          <a-row class="container" :gutter="16" v-if="index!=='__type__'">
            <a-col :span="10" class="right">
              <span class="label">{{index | required(k8s.__type__)}}:</span>
            </a-col>
            <a-col :span="12">
              <a-input v-model="k8s[index]"></a-input>
            </a-col>
          </a-row>
        </div>
      </div>
    </a-modal>
  </div>
</template>
<script>
import _ from "lodash";
import RenderArrayItemTable from "@/components/RenderArrayItemTable/RenderArrayItemTable.vue";
import CreateArrayItemModal from "@/components/CreatItemModal/CreateArrayItemModal.vue";

export default {
  name: "ServiceK8sConfigModal",
  components: { RenderArrayItemTable, CreateArrayItemModal },
  props: {
    visible: Boolean,
    dataSource: Object
  },
  data() {
    return {
      k8s: {},
      createModalVisible: {
        volumes: false,
        nodePortPorts: false,
        clusterIPPorts: false,
        deployment: {
          envs: false,
          volumes: false
        }
      }
    };
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.resetForm();
        this.handleSetFormVal();
      }
    }
  },
  methods: {
    haveDeploymentKey(key) {
      if (_.has(this.k8s.deployment, key)) {
        return true;
      }
      return false;
    },
    handleSetFormVal() {
      const data = _.cloneDeep(this.dataSource);
      _.forEach(data, (value, key) => {
        this.$set(this.k8s, key, value);
      });
    },
    resetForm() {
      this.k8s = {};
    },
    onChangeArrayItem(newData, key) {
      this.k8s[key] = newData;
    },
    onChangeDeploymentArrayItem(newData, key) {
      this.k8s.deployment[key] = newData;
    },
    onShowCreateModal(index) {
      this.createModalVisible[index] = true;
    },
    onShowDeploymentCreateModal(index) {
      this.createModalVisible.deployment[index] = true;
    },
    onCancelCreateModal(index) {
      this.createModalVisible[index] = false;
    },
    onCancelDeploymentCreateModal(index) {
      this.createModalVisible.deployment[index] = false;
    },
    onCreateArrayItem(item, index) {
      this.k8s[index] = [...this.k8s[index], item];
      this.createModalVisible[index] = false;
    },
    onCreateDeploymentArrayItem(item, index) {
      this.k8s.deployment[index] = [...this.k8s.deployment[index], item];
      this.createModalVisible.deployment[index] = false;
    },
    handleOk() {
      this.$emit("changeK8s", { item: this.k8s });
    },
    handleRadioChange(val) {
      console.log("val, index", val);
      this.k8s.deployment.needPrivilegedPermission = val;
    }
  },
  computed: {
    clusterIPPorts() {
      return [
        { __type__: "K8SClusterIPPort" },
        { title: "port", type: "Number" },
        { title: "targetPort", type: "Number" }
      ];
    },
    nodePortPorts() {
      return [
        { __type__: "K8SNodePortPort" },
        { title: "nodePort", type: "Number" },
        { title: "port", type: "Number" },
        { title: "targetPort", type: "Number" }
      ];
    },
    volumes() {
      return [
        { __type__: "K8SVolume" },
        { title: "name", type: "String" },
        { title: "capacityStorage", type: "Number" },
        { title: "hostPath", type: "String" }
      ];
    },
    k8sDeploymentEnvs() {
      return [
        { __type__: "K8SDeploymentDirectEnv" },
        { title: "name", type: "String" },
        { title: "value", type: "String" }
      ];
    },
    k8sDeploymentVolumes() {
      return [
        { __type__: "K8SDeploymentVolume" },
        { title: "name", type: "String" },
        { title: "claimName", type: "String" },
        { title: "mountPath", type: "String" }
      ];
    }
  }
};
</script>

<style  lang="less"  scoped>
.container {
  justify-content: center;
  margin: 16px;
}
.content {
  width: 80%;
}
.right {
  text-align: right;
  height: 32px;
  margin-top: 6.5px;
}
.label {
  padding-right: 15px;
  color: blue;
  font-weight: bolder;
}
.deployment-items div {
  margin: 4px 0 4px 0;
}
</style>