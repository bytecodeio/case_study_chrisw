view: validation_order_item_status {
  derived_table: {
    sql:
    SELECT order_id, COUNT(DISTINCT t0.status) AS distinct_status_count
    FROM `order_items` AS t0
    LEFT JOIN `inventory_items` AS t1
    ON t0.inventory_item_id = t1.id
    GROUP BY order_id ;;
  }
  dimension: order_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: distinct_status_count {
    type: number
    sql: ${TABLE}.distinct_status_count ;;
  }
}
