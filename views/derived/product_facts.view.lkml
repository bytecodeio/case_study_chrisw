view: product_facts {
  derived_table: {
    explore_source: order_items {
      column: created_year {}
      column: product_brand { field: inventory_items.product_brand }
      column: product_category { field: inventory_items.product_category }
      column: count_of_items {}
      column: total_gross_revenue {}
    }
  }
  dimension: compound_primary_key {
  primary_key: yes
  hidden: yes
  sql: ${product_brand} || '-' ||  ${product_brand} || '-' ${created_year} ;;
  }
  dimension: created_year {
    type: date_year
  }
  dimension: product_brand {
    description: ""
  }
  dimension: product_category {
    description: ""
  }
  dimension: count_of_items {
    description: ""
    type: number
  }
  dimension: total_gross_revenue {}
  measure: average_number_of_items {
    type: average
    sql: ${count_of_items} ;;
  }
  measure: average_total_gross_revenue {
    type: average
    sql: ${total_gross_revenue} ;;
  }

}
