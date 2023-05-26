view: x_order_items_inventory_items {

  ##################################
  ########### Dimensions ###########
  ##################################

  dimension: id {
    primary_key: yes
    type: number
    sql:${order_items.id} ;;
    hidden: yes
  }

  ##################################
  ########### Measures #############
  ##################################

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
    drill_fields: [item_details*]
  }
  set: item_details {
    fields: [inventory_items.product_category,gross_margin_percent,order_items.total_gross_revenue]
  }

  ##################################
  ########### Hidden ###############
  ##################################

  measure: total_gross_margin_amount_prior_30_days {
    hidden: yes
    type: sum
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete", order_items.created_date: "last 30 days"]
    view_label: "Order Items"
    value_format_name: usd
  }

  measure: total_gross_margin_amount_prior_12_months {
    hidden: yes
    type: sum
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete", order_items.created_date: "last 12 months"]
    view_label: "Order Items"
    value_format_name: usd
  }

  measure: gross_margin_percent_prior_30_days {
    hidden: yes
    type: number
    sql: 1.0*${total_gross_margin_amount_prior_30_days} / NULLIF(${order_items.total_gross_revenue_prior_30_days},0) ;;
    view_label: "Order Items"
    value_format_name: percent_2
  }

  measure: gross_margin_percent_prior_12_months {
    hidden: yes
    type: number
    sql: 1.0*${total_gross_margin_amount_prior_12_months} / NULLIF(${order_items.total_gross_revenue_prior_12_months},0) ;;
    view_label: "Order Items"
    value_format_name: percent_2
  }
}
