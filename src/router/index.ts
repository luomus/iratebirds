import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import Home from '../views/Home.vue'
import What from '../views/What.vue'
import Go from '../views/Go.vue'
import Faq from '../views/Faq.vue'

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/:lang/what',
    name: 'What',
    component: What
  },
  {
    path: '/:lang/go',
    name: 'Go',
    component: Go
  },
  {
    path: '/:lang/faq',
    name: 'Faq',
    component: Faq
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
