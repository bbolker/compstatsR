# compstatsR

A repository for comp-stats-in-R sessions, McMaster University

Three or four sessions during the weekly stats seminar (3:30-5 PM
Tuesdays starting October 18 in
[ABB 165](https://www.mcmaster.ca/uts/maps/anbsb1.html) ([Google maps](https://goo.gl/maps/2M78izxchZP2)). Target
audience: Master's students in statistics

## Brain dump/topics

- **session 1** (18 Oct): profiling; basic R performance optimization (vectorization; pre-allocation; R compilation; improved BLAS)
- **session 2** (1 Nov): basics of distributed/parallel computation (`parallel`, `foreach` packages)
- **session 3** (8 Nov): intro to Rcpp (`Rcpp`: touch on `RcppEigen`, `RcppArmadillo`)
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
- **session 4** (15 Nov): TBD. Work/practice session?

## References


- blog posts by Noam Ross and others
- the *R Inferno*
- Visser et al *PLoS Computational Biology* 2016
- [*Efficient R Programming*](https://csgillespie.github.io/efficientR/), Gillespie and Lovelace
- [BibTex file](compstatsR.bib)
- [blog post on installing stuff](http://thecoatlessprofessor.com/programming/rcpp-rcpparmadillo-and-os-x-mavericks-lgfortran-and-lquadmath-error/)

This material is licensed as CC-BY-SA (attribution, share-alike).
