view: x_users_customer_order_sequence {
  dimension: id {
    hidden: yes
    primary_key: yes
    sql: ${customers.id} ;;
  }
  measure: repeat_60_day_purchase_count {
    view_label: "Customers"
    description: "Count of customers who have repurchased within 60 days at least one in their lifetime."
    type: count
    filters: [customer_order_sequence.total_60_day_repurchased_orders: ">0"]
  }

  measure: repeat_60_day_purchase_rate {
    view_label: "Customers"
    description: "Count of customers who have repurchased within 60 days at least one in their lifetime divided by total count of customers."
    type: number
    sql: 1.0 * ${repeat_60_day_purchase_count} / NULLIF(${x_users_order_items.total_number_of_customers},0) ;;
    value_format_name: percent_2
  }
}
