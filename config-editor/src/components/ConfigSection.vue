<template>
  <div class="config-section">
    <a-card :title="title" style="width:100%;">
      <a slot="extra" @click="changeState">{{ isCollapsed ? '展开': '收起' }}</a>
      <div v-if="!isCollapsed" class="content">
        <div class="editor">
          <slot/>
        </div>
        <div class="json">
          <vue-json-pretty :data="json"></vue-json-pretty>
        </div>
      </div>
    </a-card>
  </div>
</template>

<script>


export default {
  props: {
    title: String,
    json: Object
  },
  data() {
    return {
      isCollapsed: false,
    };
  },
  methods: {
    changeState(event) {
      this.isCollapsed = !this.isCollapsed
    }
  },
};
</script>

<style scoped>
.config-section {
  width: 100%;
  padding: 20px 20px;
}

.config-section .content {
  display: flex;
  flex-direction: row;
}

.config-section .content .editor {
  width: 50%;
  padding-right: 10px;
}

.config-section .content .json {
  width: 50%;
  border: solid 1px #d1dae0;
  text-align: left;
  padding-left: 10px;
}
</style>
