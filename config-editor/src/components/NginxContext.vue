<template>
  <div class="container">
    <div class="content">
      <div v-for="(item,index) in nginxContext" :key="index">
        <a-row class="row" v-if="index!=='__type__'" :gutter="16">
          <!--  item:val index:key -->
          <a-col :span="4" class="right">
            <span class="label">{{ index | required(nginxContext.__type__) }}</span>
          </a-col>
          <a-col :span="12" class="col-value" v-if="checkValueType(item)==='string'">
            <editable-cell :text="item" @change="onCellChange(index, $event)" />
          </a-col>

          <a-col :span="20" v-else-if="checkValueType(item)==='array'" class="add-item-table">
            <create-array-item-modal
              :keys="titles"
              :visible="createModalVisible"
              @show="onShowCreateModal"
              @cancel="onCancelCreateModal"
              @create="(content)=>onCreateArrayItem(content,index)"
            />
            <render-array-item-table
              :dataSource="item"
              :titles="titles"
              @change="(newData)=>onChangeArrayItem(newData,index)"
            />
          </a-col>
        </a-row>
      </div>
    </div>
  </div>
</template>

<script>
import EditableCell from "@/components/EditableCell/EditableCell";
import DeleteArrayItem from "@/components/CreatItemModal/DeleteArrayItem.vue";
import RenderArrayItemTable from "@/components/RenderArrayItemTable/RenderArrayItemTable.vue";
import CreateArrayItemModal from "@/components/CreatItemModal/CreateArrayItemModal.vue";
export default {
  name: "NginxContext",
  components: { EditableCell, RenderArrayItemTable, CreateArrayItemModal },
  data() {
    return {
      createModalVisible: false
    };
  },
  methods: {
    onCellChange(index, val) {
      const options = { contentKey: "nginxContext", key: index, val };
      this.$store.commit("changeContent", options);
    },
    checkValueType(obj) {
      const type = Object.prototype.toString.call(obj);
      if (type === "[object String]") {
        return "string";
      } else if (type === "[object Array]") {
        return "array";
      } else {
        return "object";
      }
    },
    onChangeArrayItem(newData, index) {
      const options = { contentKey: "nginxContext", key: index, val: newData };
      this.$store.commit("changeContent", options);
    },
    onShowCreateModal() {
      this.createModalVisible = true;
    },
    onCancelCreateModal() {
      this.createModalVisible = false;
    },
    onCreateArrayItem(content, index) {
      const options = { contentKey: "nginxContext", key: index, val: content };
      this.$store.commit("addContentItem", options);
      this.createModalVisible = false;
    }
  },
  computed: {
    nginxContext() {
      if (this.$store.state.content.nginxContext) {
        return this.$store.state.content.nginxContext;
      } else {
        return {};
      }
    },
    titles() {
      return [
        { __type__: "NginxServerConfig" },
        { title: "comment", type: "String" },
        { title: "sslListenPort", type: "Number" },
        { title: "serverName", type: "String" },
        { title: "proxyPass", type: "String" }
      ];
    }
  },
  watch: {}
};
</script>

<style lang="less" scoped>
.container {
  width: 100%;
}

.row {
  margin: 36px;
}
.right {
  text-align: right;
}
.label {
  padding-right: 15px;
  color: blue;
  font-weight: bolder;
}
.add-value {
  text-align: left;
}

.add-item-table {
  text-align: left;
}
</style>