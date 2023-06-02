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

  dimension: average_revenue {
    type: number
  }

  dimension: average_sale_price {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }

  dimension: count_of_orders {
    type: number
  }

  dimension: first_order_date {
    view_label: "Customers"
    group_label: "Lifetime Order History"
  }

  dimension_group: since_last_order {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: duration
    sql_start: ${last_order_date};;
    sql_end: CURRENT_TIMESTAMP();;
    intervals: [day,week,month,year]
  }

  dimension: last_order_date {
    view_label: "Customers"
    group_label: "Lifetime Order History"
  }

  dimension: is_active {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: yesno
    sql: ${days_since_last_order} <= 90 ;;
  }

  dimension: is_repeat {
    view_label: "Customers"
    type: yesno
    sql: ${count_of_orders} > 1 ;;
  }

  dimension: lifetime_orders {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    group_item_label: "Order Count Range"
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
      else: "No Orders"
    }
  }

  dimension: total_lifetime_revenue_range {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: tier
    tiers: [0.00,4.99,5,19.99,20,49.99,
      50,99.99,100,499.99,500,999.99,1000]
    sql:  ${TABLE}.total_sale_price ;;
    style: relational
  }

  dimension: total_lifetime_revenue{
    view_label: "Customers"
    group_label: "Lifetime Order History"
    value_format: "$#,##0.00"
    type: number
    sql:  ${TABLE}.total_sale_price ;;
  }

  dimension: total_lifetime_orders {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    group_item_label: "Order Count"
    type: number
    sql: ${count_of_orders} ;;
  }

  dimension: total_number_of_items {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    description: ""
    type: number
  }

  dimension: user_id {
    primary_key: yes
    description: ""
    type: number
  }

  measure: average_days_since_last_order {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: average
    sql: ${days_since_last_order}} ;;
  }

  measure: average_revenue_per_customer{
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: average
    sql: ${total_lifetime_revenue} ;;
  }

  measure: average_orders_per_customer {
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: average
    sql: ${total_lifetime_orders} ;;
  }

}
