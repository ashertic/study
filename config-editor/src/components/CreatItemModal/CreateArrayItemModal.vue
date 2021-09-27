<template>
  <div>
    <a-button type="primary" class="editable-add-btn" @click="() => $emit('show')">添加</a-button>
    <a-modal
      :destroyOnClose="true"
      :visible="visible"
      :closable="false"
      :centered="true"
      :maskClosable="false"
      @cancel="() => $emit('cancel')"
      @ok="onCreateItem"
    >
      <div v-for="(key,index) in noTypekeys" :key="index" class="items">
        {{key.title | required(type)}} :
        <a-input v-model="content[key.title]" v-if="key.type==='String'"></a-input>

        <a-input type="number" v-model="content[key.title]" v-else-if="key.type==='Number'"></a-input>

        <a-radio-group v-else-if="key.type==='Boolean'" v-model="content[key.title]">
          <a-radio :value="true">true</a-radio>
          <a-radio :value="false">false</a-radio>
        </a-radio-group>

        <div v-else-if="key.type==='Array'">
          <a-row :gutter="16">
            <a-col :span="1">
              <create-array-string-Modal
                :visible="addValueModalVisible"
                :objKey="key.title"
                @show="onShowAddValueModal"
                @cancel="onAddValueModalCancel"
                @addValue="onAddValue"
              />
            </a-col>
            <a-col :span="22">
              <div v-for="(value,index) in content[key.title]" :key="index">
                <a-row :gutter="8">
                  <a-col :span="21">
                    <a-input v-model="content[key.title][index]" />
                  </a-col>
                  <a-col :span="3" v-if="content[key.title].length>1">
                    <delete-array-item @delete="onDeleteValue(index,key.title)" />
                  </a-col>
                </a-row>
              </div>
            </a-col>
          </a-row>
        </div>
      </div>
    </a-modal>
  </div>
</template>

<script>
import _ from "lodash";
import CreateArrayStringModal from "@/components/CreatItemModal/CreateArrayStringModal.vue";
import DeleteArrayItem from "@/components/CreatItemModal/DeleteArrayItem.vue";
export default {
  name: "CreateArrayItemModal",
  props: {
    visible: Boolean,
    keys: Array
  },
  components: { CreateArrayStringModal, DeleteArrayItem },
  data() {
    return {
      content: {},
      addValueModalVisible: false,
      type: ""
    };
  },
  computed: {
    noTypekeys() {
      return _.filter(this.keys, key => !_.has(key, "__type__"));
    }
  },
  methods: {
    initData() {
      let value = "";
      _.forEach(this.keys, key => {
        if (_.has(key, "__type__")) {
          this.type = key.__type__;
        }
        if (!_.has(key, "__type__")) {
          if (key.type === "Boolean") {
            value = true;
          } else if (key.type === "Array") value = [""];
          this.$set(this.content, key.title, value);
        }
      });
    },
    onShowAddValueModal() {
      this.addValueModalVisible = true;
    },
    onAddValue({ val, key }) {
      this.content[key] = [...this.content[key], val];
      this.addValueModalVisible = false;
    },
    onAddValueModalCancel() {
      this.addValueModalVisible = false;
    },
    onDeleteValue(index, key) {
      this.content[key].splice(index, 1);
    },
    onCreateItem() {
      _.forEach(this.keys, key => {
        if (key.type === "Number") {
          this.content[key.title] = parseInt(this.content[key.title]);
        }
        if (_.has(key, "__type__")) {
          this.content.__type__ = key.__type__;
        }
      });
      this.$emit("create", this.content);
    }
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.content = {};
        this.type = "";
        this.initData();
      }
    }
  }
};
</script>

<style>
.editable-add-btn {
  margin-bottom: 8px;
}

.items {
  margin-top: 16px;
}
</style>