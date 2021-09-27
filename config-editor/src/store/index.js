import Vue from "vue";
import Vuex from "vuex";
import _ from 'lodash'
Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    content: null,
    filename: '',
    mode: null,
    context: null,
    dockerContext: null,
    k8sContext: null,
    dbInitializers: null,
    dbBackupAndRestoreContext: null,
    nginxContext: null,
    services: null,
  },
  mutations: {
    setContext(state, value) {
      state.context = value
    },
    setDockerContext(state, value) {
      state.dockerContext = value
    },
    setK8sContext(state, value) {
      state.k8sContext = value
    },
    setDbBackupAndRestoreContext(state, value) {
      state.dbBackupAndRestoreContext = value
    },
    setDbInitializers(state, value) {
      state.dbInitializers = value
    },
    setNginxContext(state, value) {
      state.nginxContext = value
    },
    setServices(state, value) {
      state.services = value
    },
    setFilename(state, name) {
      state.filename = name
    },
    loadConfigFromFile(state, config) {
      state.context = config["context"]
      state.dockerContext = config["dockerContext"]
      state.k8sContext = config["k8sContext"]
      state.dbInitializers = config["dbInitializers"]
      state.dbBackupAndRestoreContext = config["dbBackupAndRestoreContext"]
      state.nginxContext = config["nginxContext"]
      state.services = config["services"]
    },
    setMode(state, value) {
      state.mode = value
    },



    setContent(state, value) {
      let jsonObj = JSON.parse(value);
      state.content = jsonObj;
    },


    changeContent(state, options) {
      const {
        contentKey,
        key,
        val
      } = options
      state.content[contentKey][key] = val
    },
    addContentItem(state, options) {
      const {
        contentKey,
        key,
        val
      } = options
      state.content[contentKey][key].push(val)
    },
    // setDbInitializers(state, options) {
    //   const {
    //     key,
    //     val,
    //     index
    //   } = options
    //   state.content.dbInitializers[index][key] = val
    // },
    // addDbInitializers(state, item) {
    //   state.content.dbInitializers = [...state.content.dbInitializers, item]
    // },
    // addDbInitializersByIndex(state, options) {
    //   const {
    //     key,
    //     val,
    //     index
    //   } = options
    //   state.content.dbInitializers[index][key].push(val)
    // },
    // delDbInitializersByIndex(state, index) {
    //   state.content.dbInitializers.splice(index, 1)
    // },
    // setServices(state, val) {
    //   state.content.services = val
    // }

  },
  actions: {
    setContent(context, value) {
      context.commit("setContent", value);
    },
    loadConfigFromFile(context, config) {
      context.commit("loadConfigFromFile", config);
    },
  },
  modules: {}
});
