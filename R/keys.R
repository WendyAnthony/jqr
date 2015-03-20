#' Operations on keys, or by keys
#'
#' \code{keys} takes no input, and retrieves keys. \code{del} deletes provided keys.
#' \code{haskey} checks if a json string has a key or keys.
#'
#' @export
#' @template args
#' @examples \dontrun{
#' # get keys
#' str <- '{"foo": 5, "bar": 7}'
#' jqr(str, "keys")
#' str %>% keys() %>% jq
#'
#' # delete by key name
#' jqr(str, "del(.bar)")
#' str %>% del(bar) %>% jq
#'
#' # check for key existence
#' str3 <- '[[0,1], ["a","b","c"]]'
#' jqr(str3, "map(has(2))")
#' str3 %>% haskey(2) %>% jq
#' jqr(str3, "map(has(1,2))")
#' str3 %>% haskey(1,2) %>% jq
#' }
keys <- function(.data) {
  dots <- comb(tryargs(.data), structure("keys", type="keys"))
  structure(list(data=.data, args=dots), class="jqr")
}

#' @export
#' @rdname keys
del <- function(.data, ...) {
  del_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname keys
del_ <- function(.data, ..., .dots) {
  tmp <- lazyeval::all_dots(.dots, ...)
  z <- paste0("del(.", tmp[[1]]$expr, ")", collapse = "")
  dots <- comb(tryargs(.data), structure(z, type="del"))
  structure(list(data=getdata(.data), args=dots), class="jqr")
}

#' @export
#' @rdname keys
haskey <- function(.data, ...) {
  haskey_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname keys
haskey_ <- function(.data, ..., .dots) {
  tmp <- lazyeval::all_dots(.dots, ...)
  z <- paste0("map(has(", paste0(unlist(pluck(tmp, "expr")), collapse = ","), "))", collapse = "")
  dots <- comb(tryargs(.data), structure(z, type="del"))
  structure(list(data=getdata(.data), args=dots), class="jqr")
}