test: order_item_id_is_unique {
  explore_source: customers {
    column: order_item_id {}
    column: count_of_items {}
    sorts: [order_items.count_of_items: desc]
    limit: 1
  }
  assert: order_id_is_unique {
    expression: ${order_items.count_of_items} = 1 ;;
  }
  }
