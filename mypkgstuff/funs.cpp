#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void helloC() {
    Rprintf("hello world (from C)!\n");
}
