import Vue from "vue";
import VueRouter from "vue-router";
import SelectConfigFile from "@/views/SelectConfigFile.vue";
import Edit2 from "@/views/Edit2.vue";
import Home from "@/views/Home.vue";
import Create from "@/views/Create.vue";
import Edit from "@/views/Edit.vue";
import Test from "@/views/Test.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home
  },
  {
    path: "/create/:configtype",
    name: "Create",
    component: Create
  },
  {
    path: "/edit",
    name: "Edit",
    component: Edit
  },
  {
    path: "/select",
    name: "SelectConfigFile",
    component: SelectConfigFile
  },
  {
    path: "/edit2",
    name: "Edit2",
    component: Edit2
  },
  {
    path: "/test",
    name: "Test",
    component: Test
  }
];

const router = new VueRouter({
  routes
});

export default router;
