view: dt_orders_by_day {
  derived_table: {
    increment_key: "created_date"
    increment_offset: 7
    datagroup_trigger: order_items_dg
    explore_source: order_items {
      column: order_id {}
      column: created_date {}
    }
  }

  dimension: order_id {
    type: number
  }

  dimension: created_date {
    type: date
  }

  measure: count_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }
 }
