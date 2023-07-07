view: test_top_10_simple_item_names {
  view_label: "Top 10s"
  derived_table: {
    explore_source: order_items {
      column: total_sale_price { field: order_items.total_sale_price }
      column: item_name { field: products.item_name }
      derived_column: rank { sql: RANK() OVER (ORDER BY total_sale_price DESC) ;;}
      bind_all_filters: yes
      sort: { field: total_sale_price desc: yes}
      timezone: "query_timezone"
      limit: 10
    }
  }
  dimension: item_name { group_label: "Simple Example"  }
  dimension: rank { type: number group_label: "Simple Example" }
  dimension: item_name_ranked {
    group_label: "Simple Example"
    order_by_field: rank
    type: string
    sql: ${rank} || ') ' || ${item_name} ;;
  }
  }
