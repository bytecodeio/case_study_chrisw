view: users_crossview {
  dimension: id {
    primary_key: yes
    type: number
    sql:${customers.id} ;;
    hidden: yes
  }

  measure: average_spend_per_customer {
    type: number
    description: "Total sales per customer"
    sql:1.0 * ${order_items.total_sale_price} / NULLIF(${total_number_of_customers},0) ;;
    view_label: "Customers"
    value_format_name: usd
  }

  measure: number_of_customers_returning_items {
    type: count_distinct
    description: "The number of customers who have returned an item at some point."
    sql: ${id} ;;
    filters: [order_items.status: "Returned"]
    view_label: "Customers"
  }

  measure: total_number_of_customers {
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${id} ;;
    filters: [order_items.order_id: "> 0"]
    view_label: "Customers"
  }

  measure: percent_of_customers_with_returns {
    type: number
    description: "The percentage of customers who have returned an item at some point."
    sql: 1.0 * ${number_of_customers_returning_items} / NULLIF(${total_number_of_customers},0);;
    view_label: "Customers"
    value_format_name: percent_2
  }

}
