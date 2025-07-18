## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(qryflow)

## ----example------------------------------------------------------------------
library(qryflow)

# Connection to In-Memory DB with table populated from mtcars
con <- example_db_connect(mtcars)

sql <- "
-- @exec: drop_cyl_6
DROP TABLE IF EXISTS cyl_6;

-- @exec: prep_cyl_6
CREATE TABLE cyl_6 AS
SELECT *
FROM mtcars
WHERE cyl = 6;

-- @query: df_mtcars
SELECT *
FROM mtcars;

-- @query: df_cyl_6
SELECT *
FROM cyl_6;
"

# Pass tagged SQL to `qryflow`
results <- qryflow(sql, con)

# Access the results from the chunk named `df_cyl_6`
head(results$df_cyl_6)

## -----------------------------------------------------------------------------
library(qryflow)

# Connection to In-Memory DB with table populated from mtcars
con <- example_db_connect(mtcars)

sql <- "
-- @query: df_mtcars
SELECT *
FROM mtcars;
"

# Pass tagged SQL to `qryflow`
results <- qryflow(sql, con)

# Access the results from the chunk named `df_cyl_6`
# results$df_cyl_6
head(results)

## ----echo=FALSE, include=FALSE------------------------------------------------
DBI::dbDisconnect(con)

