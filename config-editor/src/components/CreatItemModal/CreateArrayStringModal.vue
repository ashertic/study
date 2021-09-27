<template>
  <div>
    <a-icon
      class="dynamic-plus-button"
      type="plus"
      :style="{ color: '#1890ff' }"
      @click="() => $emit('show')"
    />
    <a-modal
      :destroyOnClose="true"
      :visible="visible"
      :closable="false"
      :centered="true"
      :maskClosable="false"
      @cancel="() => $emit('cancel')"
      @ok="() => $emit('addValue',{val:content,key:objKey})"
    >
      <a-input v-model="content"></a-input>
    </a-modal>
  </div>
</template>

<script>
export default {
  name: "CreateArrayStringModal",
  props: {
    visible: Boolean,
    objKey: String
  },
  data() {
    return {
      content: ""
    };
  },
  methods: {},
  watch: {
    visible(newVal) {
      if (newVal) {
        this.content = "";
      }
    }
  }
};
</script>

<style>
.dynamic-plus-button {
  cursor: pointer;
  position: relative;
  top: 4px;
  font-size: 16px;
  color: #1890ff;
  transition: all 0.3s;
}
</style>