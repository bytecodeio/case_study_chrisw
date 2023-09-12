view: time_table {
  derived_table: {
    sql:
      SELECT *
      FROM UNNEST(GENERATE_TIMESTAMP_ARRAY(CURRENT_TIMESTAMP(),DATE_ADD(CURRENT_TIMESTAMP(),INTERVAL 1 DAY),INTERVAL 1 MINUTE)) AS ts
    ;;
  }
  dimension_group: ts {
    type: time
    timeframes: [date, hour, minute, second]
    sql: ${TABLE}.ts ;;
  }

  measure: count {
    type: count
  }
}
