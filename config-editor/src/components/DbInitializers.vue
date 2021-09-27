<template>
  <div>
    <a-list item-layout="horizontal" :data-source="dbInitializers" size="large">
      <a-list-item slot="renderItem" slot-scope="item, index" class="dbInitializers-card">
        <a-row>
          <a-col>
            <dbInitializers-card :dbInitializer="item" :initializerIndex="index">
              <template slot="delete-button">
                <a-popconfirm
                  title="确认删除该项?"
                  ok-text="Yes"
                  cancel-text="No"
                  @confirm="onDeleteDbInitializer(index)"
                >
                  <a-button type="danger">删除</a-button>
                </a-popconfirm>
              </template>
            </dbInitializers-card>
          </a-col>
        </a-row>
      </a-list-item>
      <div slot="footer">
        <create-array-item-modal
          :keys="titles"
          :visible="createModalVisible"
          @show="onShowCreateModal"
          @cancel="onCancelCreateModal"
          @create=" onCreateArrayItem"
        />
      </div>
    </a-list>
  </div>
</template>

<script>
import DbInitializersCard from "@/components/DbInitializersCard.vue";
import CreateArrayItemModal from "@/components/CreatItemModal/CreateArrayItemModal.vue";
export default {
  components: { DbInitializersCard, CreateArrayItemModal },
  data() {
    return {
      createModalVisible: false
    };
  },
  methods: {
    onShowCreateModal() {
      this.createModalVisible = true;
    },
    onCancelCreateModal() {
      this.createModalVisible = false;
    },
    onCreateArrayItem(item) {
      this.$store.commit("addDbInitializers", item);
      this.createModalVisible = false;
    },
    onDeleteDbInitializer(index) {
      this.$store.commit("delDbInitializersByIndex", index);
    }
  },
  computed: {
    dbInitializers() {
      if (this.$store.state.content.dbInitializers) {
        return this.$store.state.content.dbInitializers;
      } else {
        return {};
      }
    },
    titles() {
      return [
        { __type__: "DatabaseInitializer" },
        { title: "name", type: "String" },
        { title: "imageCategory", type: "String" },
        { title: "srcImage", type: "String" },
        { title: "useHostNetwork", type: "Boolean" },
        { title: "envs", type: "Array" }
      ];
    }
  },
  watch: {}
};
</script>

<style lang="less" scoped>
.dbInitializers-card {
  justify-content: center;
}
</style>