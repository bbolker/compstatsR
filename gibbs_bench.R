library(Rcpp)
library(rbenchmark)

cppFunction("
  NumericMatrix Cgibbs(int n, int thin) {
  double x=0, y=0;
  NumericMatrix mat(n, 2);
  colnames(mat) = CharacterVector::create('x', 'y');
  for (int i=0; i<n; i++) {
    for (int j=0; j<thin; j++) {
      x = ::Rf_rgamma(3.0, 1.0/(y*y+4));
      y = ::Rf_rnorm(1.0/(x+1),1.0/sqrt(2*x+2));
    }
    mat(i,0) = x;
    mat(i,1) = y;
  }
  return mat;
}
")

Rgibbs <- function(N,thin) {
  mat <- matrix(0,ncol=2,nrow=N)
  dimnames(mat) <- list(NULL, c("x", "y"))
  x <- 0
  y <- 0
  for (i in 1:N) {
    for (j in 1:thin) {
      x <- rgamma(1,3,y*y+4)
      y <- rnorm(1,1/(x+1),1/sqrt(2*(x+1)))
    }
    mat[i,] <- c(x,y)
  }
  mat
}

set.seed(101)
x1 <- Cgibbs(5e4*10, 10)
set.seed(101)
x2 <- Rgibbs(5e4*10, 10)
stopifnot(identical(x1, x2))

bb <- bench::mark(Cgibbs(5e4*10,10),
                  Rgibbs(5e4*10,10),
                  check = FALSE)

## takes about 20 minutes (100 replications)
bb2 <- benchmark(Rcpp = Cgibbs(5e4*10,10),
                 R = Rgibbs(5e4*10,10))
