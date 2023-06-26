view: order_item_facts {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: count_of_items {}
      column: product_category { field: inventory_items.product_category }
      column: product_brand { field: inventory_items.product_brand }
    }
  }
  dimension: id {
    primary_key: yes
    description: ""
    type: number
  }
  dimension: product_category {
    description: ""
  }
  dimension: product_brand {
    description: ""
  }
  dimension: count_of_items {}

  measure: average_count_of_items {
    type: average
    sql: ${count_of_items} ;;
  }
}
