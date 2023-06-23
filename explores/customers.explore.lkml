include: "/views/users.view.lkml"
include: "/views/events.view.lkml"
include: "/views/crossviews/x_users_order_items.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
include: "/views/crossviews/x_users_customer_order_sequence.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/dashboard_selectors.view.lkml"
include: "/views/derived/customer_order_facts.view.lkml"
include: "/views/derived/order_sequence.view.lkml"
include: "/views/derived/customer_order_sequence.view.lkml"
include: "/views/derived/order_facts.view.lkml"
include: "/views/pop2.view.lkml"
include: "/views/crossviews/x_order_items_pop2.view.lkml"
include: "/views/crossviews/x_users_events.view.lkml"
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
    relationship: one_to_many
    sql:  ;;
  }
  join: x_order_items_inventory_items {
    relationship: one_to_one
    sql:  ;;
  }
  join: order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }
  join: customer_order_facts {
    type: left_outer
    relationship:one_to_one
    sql_on: ${customers.id} = ${customer_order_facts.user_id} ;;
  }
  join: order_sequence {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.order_id} = ${order_sequence.order_id} ;;
  }
  join: customer_order_sequence {
    type: left_outer
    relationship: one_to_one
    sql_on: ${customers.id} = ${customer_order_sequence.id};;
  }
  join: x_users_customer_order_sequence {
    relationship: one_to_one
    sql:  ;;
  }
  join: pop2 {
    type: full_outer
    relationship: many_to_one
    # use liquid to if statement for sql_on
    sql_on: ${customers.created_date} = DATE(${pop2.date_array_date}) ;;
  }
  join: x_order_items_pop2 {
    relationship: one_to_one
    sql:  ;;
  }

  join: x_users_events {
    relationship: one_to_many
    sql:  ;;
  }
}
