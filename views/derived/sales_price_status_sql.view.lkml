view: sales_price_status_sql {
derived_table: {
  sql: SELECT
    order_items.status  AS status,
    COALESCE(SUM(order_items.sale_price ), 0) AS total_sale_price
FROM `looker-partners.thelook.order_items`  AS order_items
GROUP BY
    1 ;;
}
dimension: status {
  type: string
}

dimension: total_sale_price {
  type: number
}
}
