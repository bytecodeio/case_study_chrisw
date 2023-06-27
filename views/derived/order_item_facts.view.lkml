view: order_item_facts {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: count_of_items {}
      column: product_category { field: inventory_items.product_category }
      column: product_brand { field: inventory_items.product_brand }
    }
  }

  dimension: count_of_items {}

  dimension: id {
    primary_key: yes
    description: ""
    type: number
  }

  dimension: product_brand {
    description: ""
  }

  dimension: product_category {
    description: ""
  }

  measure: average_count_of_items {
    type: average
    sql: ${count_of_items} ;;
  }
}
