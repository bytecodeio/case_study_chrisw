# The name of this view in Looker is "Events"
view: events {
  sql_table_name: `looker-partners.thelook.events`
    ;;
  drill_fields: [id]

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_num,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: since_signup_and_site_visit {
    type: duration
    sql_start: ${customers.created_raw};;
    sql_end: ${created_raw};;
    intervals: [day,week,month,year]
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: average_sequence_number {
    type: average
    sql: ${sequence_number} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.id, users.first_name]
  }

  measure: total_sequence_number {
    type: sum
    sql: ${sequence_number} ;;
  }

  measure: website_visits {
    label: "Website Visits"
    type: count_distinct
    sql: ${session_id} ;;
    link: {
      label: "Website Usage Dashboard"
      url: "https://looker.bytecode.io/dashboards/C3Ou0XHYL6WOPz4NEZmZjB"
  }
  }
}
