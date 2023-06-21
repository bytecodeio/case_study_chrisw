view: x_order_items_pop2 {
  #Filtered measures

  measure: current_period_sales {
    view_label: "_PoP"
    type: sum
    sql: ${order_items.sale_price};;
    sql_distinct_key: ${order_items.id} ;;
    filters: [pop2.period_filtered_measures: "this"]
  }

  measure: previous_period_sales {
    view_label: "_PoP"
    type: sum
    sql: ${order_items.sale_price};;
    sql_distinct_key: ${order_items.id} ;;
    filters: [pop2.period_filtered_measures: "last"]
  }

  measure: sales_pop_change {
    view_label: "_PoP"
    label: "Total Sales period-over-period % change"
    type: number
    sql: CASE WHEN ${current_period_sales} = 0
                THEN NULL
                ELSE (1.0 * ${current_period_sales} / NULLIF(${previous_period_sales} ,0)) - 1 END ;;
    value_format_name: percent_2
  }
}
