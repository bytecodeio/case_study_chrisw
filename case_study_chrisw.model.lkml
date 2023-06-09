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
include: "/views/derived/order_item_facts.view.lkml"


explore: product_facts {}



##################################
########### Explores #############
##################################
include: "/explores/customers.explore.lkml"
include: "/explores/order_items.explore.lkml"
include: "/views/pop.view.lkml"

named_value_format: usd_in_millions {
  value_format: "$0.000,,\" M\""
}
named_value_format: phone_number {
  value_format: "(###) ###-####"
}
