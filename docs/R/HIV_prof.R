library(profvis)
source("hivFuns.R")
source("simFuns.R")
source("hivModels.R")
source("Param.R")
library(rbenchmark)
library(deSolve)

HIVpars <- as.HIVvirparlist(ltab[1,])
yini <- calc_yini(HIVpars)
val_vec <- 4.40185
HIVpars_adj <- as.HIVvirparlist(transform(HIVpars, scale_all = val_vec))
maxt <- 100
system.time(r2 <- lsoda(unlist(yini), func = gfun(HIVpars_adj),
                        parms = HIVpars_adj, times = tvec[tvec<maxt]))

ff <- gfun(HIVpars_adj,experimental=TRUE)
profvis(
    lsoda(unlist(yini), func = ff,
          parms = HIVpars_adj, times = tvec[tvec<maxt])
    )

profvis({
    lsoda(unlist(yini), func = ff,
          parms = HIVpars_adj, times = tvec[tvec<maxt])
}, height="250px")

g0 <- gfun(HIVpars_adj)
g0X <- gfun(HIVpars_adj,experimental=TRUE)
all.equal(g0(0,unlist(yini),HIVpars_adj),
          g0X(0,unlist(yini),HIVpars_adj))

## so far tweaking only helps a little

benchmark(g0=g0(0,unlist(yini),HIVpars_adj),
          g0X=g0X(0,unlist(yini),HIVpars_adj),
          replications=2000)         

## test performance
set.seed(101)
m <- matrix(rnorm(1e6),1000)
n <- rnorm(1e3)
f1 <- function() sweep(m,2,n,"*")
f2 <- function() t(t(m)*n)
f3 <- function() m*rep(n,each=nrow(m))
f4 <- function() sweep(m,2,n,"*",check.margin=FALSE)
all.equal(f1(),f2())
all.equal(f1(),f3())
all.equal(f1(),f4())
benchmark(f1(),f2(),f3(),f4(),replications=500)
## checking margins doesn't take any time

## further thoughts for speedup:
##  - optimized BLAS (see below)
##  - write in Rcpp/C code?
##  - skip computing summary stats along the way, compute them from the
##      output

## from the R MacOS FAQ:
##  using CRAN binary?
##
## cd /Library/Frameworks/R.framework/Resources/lib
     
  ##    # for vecLib use
  ##    ln -sf libRblas.vecLib.dylib libRblas.dylib
     
  ##    # for R reference BLAS use
  ##    ln -sf libRblas.0.dylib libRblas.dylib
