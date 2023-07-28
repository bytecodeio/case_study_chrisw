test: order_item_id_is_unique {
  explore_source: customers {
    column: id {field: order_items.id}
    column: count_of_items {field: order_items.count_of_items}
    sorts: [order_items.count_of_items: desc]
    limit: 1
  }
  assert: order_id_is_unique {
    expression: ${order_items.count_of_items} = 1 ;;
  }
  }

test: recent_orders_logged {
  explore_source: customers {
    column: created_date { field: order_items.created_date }
    sorts: [order_items.created_date: desc]
    limit: 1
  }
  assert: order_items_create_date_is_recent {
   expression: ${order_items.created_date} >= add_days(-7,now()) ;;
  }
  }
