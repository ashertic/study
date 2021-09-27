<template>
  <div class="editable">
    <a-table :columns="columns" :dataSource="data" rowKey="key">
      <template v-for="col in columns" :slot="col.title" slot-scope="text, record">
        <div :key="col.title" v-if="col.type!=='Boolean'">
          <a-input
            v-if="record.editable"
            style="margin: -5px 0"
            :value="text"
            @change="e => handleChange(e.target.value, record, col)"
          />
          <template v-else>{{ text }}</template>
        </div>
        <div :key="col.title" v-else-if="col.type==='Boolean'">
          <a-radio-group
            :defaultValue="text"
            v-if="record.editable"
            @change="e => handleRadioChange(e.target.value, record, col.title)"
          >
            <a-radio :value="true">true</a-radio>
            <a-radio :value="false">false</a-radio>
          </a-radio-group>
          <template v-else>{{ text }}</template>
        </div>
      </template>

      <template slot="action" slot-scope="text, record">
        <a-row>
          <a-col :span="14">
            <div class="editable-row-operations">
              <span v-if="record.editable">
                <a @click="() => save(record)">Save</a>
                <a-popconfirm title="Sure to cancel?" @confirm="cancel">
                  <a>Cancel</a>
                </a-popconfirm>
              </span>
              <span v-else>
                <a :disabled="editingKey !== ''" @click="() => edit(record)">Edit</a>
              </span>
            </div>
          </a-col>
          <a-col :span="10">
            <a-popconfirm
              title="确认删除该项?"
              ok-text="Yes"
              cancel-text="No"
              @confirm="confirmDel(record)"
              @cancel="cancelDel"
            >
              <a>delete</a>
            </a-popconfirm>
          </a-col>
        </a-row>
      </template>
    </a-table>
  </div>
</template>

<script>
import _ from "lodash";
export default {
  name: "RenderArrayItemTable",
  props: {
    dataSource: Array,
    titles: Array
  },
  data() {
    return {
      columns: [],
      data: [],
      editingKey: ""
    };
  },
  components: {},
  computed: {},
  methods: {
    initcolumns() {
      _.forEach(this.titles, el => {
        if (!_.has(el, "__type__")) {
          const options = {
            title: el.title,
            type: el.type,
            dataIndex: el.title,
            key: el.title,
            scopedSlots: { customRender: el.title },
            ellipsis: true
          };
          this.columns = [...this.columns, options];
        }
      });
      const action = {
        title: "操作",
        key: "action",
        scopedSlots: { customRender: "action" }
      };
      this.columns = [...this.columns, action];
    },
    initData() {
      this.data = this.dataSource.map(item => ({ ...item }));
      for (let i in this.data) {
        this.data[i].key = i.toString();
        if (_.has(this.data[i], "editable")) delete this.data[i].editable;
      }
      this.editingKey = "";
    },
    findTarget(record) {
      const newData = [...this.data];
      const key = record.key;
      const target = newData.filter(item => item.key === key)[0];
      return { newData, key, target };
    },
    edit(record) {
      const { newData, key, target } = this.findTarget(record);
      this.editingKey = key;
      if (target) {
        target.editable = true;
        this.data = newData;
      }
    },
    cancel() {
      this.editingKey = "";
      this.initData();
    },
    save(record) {
      const { newData, target } = this.findTarget(record);
      delete target.editable;
      _.forEach(newData, el => {
        if (_.has(el, "key")) delete el.key;
      });
      this.$emit("change", newData);
      this.editingKey = "";
    },
    handleChange(text, record, column) {
      const { newData, target } = this.findTarget(record);
      if (target) {
        if (column.type === "Number") {
          target[column.title] = parseInt(text);
        } else {
          target[column.title] = text;
        }
        this.data = newData;
      }
    },
    confirmDel(record) {
      const { key, newData } = this.findTarget(record);
      newData.splice(parseInt(key), 1);
      _.forEach(newData, el => {
        if (el.key) delete el.key;
      });
      this.$emit("change", newData);
    },
    cancelDel() {},
    handleRadioChange(val, record, column) {
      const { newData, target } = this.findTarget(record);
      if (target) {
        if (!_.isBoolean(val)) {
          val = val === "false" ? false : true;
        }
        target[column] = val;
        this.data = newData;
      }
    }
  },
  watch: {
    dataSource() {
      this.initData();
    }
  },
  created() {
    this.initcolumns();
    this.initData();
  }
};
</script>

<style lang="less" scoped>
.editable-row-operations a {
  margin-right: 8px;
}

.editable-add-btn {
  margin-bottom: 8px;
}
</style>
