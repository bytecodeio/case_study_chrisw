include: "/views/order_items.view.lkml"
include: "/views/inventory_items.view.lkml"

view: x_order_items_inventory_items {

  measure: total_gross_margin_amount {
    type: sum
    description: "Total revenue from completed sales less the cost of items sold."
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete"]
    view_label: "Order Items"
    value_format_name: usd
    sql_distinct_key: ${order_items.id} ;;
  }

  measure: average_gross_margin_amount {
    type: average
    description: "Average revenue from completed sales less the cost of items sold."
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete"]
    view_label: "Order Items"
    value_format_name: usd
    sql_distinct_key: ${order_items.id} ;;
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
  # set: brand_details {
  #   fields: [inventory_items.product_brand,gross_margin_percent,order_items.total_gross_revenue]
  # }

  measure: total_gross_margin_amount_prior_30_days {
    hidden: yes
    type: sum
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete", order_items.created_date: "last 30 days"]
    view_label: "Order Items"
    value_format_name: usd
    sql_distinct_key: ${order_items.id} ;;
    link: {
      label: "Conversion Funnel Dashboard"
      url: "https://looker.bytecode.io/dashboards/vqUMxGaXc4CLMupKp2fd9c"
    }
  }

  measure: total_gross_margin_amount_prior_12_months {
    hidden: yes
    type: sum
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.status: "Complete", order_items.created_date: "last 12 months"]
    view_label: "Order Items"
    value_format_name: usd
    sql_distinct_key: ${order_items.id} ;;
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

  measure: brand_gross_revenue {
    type: number
    sql: 1.0 * ${order_items.total_gross_revenue} / NULLIF(${inventory_items.count_of_brands},0) ;;
  }

  measure: brand_items {
    type: number
    sql: 1.0 * ${order_items.total_number_of_items} / NULLIF(${inventory_items.count_of_brands},0) ;;
  }
}
