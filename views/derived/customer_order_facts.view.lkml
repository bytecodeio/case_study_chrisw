view: customer_order_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_sale_price {}
      column: average_sale_price {}
      column: total_number_of_items {}
      column: count_of_orders {}
      column: first_order_date {}
      column: last_order_date {}
      derived_column: average_revenue {
        sql: 1.0 * total_sale_price / NULLIF(total_number_of_items,0)  ;;
      }
    }
  }

  dimension: user_id {
    hidden: yes
    primary_key: yes
    description: ""
    type: number
  }

  dimension: average_revenue {
    hidden: yes
    type: number
  }

  dimension: average_sale_price {
    hidden: yes
    description: ""
    value_format: "$#,##0.00"
    type: number
  }

  dimension: count_of_orders {
    hidden: yes
    type: number
  }

  dimension: first_order_date {
    type: date
    view_label: "Customers"
  }

  dimension: last_order_date {
    view_label: "Customers"
  }

  dimension: is_active_customer {
    description: "Value is Yes when a customer last ordered in the past 90 days and No when a customer last ordered more than 90 days ago. "
    view_label: "Customers"
    type: yesno
    sql: (${days_since_last_order} <= 90) ;;
  }

  dimension: is_repeat_customer {
    description: "Value is Yes when a user has ordered more than once during their lifetime and No when a user has ordered only once or has not ordered."
    view_label: "Customers"
    type: yesno
    sql: ${count_of_orders} > 1 ;;
    link: {
      label: "Repeat Customer Behavior Dashboard"
      url: "https://looker.bytecode.io/dashboards/v7XysZcLFdfyf1Zax7V9ua"
    }
  }

  dimension: is_all_customers {
    hidden: yes
    view_label: "Customers"
    type: yesno
    sql: ${count_of_orders} > 0 ;;
  }

  dimension: lifetime_orders {
    description: "The number of orders for a customer over their lifetime, groupped into ranges."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    group_item_label: "Customer Lifetime Orders"
    case: {
      when: {
        sql: ${count_of_orders} = 1;;
        label: "1 Order"
      }
      when: {
        sql: ${count_of_orders} = 2;;
        label: "2 Orders"
      }
      when: {
        sql: ${count_of_orders} IN (3,4,5);;
        label: "3-5 Orders"
      }
      when: {
        sql: ${count_of_orders} IN (6,7,8,9);;
        label: "6-9 Orders"
      }
      when: {
        sql: ${count_of_orders} >= 10;;
        label: "10+ Orders"
      }
      else: "0 Orders"
    }
  }

  dimension_group: since_last_order {
    view_label: "Customers"
    type: duration
    sql_start: ${last_order_date};;
    sql_end: CURRENT_TIMESTAMP();;
    intervals: [day,week,month,year]
  }

  dimension: total_lifetime_revenue_range {
    description: "The sum total revenue for a customer over their lifetime, groupped into ranges."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    group_item_label: "Customer Lifetime Revenue"
    type: tier
    tiers: [5,20,50,100,500,1000]
    sql:  ${TABLE}.total_sale_price ;;
    style: relational
  }

  dimension: total_lifetime_revenue{
    description: "The sum total revenue for a customer over their lifetime."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    value_format: "$#,##0.00"
    type: number
    sql:  ${TABLE}.total_sale_price ;;
  }

  dimension: total_lifetime_orders {
    description: "The number of orders for a customer over their lifetime"
    view_label: "Customers"
    group_label: "Lifetime Order History"
    group_item_label: "Order Count"
    type: number
    sql: ${count_of_orders} ;;
  }

  dimension: total_number_of_items {
    description: "The number of items for a customer over their lifetime"
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: number
  }

  measure: average_days_since_last_order {
    description: "The average number of days since a customer's last order."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: average
    sql: ${days_since_last_order}} ;;
  }

  measure: average_days_since_signup {
    description: "The average number of days since a user signed up."
    view_label: "Customers"
    type: average
    sql: ${customers.days_since_signup} ;;
  }

  measure: average_months_since_signup {
    description: "The average number of months since a user signed up."
    view_label: "Customers"
    type: average
    sql: ${customers.months_since_signup} ;;
  }

  # measure: average_revenue_per_customer{
  #   view_label: "Customers"
  #   group_label: "Lifetime Order History"
  #   type: average
  #   sql: ${total_lifetime_revenue} ;;
  # }

  measure: average_orders_per_customer {
    description: "The average number of customers total lifetime orders."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: average
    value_format_name: decimal_2
    sql: ${total_lifetime_orders} ;;
  }

  measure: count_of_repeat_customers {
    label: "Repeat Customers"
    description: "The number of customers with more than one order in their lifetimes."
    view_label: "Customers"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [is_repeat_customer: "Yes"]
    link: {
      label: "Repeat Customer Behavior Dashboard"
      url: "https://looker.bytecode.io/dashboards/v7XysZcLFdfyf1Zax7V9ua"
    }
  }

  measure: repeat_customer_conversion_rate {
    label: "Repeat Customer CR"
    description: "The percentage of repeat customers / total number of customers."
    view_label: "Customers"
    type: number
    sql: 1.0 * ${count_of_repeat_customers} / NULLIF(${x_users_order_items.total_number_of_customers},0) ;;
    value_format_name: percent_0
    link: {
      label: "Repeat Customer Behavior Dashboard"
      url: "https://looker.bytecode.io/dashboards/v7XysZcLFdfyf1Zax7V9ua"
    }
  }

  measure: repeat_purchase_rate {
    description: "The number of customers with more than one order in their lifetimes / the total number of customers."
    view_label: "Customers"
    type: number
    sql: 1.0 * ${count_of_repeat_customers} / NULLIF(${x_users_order_items.total_number_of_customers},0) ;;
    value_format_name: percent_2
    }
}
