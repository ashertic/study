<template>
  <div class="content" :style="styleObj">
    <div v-for="(item, index) in values" :key="index" class="env-items" >
      <a-input placeholder="填写环境变量名和值" :value="item" :readOnly="!isEditing" @change="changeItem($event, index)" />
      <a-icon v-if="isEditing" class="env-item-del" type="delete" @click="removeItem($event, index)" />
    </div>
    <div v-if="isEditing" style="margin: 0px 0px 10px 0px;padding: 0px 20px;">
      <a-button type="primary" block @click="addItem">
        增加
      </a-button>
    </div>
  </div>
</template>
<script>
import _ from "lodash"

export default {
  props: {
    isEditing: Boolean,
    content: Array,
  },
  data() {
    return {
      values: _.cloneDeep(this.content),
      styleObj: {}
    };
  },
  watch: {
    isEditing(newValue, oldValue) {
      if (newValue) {
        this.styleObj = {
          "background-color": "#d8dbe0",
          "padding-top": "5px",
          "padding-left": "5px",
          "padding-right": "5px"
        }
      }
      else {
        this.styleObj = {
          "background-color": "initial",
          "padding-top": "initial",
          "padding-left": "5px",
          "padding-right": "10px"
        }
      }
    }
  },
  methods: {
    changeItem(event, index) {
      this.values.splice(index, 1, event.target.value)
    },
    removeItem(event, index) {
      this.values.splice(index, 1)
    },
    addItem() {
      this.values.push("")
    },
    save() {
      this.$emit("save", _.cloneDeep(this.values));
    },
    cancel() {
      this.values = _.cloneDeep(this.content)
    }
  }
};
</script>

<style scoped>
.content {
  width: 100%;
  display: flex;
  flex-direction:column;
}
.env-items {
  margin-bottom: 10px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  
}
.env-item-del {
  padding-left: 10px;
  font-size: 20px;
  color: red;
}
</style>
