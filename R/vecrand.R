do_it <- FALSE

##' 1. worst-case scenario
f1 <- function(n1=1000,n2=1000) {
    res <- c()              ## define result structure
    for (i in 1:n1) {
        x <- c()            ## define sub-result
        for (j in 1:n2) {
            x <- c(x,rnorm(1))  ## grow sub-result
        }
        res <- c(res,mean(x))   ## grow result
    }
    return(res)
}
if (do_it) system.time(f1())

##' 2. pre-allocate but double loop
##' 
f2 <- function(n1=1000,n2=1000) {
    res <- numeric(n1)   ## preallocate result
    for (i in 1:n1) {
        x <- numeric(n2) ## preallocate sub-result
        for (j in 1:n2) {
            x[j] <- rnorm(1)  ## fill in sub-result
        }
        res[i] <- mean(x)     ## fill in result
    }
    return(res)
}
if (do_it) system.time(f2())

##' single for-loop
f3 <- function(n1=1000,n2=1000) {
    res <- numeric(n1)
    for (i in 1:n1) {
        res[i] <- mean(rnorm(n2))
    }
    return(res)
}
if (do_it) system.time(f3())

##' matrix/vectorized
f4 <- function(n1=1000,n2=1000) {
    res <- matrix(rnorm(n1*n2),nrow=n1)
    return(rowMeans(res))
}
if (do_it) system.time(f4())

##'
if (do_it) {
    library(rbenchmark)
    benchmark(loops=f3(500,500),matrix=f4(500,500))

    ##' batch run ...
    dfile <- "../data/vecrand.rds"
    if (!file.exists(dfile)) {
        set.seed(101)
        nn1 <- 7
        nn2 <- 7
        nrep <- 50
        n1vec <- round(10^(seq(2,log10(5e3),length.out=nn1)))
        n2vec <- round(10^(seq(2,log10(5e3),length.out=nn2)))
        res <- array(NA,dim=c(2,length(n1vec),length(n2vec),nrep),
                     dimnames=list(method=c("loop","matrix"),
                                   n1=n1vec,n2=n2vec,rep=1:nrep))
        for (i in seq_along(n1vec)) {
            n1 <- n1vec[i]
            for (j in seq_along(n2vec)) {
                n2 <- n2vec[j]
                cat(n1,n2,"\n")
                for (k in 1:nrep) {
                    res["loop",i,j,k] <-
                        system.time(f3(n1,n2))["elapsed"]
                    res["matrix",i,j,k] <-
                        system.time(f4(n1,n2))["elapsed"]
                }
                saveRDS(res,dfile)
            }
        }
    }

##'

    res <- readRDS(dfile)
    res2 <- reshape2::melt(res)
    library(ggplot2); theme_set(theme_bw())
    library(viridis)
    ggplot(res2,aes(x=n1,y=value,col=factor(n2)))+
        stat_summary(fun.data=mean_cl_normal,aes(shape=method))+
        stat_summary(fun.y=mean,geom="line",aes(linetype=method))+
        scale_x_log10(breaks=c(100,500,1000,5000))+
        scale_y_log10(breaks=c(0.01,0.1,1,10))+
        scale_colour_brewer(palette="Dark2",name="vector length")+
        labs(x="# vectors",y="mean time (s)")

    ## ggplot(res2,aes(x=method,y=value,colour=factor(n1),size=factor(n2)))+
    ## stat_summary(fun.y=mean,geom="line",aes(group=interaction(n1,n2)),
    ## alpha=0.4)+
    ## scale_y_log10()+
    ## scale_colour_brewer(palette="Dark2",name="vector length")+
    ## labs(x="method",y="mean time (s)")

ggsave("../pix/vecrand.png",width=4,height=4)

## wireframe? viridis?

}
