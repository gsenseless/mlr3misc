#' @title Invoke a Function Call
#'
#' @description
#' An alternative interface for [do.call()], similar to the deprecated function in \pkg{purrr}.
#' This function tries hard to not evaluate the passed arguments too eagerly which is
#' important when working with large R objects.
#'
#' It is recommended to pass all arguments named in order not to rely on on positional
#' argument matching.
#'
#' @param .f (`function()`)\cr
#'   Function to call.
#' @param ... (`any`)\cr
#'   Additional function arguments passed to `.f`.
#' @param .args (`list()`)\cr
#'   Additional function arguments passed to `.f`, as (named) `list()`.
#'   These arguments will be concatenated to the arguments provided via `...`.
#' @param .opts (named `list()`)\cr
#'   List of options which are set before the `.f` is called.
#'   Options are reset to their previous state afterwards.
#' @param .seed (`integer(1)`)\cr
#'   Random seed to set before invoking the function call.
#'   Gets reset to the previous seed on exit.
#' @export
#' @examples
#' invoke(mean, .args = list(x = 1:10))
#' invoke(mean, na.rm = TRUE, .args = list(1:10))
invoke = function(.f, ..., .args = list(), .opts = list(), .seed = NA_integer_) {
  if (length(.opts)) {
    assert_list(.opts, names = "unique")
    old_opts = options(.opts)
    if (getRversion() < "3.6.0") {
      # fix for resetting some debug options
      # https://github.com/HenrikBengtsson/Wishlist-for-R/issues/88
      nn = intersect(c("warnPartialMatchArgs", "warnPartialMatchAttr", "warnPartialMatchDollar"), names(old_opts))
      nn = nn[map_lgl(old_opts[nn], is.null)]
      old_opts[nn] = FALSE
    }
    on.exit(options(old_opts), add = TRUE)
  }

  if (!is.na(.seed)) {
    prev_seed = get_seed()
    on.exit(assign(".Random.seed", prev_seed, globalenv()), add = TRUE)
    set.seed(.seed)
  }

  call = match.call(expand.dots = FALSE)
  expr = as.call(c(list(call[[2L]]), call$..., .args))
  eval.parent(expr, n = 1L)
}
