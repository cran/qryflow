## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(qryflow)

## -----------------------------------------------------------------------------
query_send_parser <- function(x, ...) {

  # Convert to individual lines
  lines <- read_sql_lines(x)

  all_tags <- extract_all_tags(lines)

  # Check for explicit name
  name <- all_tags$name

  if (is.null(name)) {
    # Accomodate Aliased Approach
    name <- all_tags[["query-send"]]
  }

  other_tags <- subset_tags(all_tags, c("query-send", "name", "type"), negate = TRUE)

  sql_txt <- paste0(lines[!is_tag_line(lines)], collapse = "\n")

  new_qryflow_chunk(type = "query-send", name = name, sql = sql_txt, tags = other_tags)

}

query_send_handler <- function(chunk, con, ...){
  res <- DBI::dbSendQuery(con, chunk$sql, ...)

  results <- DBI::dbFetch(res)
  
  DBI::dbClearResult(res)
  
  results
}

## -----------------------------------------------------------------------------
register_qryflow_type(
  "query-send",
  parser = query_send_parser,
  handler = query_send_handler,
  overwrite = TRUE
)

## -----------------------------------------------------------------------------
ls_qryflow_types()

## -----------------------------------------------------------------------------
# Creates an in-memory sqlite database and populates it with an mtcars table, named "mtcars" 
con <- example_db_connect(mtcars)

# Create 
sql <- "
-- @query-send: df_mtcars
SELECT *
FROM mtcars;
"

results <- qryflow(sql, con)

head(results)

## ----echo=FALSE, include=FALSE------------------------------------------------
DBI::dbDisconnect(con)

