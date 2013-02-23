countGroupsInSession <- function(session, cutoff) {
  
  session.groups <- matrix(nrow=30, ncol=9, dimnames=list(rnames, pnames))
  session.max <- matrix(nrow=30, ncol=1, dimnames=list(rnames, "max"))
  session.metadata <- data.frame()
  for (round in seq(1:30)) {
    # perform Hierchical clustering and cut the tree at "cutoff"
    round.groups <- countGroups(session, round, cutoff)
    round.ngroups <- max(round.groups)   
    session.groups[round,] <- round.groups
    session.max[round,] <- round.ngroups
    session.metadata <- rbind(session.metadata, session[1,sessions.ids])
  }
  session.frame <- data.frame(session.metadata, round=c(1:30), session.groups, session.max)
  return(session.frame)
}

countGroups <- function(session, round, cutoff) {
  faces <- session[session$round == round,13:25]
  
  if (any(is.na(faces))) {
    return(rep(NA,9))
  }
  #faces.norm <- session[session$round == round, 26:38]
  
  faces.matrix <- as.matrix(faces)
  #faces.norm.matrix <- as.matrix(faces.norm)

  faces.dist <- dist(faces)
  #faces.norm.dist <- dist(faces.norm)

  faces.hclust <- hclust(faces.dist)
  #faces.norm.hclust <- hclust(faces.norm.dist)

  #plot(faces.hclust,labels=seq(2:10)+1)
  #plot(faces.norm.hclust,labels=seq(2:10)+1)

  #heatmap(faces.matrix)

  faces.groups<-cutree(faces.hclust, h=cutoff)

  return(faces.groups)
}



#### START ####
#mysession <- pr[pr$session == 3, ]
#source('PR_init.R')
library(plyr)
library(ggplot2)
library(reshape)
library(MASS)

setwd("/var/www/pra/data/ALL/")

pr <- read.table(file="./all.csv", head=TRUE, sep=",")

pr$com <- as.factor(pr$com)
pr$coo <- as.factor(pr$coo)
pr$rand <- as.factor(pr$rand)
pr$choice <- as.factor(pr$choice)
pr$session <- as.factor(pr$session)
pr$date <- as.factor(pr$date)
pr$morning <- as.factor(pr$morning)
pr$afternoon <- as.factor(pr$afternoon)

pr$e1.same.color <- as.factor(pr$e1.same.color)
pr$e2.same.color <- as.factor(pr$e2.same.color)
pr$e3.same.color <- as.factor(pr$e3.same.color)

pr$e1.same.ex <- as.factor(pr$e1.same.ex)
pr$e2.same.ex <- as.factor(pr$e2.same.ex)
pr$e3.same.ex <- as.factor(pr$e3.same.ex)
                              
pr$ex <- as.factor(pr$ex)
pr$published <- as.factor(pr$published)
pr$copy <- as.factor(pr$copy)

pr$treatment <- paste0(pr$coo, pr$rand)

pr.ex.stay <- pr == pr$ex

pr$p.id <- as.factor(pr$p.id)

#c("d.sub.previous", "d.sub.current", "d.pub.cumulative", "d.self.previous")
pr[pr$session == 14 & pr$round > 26, c(94:97)] = NA
head(pr[pr$session == 14 & pr$round > 26, c(94:97)])

pr.clean <- na.omit(pr)

players.labels=seq(2:10)+1
sessions.ids <- seq(1,8)

pnames <- paste0("p", seq(2:10)+1)
rnames <- paste0("r", seq(1:30))

sessions <- unique(pr$session)
cutoff = 30

names.pr <- names(pr)
pr.melted <- melt(pr, id=names.pr[c(-64, -70, -76)])

ids.metadata <- c(1:8)
