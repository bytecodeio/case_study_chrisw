view: order_sequence {
  derived_table: {
    explore_source: customers {
      column: id {}
      column: order_id {
        field: order_items.order_id
      }
      column: minimum_order_date {
        field: order_facts.min_created_date
      }
      derived_column: order_sequence {
        sql: ROW_NUMBER() OVER (PARTITION BY id ORDER BY minimum_order_date) ;;
      }
      derived_column: order_date_lag {
        sql: LAG(minimum_order_date,1) OVER (PARTITION BY id ORDER BY minimum_order_date ASC) ;;
      }
    }
  }
  dimension: id  {
    hidden: yes
    type: number
  }

  dimension: minimum_order_date {
    hidden: yes
    type: date
  }

  dimension: is_first_purchase {
    view_label: "Order"
    type: yesno
    description: "Order is the customer's first purchase."
    sql: ${order_sequence} = 1 ;;
  }

  dimension: is_repeat_purchase_within_60_days {
    hidden: yes
    type: number
    sql:
    CASE WHEN ${days_since_previous_order} <= 60 THEN 1
    ELSE 0
    END
    ;;
  }

  dimension: order_date_lag {
    hidden: yes
    type: date
  }

  dimension: order_id {
    hidden: yes
    primary_key: yes
  }

  dimension: order_sequence {
    view_label: "Order"
    type: number
    description: "The order in which a customer placed orders over their lifetime."
  }

  dimension_group: since_previous_order {
    view_label: "Order"
    type: duration
    sql_start: ${order_date_lag} ;;
    sql_end: ${minimum_order_date} ;;
    intervals: [day,week,month,year]
  }

  measure: average_days_between_orders {
    view_label: "Order"
    description: "The average number of days between a customer's orders."
    type: average_distinct
    sql: ${days_since_previous_order} ;;
    sql_distinct_key: ${order_id} ;;
  }

  measure: total_60_day_repurchased_orders {
    hidden: yes
    type: sum_distinct
    sql: ${is_repeat_purchase_within_60_days} ;;
    sql_distinct_key: ${order_id} ;;
  }
}
