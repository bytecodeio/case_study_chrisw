# a better naming convention: x_order_items_inventory_items
view: order_items_crossview{
  dimension: id {
    primary_key: yes
    type: number
    sql:${order_items.id} ;;
    hidden: yes
  }

  measure: total_gross_margin_amount {
    type: sum
    description: "Total revenue from completed sales less the cost of items sold."
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete"]
    view_label: "Order Items"
    value_format_name: usd
  }

  measure: average_gross_margin_amount {
    type: average
    description: "Average revenue from completed sales less the cost of items sold."
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete"]
    view_label: "Order Items"
    value_format_name: usd
  }

  measure: gross_margin_percent {
    type: number
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: 1.0*${total_gross_margin_amount} / NULLIF(${order_items.total_gross_revenue},0) ;;
    view_label: "Order Items"
    value_format_name: percent_2
    }
}
