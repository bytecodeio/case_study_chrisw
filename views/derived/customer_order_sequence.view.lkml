# If necessary, uncomment the line below to include explore_source.
# include: "customers.explore.lkml"

view: customer_order_sequence {
  derived_table: {
    explore_source: customers {
      column: id {}
      column: days_since_previous_order { field: order_sequence.days_since_previous_order }
    }
  }
  dimension: id {
    primary_key: yes
    description: ""
    type: number
  }
  dimension: days_since_previous_order {
    description: ""
    value_format: "0"
    type: number
  }
  measure: average_days_between_orders {
    type: average
    sql: ${days_since_previous_order} ;;
  }
}
