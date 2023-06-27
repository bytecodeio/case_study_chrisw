include: "/views/order_items.view.lkml"
include: "/views/users.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
include: "/views/crossviews/x_users_order_items.view.lkml"
include: "/views/derived/customer_order_facts.view.lkml"
include: "/views/derived/order_item_facts.view.lkml"
view: dashboard_selectors {

  parameter: select_a_dimension {
    type: unquoted
    # default_value: "count_of_orders"
    allowed_value: {
      label: "Active Customers"
      value: "active_customers"
    }
    allowed_value: {
      label: "Repeat Customers"
      value: "repeat_customers"
    }
    allowed_value: {
      label: "All Customers"
      value: "all_customers"
    }
  }

  parameter: select_a_measure_primary {
    type: unquoted
    # default_value: "count_of_orders"
    allowed_value: {
      label: "Count Of Users"
      value: "count_of_users"
    }
    allowed_value: {
      label: "Total Number Of Customers"
      value: "total_number_of_customers"
    }
    allowed_value: {
      label: "Count Of Orders"
      value: "count_of_orders"
    }
    allowed_value: {
      label: "Count Of Items"
      value: "count_of_items"
    }
    allowed_value: {
      label: "Avg. Number Of Items"
      value: "average_number_of_items"
    }
    allowed_value: {
      label: "Total Gross Revenue"
      value: "total_gross_revenue"
    }
    allowed_value: {
      label: "Avg. Gross Revenue"
      value: "average_gross_revenue"
    }
    allowed_value: {
      label: "Total Gross Margin"
      value: "total_gross_margin_amount"
    }
  }

  parameter: select_a_measure_secondary {
    type: unquoted
    # default_value: "count_of_orders"
    allowed_value: {
      label: "Count Of Users"
      value: "count_of_users"
    }
    allowed_value: {
      label: "Total Number Of Customers"
      value: "total_number_of_customers"
    }
    allowed_value: {
      label: "Count Of Orders"
      value: "count_of_orders"
    }
    allowed_value: {
      label: "Total Gross Revenue"
      value: "total_gross_revenue"
    }
    allowed_value: {
      label: "Total Gross Margin"
      value: "total_gross_margin_amount"
    }
  }

  parameter: select_an_order_timeframe {
    type: unquoted
    # default_value: "week"
    allowed_value: {
      label: "Day"
      value: "date"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
  }

  dimension: selected_dimension {
    type: string
    label_from_parameter: select_a_dimension
    sql:
    {% if select_a_dimension._parameter_value == 'repeat_customers' %}
    ${customer_order_facts.is_repeat_customer}
    {% elsif select_a_dimension._parameter_value == 'active_customers' %}
    ${customer_order_facts.is_active_customer}
    {% else %}
    ${customer_order_facts.is_all_customers}
    {% endif %}
    ;;
  }

  dimension: selected_order_timeframe {
    label_from_parameter: select_an_order_timeframe
    sql:
      {% if select_an_order_timeframe._parameter_value == "date" %} ${order_items.created_date}
      {% elsif select_an_order_timeframe._parameter_value == "month" %} ${order_items.created_month}
      {% elsif select_an_order_timeframe._parameter_value == "year" %} ${order_items.created_year}
      {% else %} ${order_items.created_week}
      {% endif %}
      ;;
  }

  measure: selected_measure_primary {
    type: number
    value_format: "#,##0"
    label_from_parameter: select_a_measure_primary
    sql:
    {% if select_a_measure_primary._parameter_value == 'count_of_users' %}
      ${customers.count_of_users}
    {% elsif select_a_measure_primary._parameter_value == 'total_number_of_customers' %}
      ${x_users_order_items.total_number_of_customers}
    {% elsif select_a_measure_primary._parameter_value == 'count_of_orders' %}
      ${order_items.count_of_orders}
    {% elsif select_a_measure_primary._parameter_value == 'count_of_items' %}
      ${order_items.count_of_items}
    {% elsif select_a_measure_primary._parameter_value == 'average_number_of_items' %}
      ${order_items.average_count_of_items}
    {% elsif select_a_measure_primary._parameter_value == 'total_gross_revenue' %}
      ${order_items.total_gross_revenue}
      {% elsif select_a_measure_primary._parameter_value == 'average_gross_revenue' %}
      ${order_items.average_gross_revenue}
    {% else %}
      ${x_order_items_inventory_items.total_gross_margin_amount}
    {% endif %}
    ;;
    html:
    {% if select_a_measure_primary._parameter_value == "total_gross_revenue" %}
      ${{ rendered_value }}
    {% elsif select_a_measure_primary._parameter_value == "average_gross_revenue" %}
      ${{ rendered_value }}
    {% elsif select_a_measure_primary._parameter_value == "total_gross_margin_amount" %}
      ${{ rendered_value }}
    {% else %}
      {{ rendered_value }}
    {% endif %}
    ;;
  }

  measure: selected_measure_secondary {
    type: number
    value_format: "#,##0"
    label_from_parameter: select_a_measure_secondary
    sql:
    {% if select_a_measure_secondary._parameter_value == 'count_of_users' %}
      ${customers.count_of_users}
    {% elsif select_a_measure_secondary._parameter_value == 'total_number_of_customers' %}
      ${x_users_order_items.total_number_of_customers}
    {% elsif select_a_measure_secondary._parameter_value == 'count_of_orders' %}
      ${order_items.count_of_orders}
    {% elsif select_a_measure_secondary._parameter_value == 'total_gross_revenue' %}
      ${order_items.total_gross_revenue}
    {% else %}
      ${x_order_items_inventory_items.total_gross_margin_amount}
    {% endif %}
    ;;
    html:
    {% if select_a_measure_secondary._parameter_value == "total_gross_revenue" %}
    ${{ rendered_value }}
    {% endif %}
    ;;
  }

}
