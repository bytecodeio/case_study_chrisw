# define connection
connection: "looker_partner_demo"

# define views
include: "/views/distribution_centers.view.lkml"
include: "/views/events.view.lkml"
include: "/views/inventory_items.view.lkml"
include: "/views/order_items.view.lkml"
include: "/views/products.view.lkml"
include: "/views/users.view.lkml"
include: "/views/derived/sales_price_status.view.lkml"
include: "/views/derived/sales_price_status_sql.view.lkml"
explore:  sales_price_status{}
explore:  sales_price_status_sql{}
# define explores
include: "/explores/order_items.explore.lkml"
include: "/explores/customers.explore.lkml"
