# The name of this view in Looker is "Inventory Items"
view: inventory_items {
  sql_table_name: `looker-partners.thelook.inventory_items` ;;

  ##################################
  ########### Dimensions ###########
  ##################################

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    drill_fields: [product_category,product_name,product_id,product_sku]
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
    link: {
      label: "Facebook"
      url: "https://www.facebook.com/{{ value }}"
      icon_url: "http://facebook.com/favicon.ico"
    }
    link: {
      label: "Brand & Product Comparison Dashboard"
      url: "https://looker.bytecode.io/dashboards/bjGrNp9Wt53zCQbXRILK8D?Select+Brands+To+Compare={{ value }}&&Select+A+Product+Category=&Select+A+Measure=total%5E_gross%5E_revenue"
    }
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
    drill_fields: [product_brand,product_name,product_id,product_sku]
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  ################################
  ########### Measures ###########
  ################################

  measure: average_cost {
    type: average
    sql: ${cost} ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost};;
    value_format_name: usd
  }

  ##################################
  ########### Hidden ###############
  ##################################

  #### Peer Comparison Code ####
  filter: brand_select {
    suggest_dimension: product_brand
  }

  filter: product_category_select {
    suggest_dimension: product_category
  }

  dimension: brand_comparitor {
    type: string
    sql:
      CASE
        WHEN {% condition brand_select %} ${product_brand} {% endcondition %}
          THEN ${product_brand}
        ELSE 'All Other Brands'
      END
    ;;
    order_by_field: brand_select_order
  }

  dimension: product_category_comparitor {
    type: string
    sql:
      CASE
        WHEN {% condition product_category_select %} ${product_category} {% endcondition %}
          THEN ${product_category}
        ELSE 'All Other Categories'
      END
    ;;
  }

  dimension: brand_select_order {
    hidden: yes
    type: number
    sql: CASE WHEN ${brand_comparitor} = 'All Other Brands' THEN 999999
              ELSE 0
              END ;;
  }

  dimension: product_category_select_order {
    hidden: yes
    type: number
    sql: CASE WHEN ${product_category_comparitor} = 'All Other Categories' THEN 999999
              ELSE 0
              END ;;
  }

}
