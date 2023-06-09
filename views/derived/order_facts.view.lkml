view: order_facts {
  # fields_hidden_by_default: yes
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: created_raw {}
      column: count_of_items {}
    }
  }

  dimension: count_of_items {
    view_label: "Order"
  }

  dimension: created_raw {
  }

  dimension: order_id {
    primary_key: yes
    description: ""
    type: number
  }

  measure: min_created_date {
    sql: MIN(${created_raw}) ;;
  }
}

# example for how to create a derived table based on a view
# view: order_summary {
#   derived_table: {
#     sql: SELECT * FROM ${order_facts.SQL_TABLE_NAME} ;;
#   }
# }
