# compstatsR

A repository for comp-stats-in-R sessions, McMaster University

## Topics

- **session 1**: Basic principles for writing better, faster R code. Low-hanging fruit: performance optimization through vectorization, pre-allocation, compilation, etc.. Profiling. [HTML](session1.html)
- **session 2**: Basics of distributed and parallel computation (`parallel`, `foreach` packages)
- **session 3**: Interfacing R with higher-performance languages, specifically introduction to Rcpp (`Rcpp`: touch on `RcppEigen`, `RcppArmadillo`).
- **extra/other**
   - tips for numerical minimization (`optim`, `nloptr` etc.)
   - tools for data processing (tidyverse, `data.table`, ...)
   - batch processing
       - organization (array vs long format)
	   - checkpointing
	   - graphical presentation of simulations
- **probably not this time**
   - revision control/Github?
   - R packaging?

## References


- blog posts by Noam Ross and others
- the *R Inferno*
- Visser et al *PLoS Computational Biology* 2016
- [*Efficient R Programming*](https://csgillespie.github.io/efficientR/), Gillespie and Lovelace
- [BibTex file](compstatsR.bib)

This material is licensed as CC-BY-SA (attribution, share-alike).
