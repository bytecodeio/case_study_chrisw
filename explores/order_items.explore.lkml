include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
explore: order_items {
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
