view: x_users_events {
  measure: user_conversion_rate {
    type: number
    description: "The percentage of website visits / total number of user signups."
    sql: 1.0 * ${customers.count_of_users} / NULLIF(${events.website_visits},0);;
    view_label: "Customers"
    value_format_name: percent_0
    link: {
      label: "New User Signup Dashboard"
      url: "https://looker.bytecode.io/dashboards/PL4tqFSf5ini9lBvS835t8"
    }
  }
}
