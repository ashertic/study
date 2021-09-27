<template>
  <div>
    <a-modal
      :visible="visible"
      :closable="false"
      :centered="true"
      :maskClosable="false"
      @cancel="() => $emit('cancel')"
      @ok="handleOk"
      width="1300px"
    >
      <div class="container">
        <div class="content">
          <div v-for="(item,index) in docker" :key="index">
            <div v-if="index!=='__type__'">
              <a-row class="row" :gutter="16">
                <a-col :span="10" class="right">
                  <span class="label">{{ index | required(docker.__type__) }}</span>
                </a-col>
                <a-col :span="12" v-if="checkValueType(item) === '[object String]'">
                  <a-input v-model="docker[index]"></a-input>
                </a-col>
                <a-col :span="12" v-else-if="checkValueType(item) === '[object Boolean]'">
                  <a-radio-group v-model="docker[index]">
                    <a-radio :value="true">true</a-radio>
                    <a-radio :value="false">false</a-radio>
                  </a-radio-group>
                </a-col>
                <a-col :span="12" v-if="checkValueType(item) === '[object Array]'">
                  <div v-for="(text,i) in item" :key="i" class="array-item">
                    <a-row :gutter="16">
                      <a-col :span="20">
                        <a-input v-model="docker[index][i]"></a-input>
                      </a-col>
                      <a-col :span="4">
                        <delete-array-item @delete="onDeleteValue(index,i)" />
                      </a-col>
                    </a-row>
                    <a-divider />
                  </div>
                  <div class="add-value">
                    <a-icon
                      class="dynamic-plus-button"
                      type="plus"
                      :style="{ color: '#1890ff' }"
                      @click="onCreateArrayString(index)"
                    />
                  </div>
                </a-col>
              </a-row>
            </div>
          </div>
        </div>
      </div>
    </a-modal>
  </div>
</template>

<script>
import _ from "lodash";
import DeleteArrayItem from "@/components/CreatItemModal/DeleteArrayItem.vue";
import EditableCell from "@/components/EditableCell/EditableCell";
export default {
  name: "ServiceDockerConfigModal",
  props: {
    visible: Boolean,
    dataSource: Object
  },
  components: {
    DeleteArrayItem
  },
  data() {
    return {
      docker: {}
    };
  },
  methods: {
    initData() {
      const data = _.cloneDeep(this.dataSource);
      _.forEach(data, (val, key) => {
        this.$set(this.docker, key, val);
      });
    },
    checkValueType(obj) {
      const type = Object.prototype.toString.call(obj);
      return type;
    },
    onCreateArrayString(index) {
      this.docker[index] = [...this.docker[index], ""];
    },
    onDeleteValue(index, i) {
      this.docker[index].splice(i, 1);
    },
    onCellChange(index, val) {
      this.docker[index] = val;
    },
    onArrayStringChange(index, i, val) {
      this.docker[index][i] = val;
    },
    handleOk() {
      this.$emit("changeDocker", { item: this.docker });
    }
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.docker = {};
        this.initData();
      }
    }
  }
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
.array-item .ant-divider-horizontal {
  margin: 4px 0;
  height: 2px;
}
</style>
