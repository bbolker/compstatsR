#include <Rcpp.h>

using namespace Rcpp;

//[[Rcpp::export]]
NumericMatrix Cgibbs(int n, int thin) {
  RNGScope scope;
  
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

