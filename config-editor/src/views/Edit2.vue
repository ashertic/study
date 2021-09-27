<template>
  <div class="about">
    <a-tabs defaultActiveKey="1" @change="callback">
      <a-tab-pane tab="*context" key="1" v-if="haveData('context')">
        <context />
      </a-tab-pane>
      <a-tab-pane tab="*services" key="2" v-if="haveData('services')">
        <services />
      </a-tab-pane>
      <a-tab-pane tab="dbInitializers" key="3" v-if="haveData('dbInitializers')">
        <dbInitializers />
      </a-tab-pane>
      <a-tab-pane tab="*dockerContext" key="4" v-if="haveData('dockerContext')">
        <docker-context />
      </a-tab-pane>
      <a-tab-pane tab="k8sContext" key="5" v-if="haveData('k8sContext')">
        <k8s-context />
      </a-tab-pane>
      <a-tab-pane tab="nginxContext" key="6" v-if="haveData('nginxContext')">
        <nginx-context />
      </a-tab-pane>
      <a-tab-pane
        tab="dbBackupAndRestoreContext"
        key="7"
        v-if="haveData('dbBackupAndRestoreContext')"
      >
        <db-backup-and-restore-context />
      </a-tab-pane>
      <a-tab-pane tab="导出" key="8">
        <a-button type="primary" @click="onImportJsonFile">导出</a-button>
      </a-tab-pane>
    </a-tabs>
  </div>
</template>

<script>
import _ from "lodash";
import Context from "@/components/Context.vue";
import Services from "@/components/Services.vue";
import DockerContext from "@/components/DockerContext.vue";
import K8sContext from "@/components/K8sContext.vue";
import NginxContext from "@/components/NginxContext.vue";
import DbBackupAndRestoreContext from "@/components/DbBackupAndRestoreContext.vue";
import DbInitializers from "@/components/DbInitializers.vue";

export default {
  computed: {
    content() {
      return JSON.stringify(this.$store.state.content);
    }
  },
  components: {
    Context,
    Services,
    DockerContext,
    K8sContext,
    NginxContext,
    DbBackupAndRestoreContext,
    DbInitializers
  },
  methods: {
    callback(key) {
      console.log(key);
    },
    haveData(key) {
      if (this.$store.state.content && this.$store.state.content[key]) {
        return true;
      }
      return false;
    },
    onImportJsonFile() {
      const blob = new Blob([this.content], { type: "text/json" });
      const name = this.$store.state.filename;
      this.download(blob, name);
    },
    download(blob, filename) {
      const a = document.createElement("a");
      var url = URL.createObjectURL(blob);
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      setTimeout(function() {
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
      }, 0);
    }
  },
  mounted() {
    if (!this.$store.state.content) {
      this.$router.push({ name: "SelectConfigFile" });
    }
  }
};
</script>
