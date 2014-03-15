## Copyright (c) 2013-2014, Marek Gagolewski

microbenchmark2 <- function(..., times=100L, control=list(order='inorder', warmup=10L)) {

   library('microbenchmark')
   library('stringi')
   
   x <- do.call(microbenchmark,
                c(as.list(match.call()[-1]), times=times),
                envir=parent.frame())
   x$time <- microbenchmark:::convert_to_unit(x$time, 's')

   nlev <- nlevels(x$expr)
   n <- length(x$time)/nlev
   res <- data.frame(
      expr        = sapply(split(x$expr, x$expr), function(x) as.character(x)[1]),
      min.time    = sapply(split(x$time, x$expr), min),
      q1.time     = sapply(split(x$time, x$expr), function(x) quantile(x, 0.25)),
      median.time = sapply(split(x$time, x$expr), median),
      q3.time     = sapply(split(x$time, x$expr), function(x) quantile(x, 0.75)),
      max.time    = sapply(split(x$time, x$expr), max),
      n           = rep(n, nlev)
   )
   
   row.names(res) <- NULL
   
   res
}