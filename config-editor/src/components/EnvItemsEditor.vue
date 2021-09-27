<template>
  <div class="envs">
    <div v-for="(item, index) in initialValues" :key="index" class="env-item">
      <a-input placeholder="填写环境变量名和值" :value="item" :readOnly="!isEditing"/>
      <a-icon v-if="isEditing" class="env-item-del" type="delete" @click="remove(index)" />
    </div>
    <div v-if="isEditing" style="margin-top: 10px;">
      <a-button type="primary" block @click="add">
        增加新的环境变量配置
      </a-button>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    initialValues: Array,
    isEditing: Boolean
  },
  data() {
    return {
      // value: this.initialValues,
    };
  },
  computed: {
  },
  methods: {
    remove(index) {
      this.$emit("remove", index)
    },
    add() {
      this.$emit("add");
    }
  }
};
</script>

<style scoped>
.envs {
  border: solid 1px #d5dbdc;
  padding: 0px 10px 10px 10px;
}
.env-item {
  margin-top: 10px;
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
