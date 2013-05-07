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


## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This is does the summary; it's not easy to understand...
    datac <- ddply(data, groupvars, .drop=.drop,
                   .fun= function(xx, col, na.rm) {
                           c( N    = length2(xx[,col], na.rm=na.rm),
                              mean = mean   (xx[,col], na.rm=na.rm),
                              sd   = sd     (xx[,col], na.rm=na.rm)
                              )
                          },
                    measurevar,
                    na.rm
             )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean"=measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}




computeDistSession <- function(session, method="euclidian") {

  session.dist <- data.frame()
  session.metadata <- data.frame()
  for (round in seq(1:30)) {
    # perform Hierchical clustering and cut the tree at "cutoff"
    round.dist <- computeDistRound(session, round, method)
    round.all <- data.frame(session[1:9, sessions.ids], round.dist)
    session.dist <- rbind(session.dist, round.all)
  }
  return(session.dist)
}

computeDistRound <- function(session, round, method="euclidian") {
  faces <- session[session$round == round,13:25]
  faces.norm <- session[session$round == round, 26:38]

  
  if (any(is.na(faces))) {
     return(data.frame(round = rep(round, 9),
                       p.number = cbind(c(1:9)+1),
                       d.R.sub.current=rep(NA,9),
                       d.R.norm.sub.current=rep(NA,9)))
  }

  
  
  faces.matrix <- as.matrix(faces)
  faces.norm.matrix <- as.matrix(faces.norm)

  faces.dist <- dist(faces, method=method)
  faces.norm.dist <- dist(faces.norm)

  faces.dist.matrix <- as.matrix(faces.dist)
  faces.norm.dist.matrix <- as.matrix(faces.norm.dist)

  faces.dist.mean <- rowMeans(faces.dist.matrix)
  faces.norm.dist.mean <- rowMeans(faces.norm.dist.matrix)

  return(data.frame(round = rep(round, 9),
                    p.number = c(1:9)+1,
                    d.R.sub.current = faces.dist.mean,
                    d.R.norm.sub.current = faces.norm.dist.mean))
}
  
lagg <- function(series, nlag=1, FORWARD = FALSE) {
  obs <- length(series)
  if (!FORWARD) {
    return(c(rep(NA,nlag),series[1:obs-nlag]))
  }
  else {
    return(c(series[nlag:obs-nlag],rep(NA,nlag)))
  }
}

#### START ####
#mysession <- pr[pr$session == 3, ]
#source('PR_init.R')
library(plyr)
library(ggplot2)
library(reshape)
library(MASS)
library(car)

setwd("/var/www/pra/data/ALL/")

pr <- read.table(file="./allnew.csv", head=TRUE, sep=",")

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

overview <- data.frame()
for (s in unique(pr$session)) {
  tmp <- pr[pr$session == s,c(1:8,length(pr))][1,]
  overview <- rbind(overview,tmp)
}




## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summaryPlayers <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This is does the summary; it's not easy to understand...
    datac <- ddply(data, groupvars, .drop=.drop,
                   .fun= function(xx, col, na.rm) {
                           c( N    = length2(xx[,col], na.rm=na.rm),
                              mean = mean   (xx[,col], na.rm=na.rm),
                              sd   = sd     (xx[,col], na.rm=na.rm)
                              )
                          },
                    measurevar,
                    na.rm
             )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean"=measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult


    # change names
    a <- measurevar
    datac <- rename(datac, c("N"=paste(a,"N",sep='.'),
                    "sd"=paste(a,"sd",sep="."),
                    "se"=paste(a,"se",sep="."),
                    "mean"=paste(a,"mean",sep="."),
                    "ci"=paste(a,"ci",sep=".")))
    return(datac)
}


# Cleaning PR times


pr[!is.na(pr$time.creation) & (pr$time.creation > 150 | pr$time.creation < 0), "time.creation"] <- NA
pr[!is.na(pr$time.dissemination) & (pr$time.dissemination > 150 | pr$time.dissemination < 0), "time.dissemination"] <- NA


## FONT for plots
theme_set(theme_gray(base_size = 18))
