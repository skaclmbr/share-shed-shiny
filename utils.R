# utility function to use throughout

if (!require(mongolite))
  install.packages("mongolite", repos = "http://cran.us.r-project.org")

# contains user and pass variables
source("config.R")

#############################################################################
# MongoDB
host <- "ac-em1daed-shard-00-01.hq089ra.mongodb.net:27017"
db <- "share-shed"
# other relevant collections include: blocks and ebd_taxonomy

uri <- sprintf(
  paste0(
    "mongodb://%s:%s@%s/%s?authSource=admin&",
    "readPreference=primary&ssl=true"
  ),
  ss_user,
  ss_pass,
  host,
  db
)

# # ## default mongodb database server for testing: works only with `mtcars`
# # con <- mongo(
# #     "users",
# #     url = uri,
# #     options = ssl_options(
# #         weak_cert_validation = T
# #     )
# #     )
# # ## remove any existing rows
# # con$drop()
# # ## check
# # con$count()

# # # add users_base to con
# # create_dummy_users() |>
# #     con$insert()
# # con$count()

# connect to a specific collection (table)
users <- mongo(
  "users",
  url = uri,
  options = ssl_options(
    weak_cert_validation = T
  )
)

# things <- mongo(
#   "things",
#   url <- uri, options <- ssl_options(
#     weak_cert_validation <- T
#   )
# )


##################################################################
## User functions

create_account <- function() {

}

edit_account <- function() {
  
}

log_in <- function() {

}

log_out <- function() {

}

rate_user <- function() {
  # provide rating for the lender (borrower)

}
search_owners <- function() {

}

##################################################################
## functions

request_to_borrow <- function() {
  # request to borrow thing (borrower)

}

check_out_thing <- function() {
  # check out thing to borrower (owner)

}

check_in_thing <- function() {
  # check in thing (owner)

}



list_things <- function() {
  # loaned things (owner)
  # borrowed things (borrower)
  # all things (owner)

}

search_things <- function() {
  # search all things (borrower)

}

get_thing_detail <- function() {

}

rate_thing <- function() {
  # provide a rating for the thing (borrower)

}

add_thing <- function() {
  # add thing to library (owner)

}

guess_img_tags <- function() {
  # uses google ai to generate thing descriptors


}

edit_thing <- function() {

}

delete_thing <- function() {

}

give_thing <- function() {
  # allow owner to give to someone else

}