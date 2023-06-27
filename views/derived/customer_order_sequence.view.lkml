# If necessary, uncomment the line below to include explore_source.
# include: "customers.explore.lkml"

view: customer_order_sequence {
  derived_table: {
    explore_source: customers {
      column: id {}
      column: average_days_between_orders {field: order_sequence.average_days_between_orders}
      column: total_60_day_repurchased_orders {field: order_sequence.total_60_day_repurchased_orders}
    }
  }

  dimension: average_days_between_orders {
    description: "Average number of days between a given customer's orders."
    view_label: "Customers"
    group_label: "Lifetime Order History"
    type: number
    value_format_name: decimal_0
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    description: ""
    type: number
  }

  dimension: total_60_day_repurchased_orders {
    hidden: yes
    type:number}

}
