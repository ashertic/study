import Vue from 'vue';
import Antd from 'ant-design-vue';
import App from './App.vue';
import router from './router';
import store from './store';
import 'ant-design-vue/dist/antd.less';
import './utils/filter'
import VueJsonPretty from 'vue-json-pretty'
import 'vue-json-pretty/lib/styles.css';

Vue.config.productionTip = false;

Vue.use(Antd);
Vue.component("vue-json-pretty", VueJsonPretty)

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount('#app');
