<template>
  <div class="hello">
    <input id="inputBox" type="file" @change="getFile" value="选择配置文件" />
  </div>
</template>

<script>
export default {
  methods: {
    getFile(event) {
      let file = document.getElementById("inputBox").files[0];
      const { name } = file;
      if (name) {
        this.$store.commit("setFilename", name);
      } else {
        this.$store.commit("setFilename", "file");
      }
      const reader = new FileReader();
      const that = this;
      reader.onload = function() {
        const content = reader.result;
        that.$store.dispatch("setContent", content);
        that.$router.push("Edit2");
      };
      reader.readAsText(event.target.files[0], "utf-8");
    }
  }
};
</script>

<style scoped></style>
