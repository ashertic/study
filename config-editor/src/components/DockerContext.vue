<template>
  <div class="container">
    <div class="content">
      <div v-for="(item,index) in dockerContext" :key="index">
        <a-row class="row" v-if="index!=='__type__'" :gutter="16">
          <!--  item:val index:key -->
          <a-col :span="10" class="right">
            <span class="label">{{ index | required(dockerContext.__type__) }}</span>
          </a-col>
          <a-col :span="12" class="col-value">
            <editable-cell :text="item" @change="onCellChange(index, $event)" />
          </a-col>
        </a-row>
      </div>
    </div>
  </div>
</template>

<script>
import EditableCell from "@/components/EditableCell/EditableCell";
export default {
  components: { EditableCell },
  data() {
    return {};
  },
  methods: {
    onCellChange(index, val) {
      const options = { contentKey: "dockerContext", key: index, val };
      this.$store.commit("changeContent", options);
    }
  },
  computed: {
    dockerContext() {
      if (this.$store.state.content.dockerContext) {
        return this.$store.state.content.dockerContext;
      } else {
        return {};
      }
    }
  }
};
</script>

<style lang="less" scoped>
.container {
  width: 100%;
  display: flex;
  justify-content: center;
  // justify-items: center;
}
.content {
  width: 80%;
}
.row {
  margin: 36px;
}
.right {
  text-align: right;
}
.label {
  padding-right: 15px;
  color: blue;
  font-weight: bolder;
}
</style>