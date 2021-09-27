<template>
  <a-card style="width: 1600px">
    <div class="container">
      <div class="content">
        <div v-for="(item,index) in dbInitializer" :key="index">
          <a-row class="row" v-if="index!=='__type__'" :gutter="16">
            <!--  item:val index:key -->
            <a-col :span="6" class="right">
              <span class="label">{{ index | required(dbInitializer.__type__) }} :</span>
            </a-col>
            <a-col :span="12" class="col-value" v-if="checkValueType(item)==='string'">
              <editable-cell :text="item" @change="onCellChange(index, $event)" />
            </a-col>
            <a-col :span="4" class="col-value" v-if="checkValueType(item)==='boolean'">
              <a-radio-group
                :defaultValue="item"
                @change="e => handleRadioChange(e.target.value,index)"
              >
                <a-radio :value="true">true</a-radio>
                <a-radio :value="false">false</a-radio>
              </a-radio-group>
            </a-col>
            <a-col :span="12" class="col-value" v-else-if="checkValueType(item)==='array'">
              <div v-for="(text,i) in item" :key="i" class="array-item">
                <a-row>
                  <a-col :span="23">
                    <editable-cell :text="text" @change="onArrayStringChange(index,item,i,$event)" />
                  </a-col>
                  <a-col :span="1">
                    <delete-array-item @delete="onDeleteValue(index,item,i)" />
                  </a-col>
                </a-row>
                <a-divider />
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
    <template slot="actions" class="ant-card-actions">
      <slot name="delete-button"></slot>
    </template>
  </a-card>
</template>

<script>
import EditableCell from "@/components/EditableCell/EditableCell";
import CreateArrayStringModal from "@/components/CreatItemModal/CreateArrayStringModal.vue";
import DeleteArrayItem from "@/components/CreatItemModal/DeleteArrayItem.vue";
export default {
  components: { EditableCell, CreateArrayStringModal, DeleteArrayItem },
  props: {
    dbInitializer: Object,
    initializerIndex: Number
  },
  data() {
    return {
      addValueModalVisible: false
    };
  },
  methods: {
    onCellChange(index, val) {
      const options = { key: index, val, index: this.initializerIndex };
      this.$store.commit("setDbInitializers", options);
    },
    onArrayStringChange(index, item, i, val) {
      const arr = [...item];
      arr[i] = val;
      const options = { key: index, val: arr, index: this.initializerIndex };
      this.$store.commit("setDbInitializers", options);
    },
    checkValueType(obj) {
      const type = Object.prototype.toString.call(obj);
      if (type === "[object String]") {
        return "string";
      } else if (type === "[object Array]") {
        return "array";
      } else if (type === "[object Boolean]") {
        return "boolean";
      } else return "object";
    },
    onShowAddValueModal() {
      this.addValueModalVisible = true;
    },
    onAddValueModalCancel() {
      this.addValueModalVisible = false;
    },
    onAddValue({ val, key }) {
      const options = { val, key, index: this.initializerIndex };
      this.$store.commit("addDbInitializersByIndex", options);
      this.addValueModalVisible = false;
    },
    onDeleteValue(index, item, i) {
      const arr = [...item];
      arr.splice(i, 1);
      const options = { key: index, val: arr, index: this.initializerIndex };
      this.$store.commit("setDbInitializers", options);
    },
    handleRadioChange(val, index) {
      const options = { key: index, val, index: this.initializerIndex };
      this.$store.commit("setDbInitializers", options);
    }
  },
  computed: {},
  watch: {}
};
</script>

<style lang="less">
@import "~ant-design-vue/lib/style/index.less";

.row {
  margin: 16px;
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

.array-item .ant-divider-horizontal {
  margin: 4px 0;
  height: 2px;
}
.col-value {
  text-align: left;
}
</style>