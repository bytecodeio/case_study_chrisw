view: order_items {
  sql_table_name: `looker-partners.thelook.order_items` ;;
  ##################################
  ########### Parameters ###########
  ##################################

  parameter: measure_selector {
    type: unquoted
    # default_value: "count_of_orders"
    allowed_value: {
      label: "Count Of Orders"
      value: "count_of_orders"
    }
    allowed_value: {
      label: "Total Gross Revenue"
      value: "total_gross_revenue"
    }
    allowed_value: {
      label: "Total Number Of Items"
      value: "total_number_of_items"
    }
  }

  parameter: timeframe_selector {
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

  ##################################
  ########### Dimensions ###########
  ##################################

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_year,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: dynamic_timeframe {
    label_from_parameter: timeframe_selector
    sql:
      {% if timeframe_selector._parameter_value == "date" %} ${created_date}
      {% elsif timeframe_selector._parameter_value == "month" %} ${created_month}
      {% elsif timeframe_selector._parameter_value == "year" %} ${created_year}
      {% else %} ${created_week}
      {% endif %}
      ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: string
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: item_is_returned {
    type: yesno
    sql: ${TABLE}.returned_at IS NOT NULL ;;
  }

  dimension: item_is_cancelled {
    type: yesno
    sql: ${TABLE}.shipped_at IS NULL ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    order_by_field: status_sort_order
  }

  dimension: status_sort_order {
    hidden: yes
    type: number
    sql: CASE WHEN ${status} = 'Cancelled' THEN 1
              ELSE 2
              END ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  ################################
  ########### Measures ###########
  ################################

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd
  }

  measure: dynamic_measure {
    type: number
    value_format: "#,##0"
    label_from_parameter: measure_selector
    sql:
    {% if measure_selector._parameter_value == 'count_of_orders' %}
      ${count_of_orders}
    {% elsif measure_selector._parameter_value == 'total_gross_revenue' %}
      ${total_gross_revenue}
    {% else %}
      ${total_number_of_items}
    {% endif %}
    ;;
    html:
    {% if measure_selector._parameter_value == 'total_gross_revenue' %}
    ${{ rendered_value }}
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
  }

  measure: first_order_date {
    hidden: yes
    type: date
    sql: MIN(${order_items.created_raw}) ;;
  }


  measure: item_return_rate {
    type: number
    description: "The number of items returned / the total number of items sold."
    sql: 1.0 * ${number_of_returned_items} / NULLIF(${total_number_of_items},0) ;;
    value_format_name: percent_2
  }

  measure: last_order_date {
    hidden: yes
    type: date
    sql: MAX(${order_items.created_raw}) ;;
  }

  measure: number_of_returned_items {
    type: count_distinct
    sql: ${inventory_item_id} ;;
    filters: [item_is_returned: "Yes"]
  }

  measure:  total_gross_revenue {
    type: sum
    description: "Sum of sale price for order items with a status of complete or shipped."
    sql: ${sale_price} ;;
    filters: [item_is_returned: "No", item_is_cancelled: "No"]
    value_format_name: usd
    drill_fields: [sale_price]
  }

  measure: total_number_of_items {
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  ##################################
  ########### Hidden ###############
  ##################################

  measure: average_daily_revenue_prior_12_months {
    hidden: yes
    type: number
    sql: 1.0 * ${total_revenue_prior_12_months} / NULLIF(${total_count_days_prior_12_months},0) ;;
    value_format_name: usd_0
  }

  measure:  total_gross_revenue_prior_30_days {
    hidden: yes
    type: sum
    description: "Sum of sale price for order items with a status of complete or shipped."
    sql: ${sale_price} ;;
    filters: [item_is_returned: "No", item_is_cancelled: "No", created_date: "last 30 days"]
    value_format_name: usd
  }

  measure:  total_gross_revenue_prior_12_months {
    hidden: yes
    type: sum
    description: "Sum of sale price for order items with a status of complete or shipped."
    sql: ${sale_price} ;;
    filters: [item_is_returned: "No", item_is_cancelled: "No", created_date: "last 12 months"]
    value_format_name: usd_0
  }

  measure: total_revenue_prior_12_months {
    hidden: yes
    type: sum
    sql: ${sale_price} ;;
    filters: [created_date: "12 months"]
    value_format_name: usd
  }

  measure: total_revenue_yesterday {
    hidden: yes
    type: sum
    sql: ${sale_price} ;;
    filters: [order_items.created_date: "yesterday", item_is_returned: "No", item_is_cancelled: "No"]
    value_format_name: usd
  }

  measure: total_sale_price_prior_30_days {
    hidden: yes
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [created_date: "last 30 days"]
  }

  measure: total_sale_price_prior_12_months {
    hidden: yes
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [created_date: "last 12 months"]
  }

  measure: total_count_days_prior_12_months {
    hidden: yes
    type: count_distinct
    sql: ${created_day_of_year} ;;
    filters: [created_date: "12 months", item_is_returned: "No", item_is_cancelled: "No"]
  }


}
