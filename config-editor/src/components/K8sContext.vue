<template>
  <div class="container">
    <div class="content">
      <div v-for="(item,index) in k8sContext" :key="index">
        <a-row class="row" v-if="index!=='__type__'" :gutter="16">
          <!--  item:val index:key -->
          <a-col :span="10" class="right">
            <span class="label">{{ index | required(k8sContext.__type__) }}</span>
          </a-col>
          <a-col :span="12" class="col-value" v-if="checkValueType(item)==='string'">
            <editable-cell :text="item" @change="onCellChange(index, $event)" />
          </a-col>
          <a-col :span="12" class="col-value" v-else-if="checkValueType(item)==='array'">
            <div v-for="(text,i) in item" :key="i">
              <a-row>
                <a-col :span="8">
                  <editable-cell :text="text" @change="onArrayStringChange(index,item,i,$event)" />
                </a-col>
                <a-col :span="1">
                  <delete-array-item @delete="onDeleteValue(index,item,i)" />
                </a-col>
              </a-row>
            </div>
            <div class="add-value">
              <create-array-string-modal
                :visible="addValueModalVisible"
                :objKey="index"
                @show="onShowAddValueModal"
                @cancel="onAddValueModalCancel"
                @addValue="onAddValue"
              />
            </div>
          </a-col>
        </a-row>
      </div>
    </div>
  </div>
</template>

<script>
import EditableCell from "@/components/EditableCell/EditableCell";
import CreateArrayStringModal from "@/components/CreatItemModal/CreateArrayStringModal.vue";
import DeleteArrayItem from "@/components/CreatItemModal/DeleteArrayItem.vue";
export default {
  components: { EditableCell, CreateArrayStringModal, DeleteArrayItem },
  data() {
    return {
      addValueModalVisible: false
    };
  },
  methods: {
    onCellChange(index, val) {
      const options = { contentKey: "k8sContext", key: index, val };
      this.$store.commit("changeContent", options);
    },
    onArrayStringChange(index, item, i, val) {
      const arr = [...item];
      arr[i] = val;
      const options = { contentKey: "k8sContext", key: index, val: arr };
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
    onShowAddValueModal() {
      this.addValueModalVisible = true;
    },
    onAddValueModalCancel() {
      this.addValueModalVisible = false;
    },
    onAddValue({ val, key }) {
      const options = { contentKey: "k8sContext", val, key };
      this.$store.commit("addContentItem", options);
      this.addValueModalVisible = false;
    },
    onDeleteValue(index, item, i) {
      const arr = [...item];
      arr.splice(i, 1);
      const options = { contentKey: "k8sContext", key: index, val: arr };
      this.$store.commit("changeContent", options);
    }
  },
  computed: {
    k8sContext() {
      if (this.$store.state.content.k8sContext) {
        return this.$store.state.content.k8sContext;
      } else {
        return {};
      }
    }
  },
  watch: {}
};
</script>

<style lang="less" scoped>
.container {
  width: 100%;
  display: flex;
  justify-content: center;
  // justify-items: center;
}
.content {
  width: 80%;
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
</style>