import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import About from '../views/About.vue'
import Home from '../views/Home.vue'
import What from '../views/What.vue'
import Lang from '../views/Lang.vue'
import Faq from '../views/Faq.vue'
import Go from '../views/Go.vue'

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/:lang',
    name: 'Lang',
    component: Lang,
    children: [
      {
        path: 'what',
        name: 'What',
        component: What
      },
      {
        path: 'go',
        name: 'Go',
        component: Go
      },
      {
        path: 'faq',
        name: 'Faq',
        component: Faq
      },
      {
        path: 'about',
        name: 'About',
        component: About
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
