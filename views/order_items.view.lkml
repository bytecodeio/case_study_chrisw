view: order_items {
  sql_table_name: `looker-partners.thelook.order_items` ;;

  # dimensions
  # ${TABLE}.
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  #hidden
  dimension: inventory_item_id {
    type: string
    sql: ${TABLE}.inventory_item_id ;;
    hidden: yes
  }

  #hidden
  dimension: item_is_returned {
    type: yesno
    sql: ${TABLE}.returned_at IS NOT NULL ;;
    hidden: yes
  }

  #hidden
  dimension: item_is_cancelled {
    type: yesno
    sql: ${TABLE}.shipped_at IS NULL ;;
    hidden: yes
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  #measures
  #total_gross_revenue

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd
  }

  measure: item_return_rate {
    type: number
    description: "The number of items returned / the total number of items sold."
    sql: 1.0 * ${number_of_returned_items} / NULLIF(${total_number_of_items},0) ;;
    value_format_name: percent_2
  }

  measure: number_of_returned_items {
    type: count_distinct
    sql: ${TABLE}.inventory_item_id ;;
    filters: [item_is_returned: "Yes"]
  }

  measure:  total_gross_revenue {
    type: sum
    description: "Total revenue from completed sales (excluding canceled and returned orders)."
    sql: ${sale_price} ;;
    filters: [item_is_returned: "No", item_is_cancelled: "No"]
    value_format_name: usd
  }

  measure: total_number_of_items {
    type: count_distinct
    sql: ${TABLE}.inventory_item_id ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }
}
