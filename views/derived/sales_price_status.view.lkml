view: sales_price_status {
    derived_table: {
      explore_source: order_items {
        column: status {}
        column: total_sale_price {}
      }
    }
    dimension: status {
      description: ""
    }
    dimension: total_sale_price {
      description: ""
      value_format: "$#,##0.00"
      type: number
    }
  }
