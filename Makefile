docs/session1.html: session1.html
	mv session1.html docs

session1.html: session1.rmd pix/vecrand.png


%.html: %.rmd
	echo "rmarkdown::render(\"$<\")" | R --slave

pix/vecrand.png: R/vecrand.R
	cd R; R CMD BATCH --vanilla vecrand.R
