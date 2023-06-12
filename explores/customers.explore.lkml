include: "/views/users.view.lkml"
include: "/views/events.view.lkml"
include: "/views/crossviews/x_users_order_items.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/dashboard_selectors.view.lkml"
include: "/views/derived/customer_order_facts.view.lkml"
include: "/views/derived/customer_order_sequence.view.lkml"
explore: customers {
  from: users
  join: dashboard_selectors {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
  }
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${customers.id} = ${order_items.user_id} ;;
  }
  join: events {
    type: left_outer
    relationship: one_to_many
    sql_on: ${customers.id} = ${events.user_id} ;;
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
  join: customer_order_facts {
    type: left_outer
    relationship:one_to_one
    sql_on: ${customers.id} = ${customer_order_facts.user_id} ;;
  }
  join: customer_order_sequence {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${customer_order_sequence.order_id} ;;
  }
}
