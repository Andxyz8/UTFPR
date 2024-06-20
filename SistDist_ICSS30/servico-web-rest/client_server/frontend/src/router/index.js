import Vue from "vue";
import VueRouter from "vue-router";
import Livros from '../components/Livros.vue'


Vue.use(VueRouter);

const routes = [
 {
  path : '/livros',
  name : 'Livros',
  component : Livros,
}
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
