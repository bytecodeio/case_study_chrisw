view: users {
  sql_table_name: `looker-partners.thelook.users` ;;

  ##################################
  ########### Dimensions ###########
  ##################################

  dimension: age {
    group_label: "Demographics"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_group {
    group_label: "Demographics"
    group_item_label: "Age Range"
    type: tier
    tiers: [15,26,36,51,66]
    sql: ${age} ;;
    style: integer
  }

  dimension: city {
    group_label: "Shipping Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Shipping Location"
    group_item_label: "Country"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: since_signup {
    type: duration
    sql_start: ${created_raw};;
    sql_end: CURRENT_TIMESTAMP();;
    intervals: [day]
  }

  dimension: new_user {
    type: yesno
    sql: ${days_since_signup} < 91;;
  }

  dimension: email {
    group_label: "Contact Detail"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    group_label: "Contact Detail"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    group_label: "Demographics"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: last_name {
    group_label: "Contact Detail"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    group_label: "Shipping Location"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Shipping Location"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: lat_lon {
    group_label: "Shipping Location"
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    group_label: "Shipping Location"
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    group_label: "Shipping Location"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    group_label: "Shipping Location"
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [age_group,gender]
  }


  ################################
  ########### Measures ###########
  ################################

  measure: total_age {
    label: "Total age of users"
    group_label: "Age Measures"
    group_item_label: "Total"
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    group_label: "Age Measures"
    group_item_label: "Average"
    type: average
    sql: ${age} ;;
  }

  measure: count_of_users {
    type: count_distinct
    sql: ${id} ;;
  }

  ##################################
  ########### Hidden ###############
  ##################################

  measure: count_of_days_prior_12_months {
    hidden: yes
    type: count_distinct
    sql: ${created_date} ;;
    filters: [created_date: "last 12 months"]
  }

  measure: count_of_new_users_yesterday {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: [created_date: "yesterday"]
  }

  measure: count_of_new_users_prior_12_months {
    hidden: yes
    type: count_distinct
    sql: ${id} ;;
    filters: [created_date: "last 12 months"]
  }

  measure: count_of_users_mtd_cm {
    type: count_distinct
    sql: ${id} ;;
    filters: [created_month: "this month", is_before_mtd: "Yes"]
  }

  measure: count_of_users_mtd_pm {
    type: count_distinct
    sql: ${id} ;;
    filters: [created_month: "last month", is_before_mtd: "Yes"]
  }

  measure: daily_average_count_of_new_users_prior_12_months {
    hidden: yes
    type: number
    sql: ROUND(1.0 * ${count_of_new_users_prior_12_months} / NULLIF(${count_of_days_prior_12_months},0),0) ;;
  }

  dimension: is_before_mtd {
    type: yesno
    sql: ${created_day_of_month} <= EXTRACT(day FROM CURRENT_TIMESTAMP()) ;;
  }

}
