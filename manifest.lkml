project_name: "case_study_chrisw"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }


constant: lastmonth_lastyear {
  value: "
  {% assign month = \"now\" | date: \"%b\" %}
  {% assign year = \"now\" | date: \"%Y\"| minus: 1 %}
  "
}
