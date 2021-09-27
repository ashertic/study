<template>
  <div>
    <a-popconfirm
      title="确认删除该项?"
      ok-text="Yes"
      cancel-text="No"
      @confirm="confirm"
      @cancel="cancel"
    >
      <a>delete</a>
    </a-popconfirm>
  </div>
</template>

<script>
export default {
  name: "DeleteArrayItem",
  props: {},
  methods: {
    confirm(e) {
      this.$emit("delete");
    },
    cancel(e) {}
  }
};
</script>

<style>
.dynamic-delete-button {
  cursor: pointer;
  position: relative;
  top: 4px;
  font-size: 12px;
  color: #999;
  transition: all 0.3s;
}
</style>