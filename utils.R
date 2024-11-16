# utility function to use throughout

if (!require(mongolite))
  install.packages("mongolite", repos = "http://cran.us.r-project.org")

# contains user and pass variables
source("config.R")

#############################################################################
# MongoDB
# host <- "cluster0-shard-00-00.rzpx8.mongodb.net:27017"
# host <- "cluster0.hq089ra.mongodb.net:27017"
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