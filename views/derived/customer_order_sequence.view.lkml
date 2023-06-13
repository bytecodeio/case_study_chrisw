view: customer_order_sequence {
  derived_table: {
    explore_source: order_items {
      column: user_id {
        field: order_items.user_id
      }
      column: order_id {
        field: order_items.order_id
      }
      column: minimum_order_date {
        field: order_items.minimum_order_date
      }
      derived_column: order_sequence {
        sql: ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY minimum_order_date) ;;
      }
      derived_column: order_date_lag {
        sql: LAG(minimum_order_date,1) OVER (PARTITION BY user_id ORDER BY minimum_order_date ASC) ;;
      }
    }
  }
  dimension: user_id  {
    # hidden: yes
    type: number
  }

  dimension: minimum_order_date {
    # hidden: yes
    type: date
  }

  dimension: order_date_lag {
    type: date
  }

  dimension: order_id {}

  dimension: order_sequence {
    type: number
    description: "The order in which a customer placed orders over their lifetime."
    view_label: "Customers"
  }

  dimension_group: since_previous_order {
    view_label: "Customers"
    type: duration
    sql_start: ${order_date_lag} ;;
    sql_end: ${minimum_order_date} ;;
    intervals: [day,week,month,year]
  }

  measure: avg_days_between_orders {
    type: average
    sql: ${days_since_previous_order} ;;
  }

  measure: order_sequence_lag1 {
    # hidden: yes
    type: number
    sql: LAG(${order_sequence},1) OVER (PARTITION BY ${user_id} ORDER BY ${order_sequence} ASC) ;;
  }
}
