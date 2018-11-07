# list of R packages not currently supported by the conda r channel
pkgs <- c("rsample", "Rtsne", "corrplot", "plotly", "tidygraph", "ggraph")
install.packages(pkgs, repos='http://cran.rstudio.com/')
quit(save = "no")