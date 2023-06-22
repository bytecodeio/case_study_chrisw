view: pop {

 ### ORIGINAL DIMENSIONS AND MEASURES ###
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    view_label: "_PoP"
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
  }

  measure: count {
    label: "Count of order_items"
    type: count
    hidden: yes
  }
  measure: count_orders {
    label: "Count of orders"
    type: count_distinct
    sql: ${order_id} ;;
    hidden: yes
  }

  measure: total_sale_price {
    label: "Total Sales"
    view_label: "_PoP"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [created_date]
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

 ###

  filter: current_date_range {
    type: date
    view_label: "_PoP"
    label: "1. Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
  }

  parameter: compare_to {
    view_label: "_PoP"
    description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
    label: "2. Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "Quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "Year"
    }
    default_value: "Period"
  }

  ## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##

  dimension: days_in_period {
    # hidden:  yes
    view_label: "_PoP"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATE_DIFF( DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %}), DAY) ;;
  }

  dimension: period_2_start {
    # hidden:  yes
    view_label: "_PoP"
    description: "Calculates the start of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL ${days_in_period} DAY)
        {% else %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: period_2_end {
    # hidden:  yes
    view_label: "_PoP"
    description: "Calculates the end of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 DAY)
        {% else %}
        DATE_SUB(DATE_SUB(DATE({% date_end current_date_range %}), INTERVAL 1 DAY), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
        THEN DATE_DIFF( DATE({% date_start current_date_range %}), ${created_date}, DAY) + 1
        WHEN ${created_date} between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${period_2_start}, ${created_date}, DAY) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
                THEN 1
                WHEN ${created_date} between ${period_2_start} and ${period_2_end}
                THEN 2
                END
            {% else %}
                NULL
            {% endif %}
            ;;
  }

  ## ------- HIDING FIELDS  FROM ORIGINAL VIEW FILE  -------- ##


  ## ------------------ DIMENSIONS TO PLOT ------------------ ##

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    # sql: DATE_ADD( ${day_in_period} - 1, DATE({% date_start current_date_range %}), DAY) ;;
    sql: DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL (${day_in_period} - 1) DAY)  ;;
    view_label: "_PoP"
    timeframes: [
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
    convert_tz: no
  }


  dimension: period {
    view_label: "_PoP"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
                THEN 'This {% parameter compare_to %}'
                WHEN ${created_date} between ${period_2_start} and ${period_2_end}
                THEN 'Last {% parameter compare_to %}'
                END
            {% else %}
                NULL
            {% endif %}
            ;;
  }

  dimension: sale_price {
    sql: ${TABLE}.sale_price ;;
  }


  ## ---------------------- TO CREATE FILTERED MEASURES ---------------------------- ##

  dimension: period_filtered_measures {
    hidden: yes
    description: "We just use this for the filtered measures"
    type: string
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${created_raw} {% endcondition %} THEN 'this'
                WHEN ${created_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
            {% else %} NULL {% endif %} ;;
  }

  # Filtered measures

  measure: current_period_sales {
    view_label: "_PoP"
    type: sum
    sql: ${sale_price};;
    filters: [period_filtered_measures: "this"]
  }

  measure: previous_period_sales {
    view_label: "_PoP"
    type: sum
    sql: ${sale_price};;
    filters: [period_filtered_measures: "last"]
  }

  measure: sales_pop_change {
    view_label: "_PoP"
    label: "Total Sales period-over-period % change"
    type: number
    sql: CASE WHEN ${current_period_sales} = 0
                THEN NULL
                ELSE (1.0 * ${current_period_sales} / NULLIF(${previous_period_sales} ,0)) - 1 END ;;
    value_format_name: percent_2
  }

  # measure: current_period_count_users {
  #   view_label: "_PoP"
  #   type: count_distinct
  #   sql: ${user_id};;
  #   filters: [period_filtered_measures: "this"]
  # }

  # measure: previous_period_count_users {
  #   view_label: "_PoP"
  #   type: count_distinct
  #   sql: ${user_id};;
  #   filters: [period_filtered_measures: "last"]
  # }

#####
### WTD, MTD and YTD filters

  parameter: to_date_selection {
    label: "Display only Period to Date"
    view_label: "_PoP"
    type: unquoted
    default_value: "No"
    allowed_value: {
      label: "WTD_Only"
      value:"WTD"
    }
    allowed_value: {
      label: "MTD_Only"
      value:"MTD"
    }
    allowed_value: {
      label: "YTD_Only"
      value:"YTD"
    }
    allowed_value: {
      label:"Display all Dates"
      value:"No"
    }
  }


  parameter: YTD_selection {
    label: "Display only Year to Date"
    view_label: "_PoP"
    type: unquoted
    default_value: "No"
    allowed_value: {
      label: "YTD_Only"
      value:"YTD"
    }
    allowed_value: {
      label:"Display all Dates"
      value:"No"
    }
  }

  parameter: MTD_selection {
    label: "Display only Month to Date"
    view_label: "_PoP"
    type: unquoted
    default_value: "No"
    allowed_value: {
      label: "MTD_Only"
      value:"MTD"
    }
    allowed_value: {
      label:"Display all Dates"
      value:"No"
    }
  }

  parameter: WTD_selection {
    label: "Display only Week to Date"
    view_label: "_PoP"
    type: unquoted
    default_value: "No"
    allowed_value: {
      label: "WTD_Only"
      value:"WTD"
    }
    allowed_value: {
      label:"Display all Dates"
      value:"No"
    }
  }


  dimension: to_date {
    group_label: "To-Date Filters"
    label: "1. To-Date"
    view_label: "_PoP"
    type: yesno
    sql:
      {% if to_date_selection._parameter_value == 'WTD' %}
        ${wtd_only}
      {% elsif to_date_selection._parameter_value == 'MTD' %}
        ${mtd_only}
      {% elsif to_date_selection._parameter_value == 'YTD' %}
        ${ytd_only}
      {% else %}
        1 = 1
      {% endif %};;
  }

  dimension: year_to_date {
    group_label: "To-Date Filters"
    label: "Year-To-Date"
    view_label: "_PoP"
    type: yesno
    sql:
      {% if YTD_selection._parameter_value == 'YTD' %}
        ${ytd_only}
      {% else %}
        1 = 1
      {% endif %};;
  }

  dimension: month_to_date {
    group_label: "To-Date Filters"
    label: "Month-To-Date"
    view_label: "_PoP"
    type: yesno
    sql:
      {% if MTD_selection._parameter_value == 'MTD' %}
        ${mtd_only}
      {% else %}
        1 = 1
      {% endif %};;
  }

  dimension: week_to_date {
    group_label: "To-Date Filters"
    label: "Week-To-Date"
    view_label: "_PoP"
    type: yesno
    sql:
      {% if YTD_selection._parameter_value == 'WTD' %}
        ${wtd_only}
      {% else %}
        1 = 1
      {% endif %};;
  }




### - BIGQUERY {




  dimension: wtd_only {
    group_label: "To-Date Filters"
    label: "WTD"
    view_label: "_PoP"
    hidden: yes
    type: yesno
    sql:  (EXTRACT(DAYOFWEEK FROM ${created_raw}) < EXTRACT(DAYOFWEEK FROM CURRENT_DATE())
                  OR
              (EXTRACT(DAYOFWEEK FROM ${created_raw}) = EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM CURRENT_TIME()))
                  OR
              (EXTRACT(DAYOFWEEK FROM ${created_raw}) = EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM CURRENT_TIME()) AND
              EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM CURRENT_TIME())))  ;;
  }

  dimension: mtd_only {
    group_label: "To-Date Filters"
    label: "MTD"
    view_label: "_PoP"
    hidden: yes
    type: yesno
    sql:  (EXTRACT(DAY FROM ${created_raw}) < EXTRACT(DAY FROM CURRENT_DATE())
                  OR
              (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM CURRENT_TIME()))
                  OR
              (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM CURRENT_TIME()) AND
              EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM CURRENT_TIME())))  ;;
  }

  dimension: ytd_only {
    group_label: "To-Date Filters"
    label: "YTD"
    view_label: "_PoP"
    hidden: yes
    type: yesno
    sql:  (EXTRACT(DAYOFYEAR FROM ${created_raw}) < EXTRACT(DAYOFYEAR FROM CURRENT_DATE())
                  OR
              (EXTRACT(DAYOFYEAR FROM ${created_raw}) = EXTRACT(DAYOFYEAR FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM CURRENT_TIME()))
                  OR
              (EXTRACT(DAYOFYEAR FROM ${created_raw}) = EXTRACT(DAYOFYEAR FROM CURRENT_DATE()) AND
              EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM CURRENT_TIME()) AND
              EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM CURRENT_TIME())))  ;;
  }

}
