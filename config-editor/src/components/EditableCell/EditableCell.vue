<template>
  <div class="editable-cell">
    <div v-if="editable" class="editable-cell-input-wrapper">
      <a-row>
        <a-col :span="20">
          <a-input :value="value" @change="handleChange" @pressEnter="check" />
        </a-col>
        <a-col :span="1">
          <a-icon type="check" class="editable-cell-icon-check" @click="check" />
        </a-col>
      </a-row>
    </div>
    <div v-else class="editable-cell-text-wrapper">
      {{ value || ' ' }}
      <a-icon type="edit" class="editable-cell-icon" @click="edit" />
    </div>
  </div>
</template>
<script>
export default {
  props: {
    text: String
  },
  data() {
    return {
      value: this.text,
      editable: false
    };
  },
  methods: {
    handleChange(e) {
      const value = e.target.value;
      this.value = value;
    },
    check() {
      this.editable = false;
      this.$emit("change", this.value);
    },
    edit() {
      this.editable = true;
    }
  },
  watch: {
    text(newVal) {
      this.value = this.text;
    }
  }
};
</script>

<style>
.editable-cell-text-wrapper {
  text-align: left;
}

.editable-cell-icon-check {
  margin-top: 9px;
}
</style>
