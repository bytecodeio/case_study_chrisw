include: "/views/order_items.view.lkml"
view: pop2 {
  ### Create a calendar table or use a view to build a date field for the view ###
  derived_table: {
    sql: SELECT date_array FROM UNNEST(GENERATE_DATE_ARRAY('2016-10-05', CURRENT_DATE(),
                                INTERVAL 1 DAY)) AS date_array;;
 }
  dimension_group: date_array {
    type:time
    #datatype: date
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      day_of_month,
      quarter,
      year
    ]
    sql: TIMESTAMP(${TABLE}.date_array) ;;
  }


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
        WHEN {% condition current_date_range %} ${date_array_raw} {% endcondition %}
        THEN DATE_DIFF( DATE({% date_start current_date_range %}), DATE(${date_array_date}), DAY) + 1
        WHEN DATE(${date_array_date}) between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${period_2_start}, DATE(${date_array_date}), DAY) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }


  # {% if current_date_range._is_filtered %}
  #       CASE
  #       WHEN {% condition current_date_range %} ${calendardate_raw} {% endcondition %}
  #       THEN DATE_DIFF(DATE(${calendardate_date}),DATE({% date_start current_date_range %}), DAY) +1
  #       WHEN ${calendardate_date} between ${period_2_start} and ${period_2_end}
  #       THEN DATE_DIFF(DATE(${calendardate_date}),DATE(${period_2_start}), DAY) +1
  #       END
  #   {% else %} NULL
  #   {% endif %}

  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${date_array_raw} {% endcondition %}
                THEN 1
                WHEN ${date_array_date} between ${period_2_start} and ${period_2_end}
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
                WHEN {% condition current_date_range %} ${date_array_raw} {% endcondition %}
                THEN 'This {% parameter compare_to %}'
                WHEN ${date_array_date} between ${period_2_start} and ${period_2_end}
                THEN 'Last {% parameter compare_to %}'
                END
            {% else %}
                NULL
            {% endif %}
            ;;
  }

  # dimension: sale_price {
  #   sql: order_items.sale_price ;;
  # }


  ## ---------------------- TO CREATE FILTERED MEASURES ---------------------------- ##

  dimension: period_filtered_measures {
    hidden: yes
    description: "We just use this for the filtered measures"
    type: string
    sql:
            {% if current_date_range._is_filtered %}
                CASE
                WHEN {% condition current_date_range %} ${date_array_raw} {% endcondition %} THEN 'this'
                WHEN ${date_array_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
            {% else %} NULL {% endif %} ;;
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

}
