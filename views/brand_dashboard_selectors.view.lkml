include: "/views/order_items.view.lkml"
include: "/views/users.view.lkml"
include: "/views/crossviews/x_order_items_inventory_items.view.lkml"
include: "/views/crossviews/x_users_order_items.view.lkml"
include: "/views/derived/customer_order_facts.view.lkml"
include: "/views/derived/product_facts.view.lkml"
view: brand_dashboard_selectors {
  parameter: select_a_measure_primary {
    type: unquoted
    allowed_value: {
      label: "Items Sold"
      value: "average_number_of_items"
    }
    allowed_value: {
      label: "Gross Revenue"
      value: "average_gross_revenue"
    }
  }

  measure: selected_measure_primary {
    type: number
    value_format: "#,##0"
    label_from_parameter: select_a_measure_primary
    sql:
    {% if select_a_measure_primary._parameter_value == 'average_number_of_items' %}
      ${x_order_items_inventory_items.brand_items}
    {% else %}
      ${x_order_items_inventory_items.brand_gross_revenue}
    {% endif %}
    ;;
    html:
    {% if select_a_measure_primary._parameter_value == "total_gross_revenue" %}
      ${{ rendered_value }}
    {% elsif select_a_measure_primary._parameter_value == "average_gross_revenue" %}
      ${{ rendered_value }}
    {% else %}
      {{ rendered_value }}
    {% endif %}
    ;;
  }
 }
