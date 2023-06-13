view: order_sequence {
  derived_table: {
    explore_source: customers {
      column: id {}
      column: order_id {
        field: order_items.order_id
      }
      column: created_date {
        field: order_items.created_date
      }
      derived_column: order_sequence {
        sql: ROW_NUMBER() OVER (PARTITION BY id ORDER BY created_date) ;;
      }
      derived_column: order_date_lag {
        sql: LAG(created_date,1) OVER (PARTITION BY id ORDER BY created_date ASC) ;;
      }
    }
  }
  dimension: id  {
    #hidden: yes
    type: number
  }

  dimension: created_date {
    # hidden: yes
    type: date
  }

  dimension: order_date_lag {
    type: date
  }

  dimension: order_id {
    primary_key: yes
  }

  dimension: order_sequence {
    type: number
    description: "The order in which a customer placed orders over their lifetime."
  }

  dimension_group: since_previous_order {
    type: duration
    sql_start: ${order_date_lag} ;;
    sql_end: ${created_date} ;;
    intervals: [day,week,month,year]
  }
}
