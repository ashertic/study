<template>
  <div class="content">
    <a-select
      style="width:100%"
      :disabled="!isEditing"
      :value="value"
      @change="selectChange">
      <a-select-option v-for="(item,index) in choices" :value="item" :key="index">
        {{item}}
      </a-select-option>
    </a-select>
  </div>
</template>
<script>
import _ from "lodash"

export default {
  props: {
    isEditing: Boolean,
    content: String,
    choices: Array
  },
  data() {
    return {
      value: this.content
    };
  },
  methods: {
    selectChange(value) {
      this.value = value
    },
    save() {
      this.$emit("save", this.value);
    },
    cancel() {
      this.value = this.content
    },
  }
};
</script>

<style scoped>
.content {
  width: 100%;
  padding-left: 5px;
  padding-right: 5px;
}
</style>
