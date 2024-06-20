import Vue from "vue";
import VueRouter from "vue-router";
import Games from '../components/Games.vue'
import Livros from '../components/Livros.vue'


Vue.use(VueRouter);

const routes = [
 {
   path : '/games',
   name : 'Games',
   component : Games,
 },
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
