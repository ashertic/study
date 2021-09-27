<template>
  <div id="home">
    <a-button type="primary" size="large" class="btn" @click="create('k8s')">
      创建新的K8S部署的JSON配置
    </a-button>
    <a-button type="primary" size="large" class="btn"  style="margin-left:50px;" @click="create('docker')">
      创建新的Docker部署的JSON配置
    </a-button>
    <a-button type="default" size="large" class="btn" style="margin-left:50px;" @click="edit">
      编辑已有JSON配置
    </a-button>
  </div>
</template>

<script>
export default {
  methods: {
    create(configType) {
      console.log(configType)
      this.$router.push({ name: 'Create', params: { 'configtype' : configType }})
    },
    edit(event) {
      this.$router.push('Edit')
    }
  }
};
</script>

<style scoped>
#home {
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
}

#home .btn {
  height: 80px;
  width: 300px;
  font-size: larger;
}
</style>
