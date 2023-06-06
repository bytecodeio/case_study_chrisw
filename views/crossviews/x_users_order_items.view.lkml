view: x_users_order_items {

  ##################################
  ########### Dimensions ###########
  ##################################

  ##################################
  ########### Measures #############
  ##################################

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
    sql: ${customers.id} ;;
    filters: [order_items.status: "Returned"]
    view_label: "Customers"
  }

  measure: total_number_of_customers {
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
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

  ##################################
  ########### Hidden ###############
  ##################################

  measure: average_spend_per_customer_prior_30_days {
    hidden: yes
    type: number
    description: "Total sales per customer"
    sql:1.0 * ${order_items.total_sale_price_prior_30_days} / NULLIF(${total_number_of_customers_prior_30_days},0) ;;
    view_label: "Customers"
    value_format_name: usd
  }

  measure: average_spend_per_customer_prior_12_months {
    hidden: yes
    type: number
    description: "Total sales per customer"
    sql:1.0 * ${order_items.total_sale_price_prior_12_months} / NULLIF(${total_number_of_customers_prior_12_months},0) ;;
    view_label: "Customers"
    value_format_name: usd
  }

  measure: revenue_per_customer {
    type: number
    description: "Total gross revenue / total count of customers"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${total_number_of_customers},0);;
    view_label: "Customers"
  }

  measure: revenue_per_user {
    type: number
    description: "Total gross revenue / total count of customers"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${customers.count_of_users},0);;
    view_label: "Customers"
  }

  measure: total_number_of_customers_prior_30_days {
    hidden: yes
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    filters: [order_items.order_id: "> 0", order_items.created_date: "last 30 days"]
    view_label: "Customers"
  }

  measure: total_number_of_customers_prior_12_months {
    hidden: yes
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    filters: [order_items.order_id: "> 0", order_items.created_date: "last 12 months"]
    view_label: "Customers"
  }

}
