<template>
  <div id="test">
    <FieldEditor v-for="(item, index) in fields" 
      :key="item.uniqueId" 
      :field="item" 
      @save="saveField(index, $event)" 
      @remove="removeField(index)"/>
  </div>
</template>

<script>

import FieldEditor from "@/components/FieldEditor";
import _ from 'lodash'

export default {
  components: {
    FieldEditor,
  },
  data() {
    return {
      fields: [
        {
          uniqueId: _.uniqueId(),
          value: '123',
          label: '今天天气真的很好没有下雨可以放风筝',
          desc: '描述标签 的描述'
        },
        {
          uniqueId: _.uniqueId(),
          contentType: "array",
          isRequired: false,
          value: ['env1', 'env2'],
          label: '今天天气真的很好没有下雨可以放风筝今天天气真的很好没有下雨可以放风筝',
          desc: '描述标签 的描述描述标签 的描述描述标签 的描述描述标签 的描述描述标签 的描述'
        },
        {
          uniqueId: _.uniqueId(),
          contentType: "select",
          canDelete: true,
          choices: ['true', 'false', 'env', 'ran'],
          value: 'true',
          label: '风筝',
          desc: '描述标签 的描述描述标签 的描述描述标签 的描述描述标签 的描述描述标签 的描述'
        }
      ]
    };
  },
  methods: {
    saveField(index, value) {
      console.log('save field value')
      console.log(JSON.stringify(this.fields[index]))
      this.fields[index].value = value
      console.log(JSON.stringify(this.fields[index]))
    },
    removeField(index) {
      console.log(`remove field ${index} in test view`)
      this.fields.splice(index, 1)
    }
  }
};
</script>

<style scoped>
#test {
  height: 100%;
  width: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
}
</style>
