<template>
  <div class="field">
    <div class="label-box">
      <a-tooltip placement="topRight">
        <template slot="title">
          <span>{{field.desc}}</span>
        </template>
        <div class="label-value">{{field.label}}</div>
      </a-tooltip>
    </div>
    <div class="content-box">
      <TextField v-if="field.contentType == 'text'" 
        :content="value" 
        :isEditing="isEditing" 
        @save="childSave" 
        ref="child" />
      <EnvField v-if="field.contentType == 'array'"
        :content="value" 
        :isEditing="isEditing" 
        @save="childSave"
        ref="child" />
      <SelectField v-if="field.contentType == 'select'"
        :content="value" 
        :choices="field.choices" 
        :isEditing="isEditing" 
        @save="childSave"
        ref="child" />
    </div>
    <div class="action-box">
      <div class="readonly-action" v-if="!isEditing">
        <a-tooltip placement="topRight" v-if="field.isRequired">
          <template slot="title">
            <span>必须要填写的字段</span>
          </template>
          <a-icon type="star" theme="filled" class="action-icon" style="color:red;" />
        </a-tooltip>
        <a-tooltip placement="topRight">
          <template slot="title">
            <span>点击修改本字段</span>
          </template>
          <a-icon type="edit" theme="filled" class="action-icon" style="color: #34a5dc;" @click="edit" />
        </a-tooltip>
      </div>
      <div class="edit-action" v-else>
        <a-icon type="close-circle" theme="filled" class="action-icon" style="color: rgb(234 63 22);" @click="cancel" />
        <a-icon type="check-circle" theme="filled" class="action-icon" style="color: rgb(135 218 101);" @click="save" />
        <a-icon type="delete" v-if="field.canDelete" theme="filled" class="action-icon" style="color: rgb(59 56 55);" @click="remove" />
      </div>
    </div>
  </div>
</template>
<script>
import SelectField from "@/components/FieldEditor/SelectField.vue";
import TextField from "@/components/FieldEditor/TextField.vue";
import EnvField from "@/components/FieldEditor/EnvField.vue";
import _ from 'lodash'

export default {
  props: {
    field: Object
  },
  components: { 
    SelectField,
    TextField,
    EnvField
  },
  data() {
    return {
      isEditing: false,
      value: this.field.value
    };
  },
  methods: {
    edit() {
      this.isEditing = true
    },
    save() {
      this.isEditing = false
      this.$refs.child.save()
    },
    cancel() {      
      this.isEditing = false
      this.$refs.child.cancel()
    },
    remove() {
      this.isEditing = false
      console.log('remove this field')
      this.$emit('remove')
    },
    childSave(childValue) {
      this.isEditing = false
      this.value = childValue
      this.$emit('save', this.value)
    }
  },
  created() {
    if (this.field.contentType === undefined || this.field.contentType === null) {
      this.field.contentType = 'text'
    }
    if (this.field.isRequired === undefined || this.field.isRequired === null) {
      this.field.isRequired = true
    }
    if (this.field.canDelete === undefined || this.field.canDelete === null) {
      this.field.canDelete = false
    }
  }
};
</script>

<style scoped>
.field {
  width: 100%;
  padding-top: 5px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: flex-start;
  background-color: #f0faff;
  margin-bottom: 5px;
}

.label-box .label-value {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-right: 10px;
  width: 150px;
  text-align: right;
  color: black;
}

.content-box {
  flex-grow: 1;
}
.action-box {
  width: 104px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-start;
  padding-top: 4px;
}

.action-icon {
  font-size: 24px;
  padding-left: 5px;
  padding-right: 5px;
}
</style>
