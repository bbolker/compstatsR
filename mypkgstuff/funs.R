
hello_world <- function() {
    print("hello world")
}

more_complex <- function(a=1:10) {
    mean(a)
}

library(emdbook)
finalsize <- function(R0) {
    1+1/R0*lambertW(-R0*exp(-R0))
}

library(Rcpp)
sourceCpp("funs.cpp")

hello_world()
helloC()
