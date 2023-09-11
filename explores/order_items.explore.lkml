include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
# include: “/views/derived/dt_monthly_sales.view.lkml”
explore: order_items {
  persist_with: order_items_dg
  join: inventory_items {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
  join: x_order_items_inventory_items {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
}

}

explore: +order_items {
  aggregate_table: sales_yearly {
    query: {
      dimensions: [created_year]
      measures: [total_sale_price]
    }
    materialization: {
      datagroup_trigger: order_items_dg
      increment_key: "created_year"
      increment_offset: 7
    }
  }
  }
