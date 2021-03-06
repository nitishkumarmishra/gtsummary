
#' Check that a package is installed, stopping otherwise
#'
#' @param pkg Package required
#' @param fn Calling function from the user perspective
#'
#' @return Returns NULL or not at all.
#'
#' @noRd
#' @keywords internal
#' @author David Hugh-Jones
assert_package <- function(pkg, fn) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(glue::glue(
      "The '{pkg}' package is required for '{fn}'.\n",
      "Install with install.packages('{pkg}')"
    ), call. = FALSE)
  }
}

# converts a character vector into a quotes list separated by a comma, eg 'a', 'b'
quoted_list <- function(x) {
  paste(sQuote(x), collapse = ", ")
}

# used in the as_flextable (and friends) functions for inserting calls
add_expr_after <- function(calls, add_after, expr, new_name = NULL) {
  # checking input
  if (!rlang::is_string(add_after) || !add_after %in% names(calls)) {
    stop(glue("`add_after=` must be one of {quoted_list(names(calls))}"))
  }

  # position to insert, and name of list
  index <- which(names(calls) == add_after)
  new_name <- new_name %||% "user_added"
  new_list <- list(expr) %>% set_names(new_name)

  # insert list
  append(calls, new_list, after = index)
}
