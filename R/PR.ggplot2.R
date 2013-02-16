#source('PR_init.R')

library(ggplot2)
library(reshape)

setwd("/var/www/pra/data/ALL/")

pr <- read.table(file="./all.csv", head=TRUE, sep=",")

pr.clean <- na.omit(pr)

all.rounds.d.pub.previous <- tapply(pr.clean$d.pub.previous, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.pub.previous)

all.rounds.d.sub.current <- tapply(pr.clean$d.sub.current, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.sub.current)

all.rounds.d.self.previous <- tapply(pr.clean$d.self.previous, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.self.previous)

all.rounds.d.pub.cumulative <- tapply(pr.clean$d.pub.cumulative, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.pub.cumulative)

pr.com.clean <- na.omit(pr[pr$com == 1, ])

com.rounds.d.pub.previous <- tapply(pr.com.clean$d.pub.previous, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.com.clean$d.sub.current, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.com.clean$d.self.previous, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.com.clean$d.pub.cumulative, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.coo.clean <- na.omit(pr[pr$coo == 1, ])

com.rounds.d.pub.previous <- tapply(pr.coo.clean$d.pub.previous, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.coo.clean$d.sub.current, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.coo.clean$d.self.previous, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.coo.clean$d.pub.cumulative, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.choice.clean <- na.omit(pr[pr$choice == 1, ])

com.rounds.d.pub.previous <- tapply(pr.choice.clean$d.pub.previous, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.choice.clean$d.sub.current, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.choice.clean$d.self.previous, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.choice.clean$d.pub.cumulative, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.rand.clean <- na.omit(pr[pr$rand == 1, ])

com.rounds.d.pub.previous <- tapply(pr.rand.clean$d.pub.previous, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.rand.clean$d.sub.current, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.rand.clean$d.self.previous, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.rand.clean$d.pub.cumulative, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


names.pr <- names(pr)

pr.melted <- melt(pr, id=names.pr[c(-64, -70, -75)])
pr.melted.clean <- na.omit(pr.melted)

#com.rounds.d.pub.cumulative <- tapply(pr.melted.clean$value, pr.rand.clean$, mean)
#plot.ts(seq(2:30), com.rounds.d.pub.cumulative)

pr.factor <- pr
pr.factor$e1.same.ex <- as.factor(pr.factor$e1.same.ex)

aggdata <- aggregate(pr.factor, by=list(pr.factor$e1,pr.factor$e1.same.ex), FUN=mean, na.rm=TRUE)


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

require(plyr)

ddply(pr, "round", transform, grp.mean.values = mean(d.sub.current))

grp.mean.values <- ave(pr$d.sub.current, pr$round)

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


mysession <- pr[pr$session == 3, ]

#face <- face[face$round == 4, 13:25]
#face.norm <- face[face$round == 4, 26:38]

players.labels=seq(2:10)+1
sessions.ids <- seq(1,8)

sessions <- unique(pr$session)
#id=seq(1,30*length(sessions))

cutoff = 30

groups.matrix <- vector()
groups.max <- vector()
groups.metadata <- vector()
for (session in sessions) {
  mysession <- pr[pr$session == session, ]
  mysession.groups <- vector()
  mysession.max <- vector()
  mysession.metadata <- data.frame()
  for (round in seq(1:30)) {
    # perform Hierchical clustering and cut the tree at "cutoff"
    round.groups <- countGroups(mysession, round, cutoff)
    round.ngroups <- max(round.groups)   
    #round.fulline <- c(mysession.metadata, round.groups, round.ngroups)
    mysession.groups <- rbind(mysession.groups, round.groups)
    mysession.max <- rbind(mysession.max, round.ngroups)
    mysession.metadata <- rbind(mysession.metadata, mysession[1,sessions.ids])
  }
  groups.matrix <- rbind(groups.matrix, mysession.groups)
  groups.max <- rbind(groups.max, mysession.max)
  groups.metadata <- rbind(groups.metadata, mysession.metadata)
  #ngroups <- apply(round.groups,1,max)
  #mygroups.frame <- rbind(mygroups)
}

groups.metadata$id <- seq(1:nrow(groups.metadata))

groups.frame <- as.data.frame(groups.matrix)
groups.frame$id <- seq(1:nrow(groups.frame))

groups.frame <- merge(groups.metadata, groups.frame, by = "id", all = TRUE)
names(groups.frame)[c(10:18)] <- paste0("p", seq(2:10)+1)

groups.frame$max <- groups.max


for (session in sessions) {
   mysession <- groups.frame[groups.frame$session == session, ]
   plot.ts(mysession$max)
   par(ask=TRUE) 
}

countGroups <- function(session, round, cutoff) {
  faces <- session[mysession$round == round,13:25]
  faces.norm <- session[mysession$round == round, 26:38]

  faces.matrix <- as.matrix(faces)
  faces.norm.matrix <- as.matrix(faces.norm)

  faces.dist <- dist(faces)
  faces.norm.dist <- dist(faces.norm)

  faces.hclust <- hclust(faces.dist)
  faces.norm.hclust <- hclust(faces.norm.dist)

  #plot(faces.hclust,labels=seq(2:10)+1)
  #plot(faces.norm.hclust,labels=seq(2:10)+1)

  #heatmap(faces.matrix)

  faces.groups<-cutree(faces.hclust, h=cutoff)

  return(faces.groups)
}

#ngroups <- max(faces.groups)
  


# EXAMPLE
USArrests.dist<-dist(USArrests)
hc <- hclust(USArrests.dist, "average")
plot(hc, hang = -1)
abline(h=50, col="red", lty="dashed")
groups<-cutree(hc, h=50)
USArrests2<-cbind(USArrests, Group=groups)
head(USArrests2)
#
