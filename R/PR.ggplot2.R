#source('PR_init.R')

library(ggplot2)

setwd("/var/www/pra/data/ALL/")

pr <- read.table(file="./all.csv", head=TRUE, sep=",")

#summary(pr)
#names(pr)

qplot(r1, round, data=pr)

filterVars <- function(pattern, varlist) {

  selected <- vector()

  for (v in varlist) {  
    if (length(grep(pattern, v, fixed=TRUE)) > 0) {
      selected <- c(selected, v)
    }
  }

  return(selected)
}


#meanRounds <- column


myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...
## modifiction of plclust for plotting hclust objects *in colour*!
## Copyright Eva KF Chan 2009
## Arguments:
##
## hclust:
## hclust object
##
## lab:
## a character vector of labels of the leaves of the tree
##
## lab.col:
## colour for the labels; NA=default device foreground colour
##
## hang:
## as in hclust & plclust
## Side effect:
##
A display of hierarchical cluster with coloured leaf labels.
y <- rep(hclust$height,2); x <- as.numeric(hclust$merge)
y <- y[which(x<0)]; x <- x[which(x<0)]; x <- abs(x)
y <- y[order(x)]; x <- x[order(x)]
plot( hclust, labels=FALSE, hang=hang, ... )
text( x=x, y=y[hclust$order]-(max(hclust$height)*hang),
labels=lab[hclust$order], col=lab.col[hclust$order],
srt=90, adj=c(1,0.5), xpd=NA, ... )
}



face <- pr[,13:25]
face.norm <- pr[,26:38]

face <- pr[pr$round == 4, 13:25]
face.norm <- pr[pr$round == 4, 26:38]

face.matrix <- as.matrix(face)
face.norm.matrix <- as.matrix(face.norm)

face.dist <- dist(face)
face.norm.dist <- dist(face.norm)

face.hclust <- hclust(face.dist, method="average")
face.norm.hclust <- hclust(face.norm.dist,labels=seq(2:10)+1 )

plot(face.hclust,labels=seq(2:10)+1)

plot(face.norm.hclust,labels=seq(2:10)+1)

heatmap(face.matrix)

face.groups<-cutree(face.hclust, h=30)


# EXAMPLE
USArrests.dist<-dist(USArrests)
hc <- hclust(USArrests.dist, "average")
plot(hc, hang = -1)
abline(h=50, col="red", lty="dashed")
groups<-cutree(hc, h=50)
USArrests2<-cbind(USArrests, Group=groups)
head(USArrests2)
#
