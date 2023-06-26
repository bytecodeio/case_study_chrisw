##################################
########### Connection ###########
##################################
connection: "looker_partner_demo"
access_grant: sales_access {
  user_attribute: case_study_department
  allowed_values: [ "sales", "executive" ]
}

##################################
########### Views ################
##################################
include: "/views/distribution_centers.view.lkml"
include: "/views/events.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/users.view.lkml"
include: "/views/crossviews/x_users_customer_order_sequence.view.lkml"
include: "/views/derived/customer_order_facts.view.lkml"
include: "/views/derived/order_sequence.view.lkml"
include: "/views/derived/customer_order_sequence.view.lkml"
include: "/views/derived/order_facts.view.lkml"
include: "/views/derived/product_facts.view.lkml"

explore: product_facts {}


##################################
########### Explores #############
##################################
include: "/explores/customers.explore.lkml"
include: "/explores/order_items.explore.lkml"
include: "/views/pop.view.lkml"
include: "/views/pop2.view.lkml"


explore: pop2 {}

explore: pop {
  label: "PoP Method 3: Custom choice of current and previous periods with parameters"
  always_filter: {
    filters: [current_date_range: "6 months", compare_to: "Year" ]
  }
  # join: users {
  #   type: left_outer
  #   sql_on: ${pop.user_id} = ${users.id} ;;
  #   relationship: one_to_one
  # }
}


named_value_format: usd_in_millions {
  value_format: "$0.000,,\" M\""
}
named_value_format: phone_number {
  value_format: "(###) ###-####"
}
