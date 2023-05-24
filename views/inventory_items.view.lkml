# The name of this view in Looker is "Inventory Items"
view: inventory_items {
  sql_table_name: `looker-partners.thelook.inventory_items` ;;
  # dimensions
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  # measures
  measure: average_cost {
    type: average
    sql: ${cost} ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost};;
    value_format_name: usd
  }
}
