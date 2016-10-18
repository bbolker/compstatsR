##' EM algorithm for fitting ZIP mixed-effects model
##'
##'   y is the observation from the distribution:
##'           P(Y=0)=p+(1-p)F(0,lambda)
##'           P(Y=k)=(1-p)F(k,lambda).
##' 2011.3.14 modified from Mihoko's GAMZINB to run ZIP mixed-effect model
##' @param data data frame containing response and predictor variables
##' @param formlog formula for logistic regression. left side should be: \code{z~}
##' @param formpoi formula for Poisson or NB regression. left side should be: y~
##' @param maxitr maximum number of iterations
zipme <- function(cformula, zformula, cfamily=poisson,
                  data, maxitr=20, tol=1e-6, verbose=TRUE) {
                                        # number of observations
    m <- nrow(data)
    rname <- as.character(cformula)[2]

    ## initialize z and probz (z=1 -> perfect state; probz is probability of 0 in imperfect state for poisson)
    
    z <- numeric(m)
    probz <- numeric(m)
    z[data[[rname]]==0] <-  1/(1+exp(-1))  ## starting value

    ## n.b. we are looking for [3] since zformula has a LHS
    randz <- length(grep("\\(.*\\|.*\\)",as.character(zformula)[3]))>0
    ## delta is used to gauge convergence. after initialization, it is the abs. difference between current z and new z.    
    itr <- 1
    delta <- 2
    deltainfo <- numeric(maxitr)
    while(delta>tol & itr <= maxitr){
        if (verbose) cat("itr:",itr,"\n")
        ## make (update) working data frame
        bydataw <- data.frame(z=z,data)
        ##
        ## Maximization 1: logistic
        old.z <- z
        if (randz) {
            uu <- glmer(zformula, family=binomial, data=bydataw)
        } else {
            ## suppress warnings 
            uu <- suppressWarnings(glm(zformula, family=binomial, data=bydataw))
        }
        ## save current logistic model output
        u <- fitted(uu)
        ##
        ## Maximization 2: poisson loglinear with weights
        vv <- glmer(cformula, family=cfamily, weights=(1-z), data=bydataw)   
        ## save Poisson model output
        v <- fitted(vv)
        ##
        ## Expectation: used to update z with conditional expectation;only need to update at y=0.
        zdat <- data[[rname]]==0
        z[zdat] <- u[zdat]/( u[zdat]+(1-u[zdat])*exp(-v[zdat]))
        new.z <- z
        ## updated convergence indicator
        delta <- max(abs(old.z-new.z))
        ## save delta for this iteration; to be output
        deltainfo[itr] <- delta
        itr <- itr+1
    }            
    L <- list("zfit"=uu, "cfit"=vv, itr=itr, deltainfo=deltainfo, z=z)
    ##    uu.binom : output object of logistic regression; 
    ##    vv.flm   : output object of poisson regression
    class(L) <- "zipme"
    L
}

