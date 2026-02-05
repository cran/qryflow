## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
library(qryflow)

## -----------------------------------------------------------------------------
con <- example_db_connect(mtcars)
path <- example_sql_path("mtcars.sql")

obj <- qryflow_run(con, path)

# A qryflow_result object
class(obj)
names(obj)

# Each element is a qryflow_chunk
class(obj$df_mtcars)

## -----------------------------------------------------------------------------
results <- qryflow_results(obj)
head(results$df_mtcars)

## -----------------------------------------------------------------------------
workflow <- qryflow_parse(path)

class(workflow)
length(workflow$chunks)
workflow$chunks[[1]]

## -----------------------------------------------------------------------------
executed <- qryflow_execute(con, workflow, source = "mtcars.sql")
class(executed)
names(executed)

## -----------------------------------------------------------------------------
head(executed$df_mtcars$results)
executed$df_mtcars$tags
executed$meta$timings
executed$meta$source

## -----------------------------------------------------------------------------
summary(executed)

## ----echo=FALSE, include=FALSE------------------------------------------------
DBI::dbDisconnect(con)

