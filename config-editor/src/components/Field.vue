<template>
  <div class="field">
    <div class="label">
      <a-tooltip placement="topRight">
        <template slot="title">
          <span>{{desc}}</span>
        </template>
        <div class="label-value" :style="emptyRequiredStyle">{{label}}</div>
      </a-tooltip>
    </div>
    <div class="value">
      <a-textarea v-if="contentType == null && choices == null" 
        :value="value" 
        :autoSize="textAutosize" 
        :readOnly="!isEditing" 
        @change="change" 
        @pressEnter="save" />

      <a-select v-if="contentType == null && choices != null" 
        :default-value="initialValue" 
        style="width:100%"
        :disabled="!isEditing"
        @change="selectChange">
        <a-select-option v-for="(item,index) in choices" :value="item" :key="index">
          {{item}}
        </a-select-option>
      </a-select>

      <div v-if="contentType == 'envs'">
        <EnvItemsEditor 
        :initialValues="value" 
        :isEditing="isEditing" 
        @add="handleAddEnv" 
        @remove="handleRemoveEnv" />
      </div>
    </div>
    <div class="state">
      <a-icon v-if="!isEditing" type="edit" theme="filled" class="editable-cell-icon" @click="edit" style="font-size: 24px; color: #34a5dc;" />
      <a-icon v-else type="save" theme="filled" class="editable-cell-icon-check" @click="save" style="font-size: 24px; color: rgb(135 218 101);" />
    </div>
  </div>
</template>
<script>
import EnvItemsEditor from "@/components/EnvItemsEditor.vue";
import _ from "lodash"

export default {
  props: {
    label: String,
    desc: String,
    isRequired: Boolean,
    initialValue: [ String, Array ],
    choices: Array,
    contentType: String
  },
  components: { 
    EnvItemsEditor,
  },
  data() {
    return {
      value: _.cloneDeep(this.initialValue),
      isEditing: false,
      textAutosize: {
        'minRows': 1,
        'maxRows': 4
      }
    };
  },
  computed: {
    // contentLength() {
    //   if (this.value == null) {
    //     return 0
    //   }
    //   else {
    //     return this.value.length
    //   }
    // },
    emptyRequiredStyle() {
      if(this.isRequired && (this.value == null || this.value.length == 0)) {
        return {
          "color": "red"
        }
      } else {
        return {
          "color": "black"
        }
      }
    }
  },
  methods: {
    change(e) {
      this.value = e.target.value;
    },
    selectChange(value) {
      this.value = value
    },
    save() {
      this.isEditing = false;
      this.$emit("save", this.value);
    },
    edit() {
      this.isEditing = true;
    },
    handleAddEnv() {
      this.value.push("")
    },
    handleRemoveEnv(index) {
      console.log("field remove env " + index)
      this.value.splice(index, 1)
    }
  }
};
</script>

<style scoped>
.field {
  width: 100%;
  padding: 10px 20px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-start;
}

.field > .label {
  display: inline-block;
  padding: 0px;
}

.field .label-value {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-right: 10px;
  /* border: solid 1px red; */
  width: 150px;
  text-align: right;
  color: black;
}

.field > .value {
  display: inline-block;
  /* border: solid 1px red; */
  padding: 2px 0px;
  min-width: 300px;
  flex-grow: 1;
  /* text-align: left; */
}

.field > .state {
  display: inline-block;
  /* border: solid 1px red; */
  padding: 2px 10px;
}
</style>
