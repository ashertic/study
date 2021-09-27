import Vue from 'vue'

import {
  required
} from './required'

Vue.filter('required', function (name, type) {
  return required(name, type)
})
