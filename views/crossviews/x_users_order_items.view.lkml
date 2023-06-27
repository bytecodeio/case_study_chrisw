view: x_users_order_items {

  measure: average_items_per_customer {
    type: number
    sql: ${order_items.total_number_of_items} / NULLIF(${total_number_of_customers},0) ;;
    view_label: "Customers"
    value_format_name: decimal_2
  }

  measure: average_spend_per_customer {
    type: number
    description: "Total sales per customer"
    sql:1.0 * ${order_items.total_sale_price} / NULLIF(${total_number_of_customers},0) ;;
    view_label: "Customers"
    value_format_name: usd
  }

  measure: count_of_customers_completed_and_shipped {
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    sql_distinct_key: ${customers.id} ;;
    filters: [order_items.order_id: "> 0", order_items.status: "Complete,Shipped"]
    view_label: "Customers"
  }

  measure: customer_conversion_rate {
    type: number
    description: "The percentage of users that become customers."
    sql: 1.0 * ${total_number_of_customers} / NULLIF(${customers.count_of_users},0);;
    view_label: "Customers"
    value_format_name: percent_0
    link: {
      label: "Customer Purchase Behavior Dashboard"
      url: "https://looker.bytecode.io/dashboards/WAgveoGHyIJ18BJYJIassO"
    }
  }

  measure: number_of_customers_returning_items {
    type: count_distinct
    description: "The number of customers who have returned an item at some point."
    sql: ${customers.id} ;;
    sql_distinct_key: ${customers.id} ;;
    filters: [order_items.status: "Returned"]
    view_label: "Customers"
  }

  measure: percent_of_customers_with_returns {
    type: number
    description: "The percentage of customers who have returned an item at some point."
    sql: 1.0 * ${number_of_customers_returning_items} / NULLIF(${total_number_of_customers},0);;
    view_label: "Customers"
    value_format_name: percent_2
  }

  measure: total_number_of_customers {
    label: "Customers"
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    sql_distinct_key: ${customers.id} ;;
    filters: [order_items.order_id: "> 0"]
    view_label: "Customers"
    value_format_name: decimal_0
    link: {
      label: "Customer Purchase Behavior Dashboard"
      url: "https://looker.bytecode.io/dashboards/WAgveoGHyIJ18BJYJIassO"
    }
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
    value_format_name: usd_0
  }

  measure: revenue_per_customer_completed_and_shipped {
    type: number
    description: "Total gross revenue / count_of_customers_completed_and_shipped"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${count_of_customers_completed_and_shipped},0);;
    view_label: "Customers"
    value_format_name: usd_0
  }

  measure: revenue_per_user {
    type: number
    description: "Total gross revenue / total count of customers"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${customers.count_of_users},0);;
    view_label: "Customers"
  }

  measure: sales_per_customer {
    description: "Total sales divided by the total number of customers"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${total_number_of_customers},0);;
    view_label: "Customers"
  }

  measure: sales_per_user {
    description: "Total sales divided by the total number of users"
    sql:  1.0 * ${order_items.total_gross_revenue} / NULLIF(${customers.count_of_users},0);;
    view_label: "Customers"
  }

  measure: total_number_of_customers_prior_30_days {
    hidden: yes
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    sql_distinct_key: ${customers.id} ;;
    filters: [order_items.order_id: "> 0", order_items.created_date: "last 30 days"]
    view_label: "Customers"
  }

  measure: total_number_of_customers_prior_12_months {
    hidden: yes
    type: count_distinct
    description: "The total number of unique customers"
    sql: ${customers.id} ;;
    sql_distinct_key: ${customers.id} ;;
    filters: [order_items.order_id: "> 0", order_items.created_date: "last 12 months"]
    view_label: "Customers"
  }

}
