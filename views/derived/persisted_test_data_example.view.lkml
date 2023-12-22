view: persisted_test_data_example {
  derived_table: {
    persist_for: "8760 hours"
    sql:
      SELECT *
      FROM `looker-partners.thelook.users`
      ORDER BY RAND()
      LIMIT 100
    ;;
  }

  dimension: first_name {
    group_label: "Contact Detail"
    type: string
    sql: ${TABLE}.first_name ;;
  }
}
