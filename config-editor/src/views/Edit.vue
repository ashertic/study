<template>
  <div id="edit">
    <a-card style="padding: 30px;" >
      <a-upload name="file" :customRequest="customRequest" >
        <a-button><a-icon type="upload" />上传JSON配置文件</a-button>
      </a-upload>
    </a-card>
  </div>
</template>

<script>
export default {
  methods: {
    customRequest(info) {
      const { name } = info.file;
      if (name) {
        this.$store.commit("setFilename", name);
      } else {
        this.$store.commit("setFilename", "config.json");
      }

      const reader = new FileReader();
      const that = this;
      reader.onload = function() {
        const content = reader.result;
        let jsonObj = JSON.parse(content)
        that.$store.dispatch("loadConfigFromFile", jsonObj);
        that.$router.push({ name: 'Create', params: { 'configtype' : jsonObj["context"]["mode"] }})
        info.onSuccess('done')
      };
      reader.readAsText(info.file, "utf-8");
    }
  }
};
</script>

<style scoped>
#edit {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
}
</style>
