<template>
  <div class="content">
    <a-textarea 
      :value="value" 
      :autoSize="textAutosize" 
      :readOnly="!isEditing" 
      @change="change" 
      @pressEnter="save" />
  </div>
</template>
<script>
import _ from "lodash"

export default {
  props: {
    isEditing: Boolean,
    content: String,
  },
  data() {
    return {
      value: this.content,
      textAutosize: {
        'minRows': 1,
        'maxRows': 4
      }
    };
  },
  methods: {
    change(e) {
      this.value = e.target.value;
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
