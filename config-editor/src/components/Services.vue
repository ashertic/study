<template>
  <div>
    <a-table :columns="columns" :dataSource="services" rowKey="name" :pagination="true">
      <template slot="name" slot-scope="text, record">
        <editable-cell :text="text" @change="onCellChange(record, 'name', $event)" />
      </template>
      <template slot="namespace" slot-scope="text, record">
        <editable-cell :text="text" @change="onCellChange(record, 'namespace', $event)" />
      </template>
      <template slot="deployImage" slot-scope="text, record">
        <editable-cell :text="text" @change="onCellChange(record, 'deployImage', $event)" />
      </template>
      <template slot="srcImage" slot-scope="text, record">
        <editable-cell :text="text" @change="onCellChange(record, 'srcImage', $event)" />
      </template>
      <template slot="imageCategory" slot-scope="text, record">
        <editable-cell :text="text" @change="onCellChange(record, 'imageCategory', $event)" />
      </template>
      <span slot="container" slot-scope="text, record">
        <a @click="onShowModal(text[containerName], record.name)">查看</a>
      </span>
      <span slot="customTitle">{{containerName}}</span>
      <span slot="action" slot-scope="text, record">
        <a-popconfirm
          title="确认删除该项吗"
          ok-text="Yes"
          cancel-text="No"
          @confirm="onServicesItemDelete(record.name)"
        >
          <a>删除</a>
        </a-popconfirm>
      </span>
    </a-table>
    <service-k8s-config-modal
      @cancel="onCancel"
      :visible="modalVisible"
      :dataSource="modalDataSoruce"
      @changeK8s="onChangeSercices"
      v-if="containerName==='k8s'"
    />
    <service-docker-config-modal
      @cancel="onCancel"
      :visible="modalVisible"
      :dataSource="modalDataSoruce"
      @changeDocker="onChangeSercices"
      v-else-if="containerName==='docker'"
    />
    <create-services-k8s-item-modal
      @cancel="onCreateServicesModalCancel"
      :visible="createK8sModalVisible"
      @create="onCreateServicesItem"
    />
    <create-services-docker-item-modal
      @cancel="onCreateServicesModalCancel"
      :visible="createDockerModalVisible"
      @create="onCreateServicesItem"
    />
    <a-button type="primary" @click="onShowCreateServicesModal">添加</a-button>
  </div>
</template>

<script>
import _ from "lodash";

import EditableCell from "@/components/EditableCell/EditableCell";
import ServiceK8sConfigModal from "@/components/ServicesModal/ServiceK8sConfigModal.vue";
import CreateServicesK8sItemModal from "@/components/ServicesModal/CreateServicesK8sItemModal.vue";
import ServiceDockerConfigModal from "@/components/ServicesModal/ServiceDockerConfigModal.vue";
import CreateServicesDockerItemModal from "@/components/ServicesModal/CreateServicesDockerItemModal.vue";
const columns = [
  {
    title: "*name",
    dataIndex: "name",
    key: "name",
    scopedSlots: { customRender: "name" }
  },
  {
    title: "*namespace",
    dataIndex: "namespace",
    key: "namespace",
    scopedSlots: { customRender: "namespace" }
  },
  {
    title: "deployImage",
    dataIndex: "deployImage",
    key: "deployImage",
    scopedSlots: { customRender: "deployImage" }
  },
  {
    title: "*srcImage",
    dataIndex: "srcImage",
    key: "srcImage",
    scopedSlots: { customRender: "srcImage" }
  },
  {
    title: "*imageCategory",
    dataIndex: "imageCategory",
    key: "imageCategory",
    scopedSlots: { customRender: "imageCategory" }
  },
  {
    key: "container",
    slots: { title: "customTitle" },
    scopedSlots: { customRender: "container" }
  },
  {
    title: "操作",
    key: "action",
    scopedSlots: { customRender: "action" }
  }
];

export default {
  name: "Services",
  data() {
    return {
      columns,
      modalVisible: false,
      modalDataSoruce: {},
      rowIndex: "",
      createK8sModalVisible: false,
      createDockerModalVisible: false
    };
  },
  components: {
    EditableCell,
    ServiceK8sConfigModal,
    CreateServicesK8sItemModal,
    ServiceDockerConfigModal,
    CreateServicesDockerItemModal
  },
  computed: {
    services() {
      if (this.$store.state.content.services) {
        return this.$store.state.content.services;
      } else {
        return [];
      }
    },
    containerName() {
      if (this.$store.state.content.services) {
        const item = this.$store.state.content.services[0];
        if (item.k8s) return "k8s";
        else if (item.docker) return "docker";
        else return "";
      } else {
        return "";
      }
    }
  },
  methods: {
    onShowCreateServicesModal() {
      if (this.containerName === "k8s") {
        this.createK8sModalVisible = true;
      } else {
        this.createDockerModalVisible = true;
      }
    },
    onShowModal(data, rowIndex) {
      this.rowIndex = rowIndex;
      this.modalDataSoruce = data;
      this.modalVisible = true;
    },
    onCancel() {
      this.rowIndex = "";
      this.modalVisible = false;
    },
    onCreateServicesModalCancel() {
      if (this.containerName === "k8s") {
        this.createK8sModalVisible = false;
      } else {
        this.createDockerModalVisible = false;
      }
    },
    onCellChange(record, dataIndex, value) {
      const { name } = record;
      const dataSource = [...this.services];
      const target = dataSource.find(item => item.name === name);
      if (target) {
        target[dataIndex] = value;
        this.$store.commit("setServices", dataSource);
      }
    },
    onChangeSercices({ item }) {
      const dataSource = [...this.services];
      const target = dataSource.find(el => el.name === this.rowIndex);
      target[this.containerName] = item;
      this.$store.commit("setServices", dataSource);
      this.modalVisible = false;
      this.rowIndex = "";
    },
    onChangeK8s({ k8s }) {
      const dataSource = [...this.services];
      const target = dataSource.find(item => item.name === this.rowIndex);
      target.k8s = k8s;
      this.$store.commit("setServices", dataSource);
      this.modalVisible = false;
      this.rowIndex = "";
    },
    onChangeDocker({ docker }) {
      const dataSource = [...this.services];
      const target = dataSource.find(item => item.name === this.rowIndex);
      target.docker = docker;
      this.$store.commit("setServices", dataSource);
      this.modalVisible = false;
      this.rowIndex = "";
    },
    onServicesItemDelete(rowName) {
      const dataSource = [...this.services];
      const index = _.findIndex(dataSource, el => el.name === rowName);
      dataSource.splice(index, 1);
      this.$store.commit("setServices", dataSource);
    },
    onCreateServicesItem({ item }) {
      const dataSource = [...this.services];
      dataSource.unshift(item);
      this.$store.commit("setServices", dataSource);
      if (this.containerName === "k8s") {
        this.createK8sModalVisible = false;
      } else {
        this.createDockerModalVisible = false;
      }
    }
  }
};
</script>

<style lang="less" scoped>
</style>
