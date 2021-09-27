<template>
  <div id="create">
    <ConfigSection title="全局上下文配置(必须)" :json="contextJson">
      <ContextEditor />
    </ConfigSection>
    <ConfigSection title="Docker上下文配置(K8S必须,Docker方式部分必须)" :json="dockerContextJson">
      <DockerContextEditor />
    </ConfigSection>
    <ConfigSection title="K8S相关上下文配置（可选，K8S部署方式才需要本配置）" :json="k8sContextJson" >
      <K8sContextEditor />
    </ConfigSection>
    <ConfigSection title="服务配置(必须)" :json="serviceContextJson">
      <ServiceContextEditor/>
    </ConfigSection>
    <ConfigSection title="DB初始化配置（可选）" :json="dbInitializersJson">
      <DbInitializerEditor />
    </ConfigSection>
    <ConfigSection title="独立的Nginx代理配置（可选，当客服需要使用域名方式访问服务时，需要本配置）" :json="nginxContextJson">
      <NginxContextEditor />
    </ConfigSection>
    <ConfigSection title="DB备份和恢复配置（可选）" :json="dbBackupAndRestoreContextJson">
      <DbBackupAndRestoreContextEditor />
    </ConfigSection>
  </div>
</template>

<script>

import ConfigSection from "@/components/ConfigSection.vue";
import ContextEditor from "@/components/ContextEditor.vue";
import DockerContextEditor from "@/components/DockerContextEditor.vue"
import K8sContextEditor from "@/components/K8sContextEditor.vue"
import DbBackupAndRestoreContextEditor from "@/components/DbBackupAndRestoreContextEditor.vue"
import DbInitializerEditor from "@/components/DbInitializerEditor.vue"
import NginxContextEditor from "@/components/NginxContextEditor.vue"
import ServiceContextEditor from "@/components/ServiceContextEditor.vue"


export default {
  components: {
    ConfigSection,
    ContextEditor,
    DockerContextEditor,
    K8sContextEditor,
    DbBackupAndRestoreContextEditor,
    DbInitializerEditor,
    NginxContextEditor,
    ServiceContextEditor
  },
  data() {
    return {
      configType: this.$route.params.configtype,

    };
  },
  methods: {
    // create(event) {
    //   this.$router.push('select')
    // },
    // edit(event) {
    //   this.$router.push('select')
    // }
  },
  computed: {
    contextJson() {
      return {
        "context" : this.$store.state.context
      }
    },
    dockerContextJson() {
      return {
        "dockerContext" : this.$store.state.dockerContext
      }
    },
    k8sContextJson() {
      return {
        "k8sContext" : this.$store.state.k8sContext
      }
    },
    dbBackupAndRestoreContextJson() {
      return {
        "dbBackupAndRestoreContext": this.$store.state.dbBackupAndRestoreContext
      }
    },
    dbInitializersJson() {
      return {
        "dbInitializers": this.$store.state.dbInitializers
      }
    },
    nginxContextJson() {
      return {
        "nginxContext": this.$store.state.nginxContext
      }
    },
    serviceContextJson() {
      return {
        "services": this.$store.state.services
      }
    }
  },
  mounted() {
    this.$store.commit("setMode", this.$route.params.configtype)
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
  width: 240px;
  font-size: larger;
}
</style>
