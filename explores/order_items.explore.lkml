include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/crossviews/order_items_crossview.view.lkml"
explore: order_items {
  join: inventory_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
  join: order_items_crossview {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
}
}
