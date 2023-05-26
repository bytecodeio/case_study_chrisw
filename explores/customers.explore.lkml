include: "/views/users.view.lkml"
include: "/views/crossviews/x_users_order_items.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
explore: customers {
  from: users
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${customers.id} = ${order_items.user_id} ;;
  }
  join: inventory_items {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
  join: x_users_order_items {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
}
  join: x_order_items_inventory_items {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
}
}
