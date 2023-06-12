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

  dimension: order_id {}

  dimension: order_sequence {
    type: number
    description: "The order in which a customer placed orders over their lifetime."
    view_label: "Customers"
  }

  measure: order_sequence_lag1 {
    # hidden: yes
    type: number
    sql: LAG(${order_sequence},1) OVER (PARTITION BY ${user_id} ORDER BY ${order_sequence} ASC) ;;
  }

  dimension_group: since_previous_order {
    view_label: "Customers"
    type: duration
    sql_start:
    {% if order_sequence > order_sequence_lag1 %}
      LAG(${TABLE}.minimum_order_date,1) OVER (PARTITION BY ${user_id} ORDER BY ${order_sequence} ASC)
    {% else %}
      ${TABLE}.minimum_order_date
    {% endif %}
    ;;
    sql_end:
    {% if order_sequence > order_sequence_lag1 %}
      ${TABLE}.minimum_order_date
    {% else %}
      ${TABLE}.minimum_order_date
    {% endif %}
    ;;
    intervals: [day,week,month,year]
  }
}
