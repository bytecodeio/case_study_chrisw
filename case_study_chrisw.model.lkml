##################################
########### Connection ###########
##################################
connection: "looker_partner_demo"

##################################
########### Views ################
##################################
include: "/views/distribution_centers.view.lkml"
include: "/views/events.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/users.view.lkml"

##################################
########### Explores #############
##################################
include: "/explores/order_items.explore.lkml"
include: "/explores/customers.explore.lkml"
include: "/explores/validation_order_item_status.explore.lkml"
