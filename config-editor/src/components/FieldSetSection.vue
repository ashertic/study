<template>
  <div class="fs-section">
    <a-card :title="title" style="width:100%;">
      <a-button-group slot="extra">
        <a-button @click="changeState">{{ isCollapsed ? '展开': '收起' }}</a-button>
        <a-button type="danger" @click="remove">
          删除
        </a-button>
      </a-button-group>
      <div v-if="!isCollapsed">
        <slot/>
      </div>
    </a-card>
  </div>
</template>

<script>
export default {
  props: {
    title: String
  },
  data() {
    return {
      isCollapsed: false,
    };
  },
  methods: {
    changeState(event) {
      this.isCollapsed = !this.isCollapsed
    },
    remove(event) {
      this.$emit("remove");
    }
  }
};
</script>

<style scoped>
.fs-section {
  width: 100%;
  padding: 20px 20px;
}
</style>
