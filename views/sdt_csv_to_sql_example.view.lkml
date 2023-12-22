view: sdt_csv_to_sql_example {
  derived_table: {
    sql:
    SELECT
      'a' AS col1, 'x' AS col2, 1 AS col3
    UNION ALL
    SELECT
      'b' AS col1, 'y' AS col2, 2 AS col3
    UNION ALL
    SELECT
      'c' AS col1, 'z' AS col2, 3 AS col3
    UNION ALL
    SELECT
      'd' AS col1, NULL AS col2, NULL AS col3
    ;;
  }
  dimension: col1 {}
  dimension: col2 {}
  dimension: col3 {}
}
