include: "/views/users.view.lkml"
include: "/views/crossviews/users_crossview.view.lkml"
include: "/views/order_items.view.lkml"
explore: customers {
  from: users
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${customers.id} = ${order_items.user_id} ;;
  }
  join: users_crossview {
    type: left_outer
    relationship: one_to_one
    sql:  ;;
}
}
