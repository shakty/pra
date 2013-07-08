source("PR2.init.R")

library(gvlma)



title <- ggtitle("Diversity, Change and Innovation PUBLISHED")
p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = d.pub.previous, linetype=published, colour=com), se=FALSE)
#p <- p + geom_smooth(aes(y = d.sub.current, linetype=com, colour = "Diversity"))
#p <- p + geom_smooth(aes(y = d.self.previous, linetype=com, colour = "Personal Change"))
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_smooth(aes(y = e.mean / 10, colour=com))
p <- p + facet_wrap(~session, ncol=6)
#p <- p + scale_y_log10()
p


## There is no level of change that maximize your self-diversity
p <- ggplot(pr)# + scale_colour_discrete(name = "Variable")
p <- p + geom_smooth(aes(d.self.previous, e.mean, colour=published))
p

## Like in pub.prev there is a similar level of dissimilarity from pub.cum
## that maximize my chances of getting published
p <- ggplot(pr)# + scale_colour_discrete(name = "Variable")
p <- p + geom_smooth(aes(d.pub.cumulative, e.mean, colour=published))
p

## The optimal level is very close to the optimal level 
fit <- lm(d.pub.cumulative~published, data=pr)
OPTIMAL1 <- as.numeric(coef(fit)["(Intercept)"]);OPTIMAL1


## There seems to be no optimal distance from previous faces,
## that maximizes your chances of high scores

title <- ggtitle("Diversity, Change and Innovation PUBLISHED")
p <- ggplot(pr)# + scale_colour_discrete(name = "Variable")
#p <- p + geom_smooth(aes(d.pub.previous, r.mean,  linetype=published))
p <- p + scale_x_continuous(breaks=seq(0,0.6,0.05))
p <- p + geom_point(aes(d.sub.current, r.mean, shape=published, colour=com))
p <- p + geom_smooth(aes(d.sub.current, r.mean), method=lm, se=FALSE)
#p <- p + geom_smooth(aes(y = d.pub.previous, linetype=published, colour=com), se=FALSE)
#p <- p + geom_smooth(aes(y = d.sub.current, linetype=com, colour = "Diversity"))
#p <- p + geom_smooth(aes(y = d.self.previous, linetype=com, colour = "Personal Change"))
#p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_smooth(aes(x = round, y = e.mean, colour=com))
#p <- p + facet_wrap(~session, ncol=6)
#p <- p + scale_y_log10()
p

rounds <- data.frame(round=rep(1:30,16))
rounds$session <- rep(1:16,each=30)
rounds <- merge(rounds,overview)
rounds$inn.mean <- 0
rounds$inn.pub.mean <- 0
rounds$inn.diff.pub <- 0
for (s in unique(pr$session)) {
  for (r in unique(pr$round)) {
    data <- pr[pr$session == s & pr$round == r,]
    meanInn <- mean(data$d.pub.previous, na.rm=TRUE)
    meanInnPub <- mean(data[data$published == 1,"d.pub.previous"], na.rm=TRUE)
    meanInnDiff <- meanInnPub - meanInn
    rounds[rounds$session == s & rounds$round == r,]$inn.mean <- meanInn
    rounds[rounds$session == s & rounds$round == r,]$inn.pub.mean <- meanInnPub
    rounds[rounds$session == s & rounds$round == r,]$inn.diff.pub <- meanInnDiff    
  }
}

p <- ggplot(rounds)# + scale_colour_discrete(name = "Variable")
p <- p + geom_histogram(aes(x=inn.mean, fill="all"))
p <- p + geom_histogram(aes(x=inn.pub.mean, fill="pub"))
p

fit <- lm(d.pub.previous~published, data=pr)
OPTIMAL <- as.numeric(coef(fit)["(Intercept)"])
SD_OPTIMAL <- summary(fit)$coefficients[, 2][2]
OPT_R <- OPTIMAL + SD_OPTIMAL
OPT_L <- OPTIMAL - SD_OPTIMAL

OPTIMAL <- 0.225
SD_OPTIMAL <- 0.025
OPT_R <- OPTIMAL + SD_OPTIMAL
OPT_L <- OPTIMAL - SD_OPTIMAL



# Dist from optimal point
pr$distfromoptimalinn <- abs(pr$d.pub.prev - OPTIMAL)*100


# Dist from optimal point + conf interval
computeDistFromOptimal<-function(x){
  if (is.na(x)) {
    return(NA)
  }
  else if (x > OPT_R) {
    return(x - OPT_R)
  }
  else if (x < OPT_L) {
    return(x - OPT_L)
  }
  else {
    return(0)
  }
}

pr$distfromoptimalinn <- abs(apply(as.matrix(pr$d.pub.prev), 1, computeDistFromOptimal))*100

pr$optimaldist.pub.prev <- as.numeric(pr$d.pub.previous < OPT_R & pr$d.pub.previous > OPT_L)
#fit2 <- lm(e.mean~optimaldist.pub.prev, data=pr)
fit2 <- lm(r.mean~distfromoptimalinn, data=pr)
summary(fit2)


fit3 <- glm(published~distfromoptimalinn, data=pr, family="binomial")
summary(fit3)

optimals <- data.frame(session=(1:16), optimal = rep(0,16))
for (s in optimals$session) {
  fit <- lm(d.pub.previous~published, data=pr[pr$session == s,])
  optimals[optimals$session == s, "optimal"] <- as.numeric(coef(fit)["(Intercept)"])
}


# PUB PREVIOUS
title <- ggtitle("Group Innovation")
p <- ggplot(pr, aes(round, d.pub.previous))
p <- p + geom_smooth() 
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_abline(intercept=OPTIMAL, slope=0)
p <- p + geom_abline(data=optimals, aes(intercept=optimal, slope=0))
p <- p + facet_wrap(~session,ncol=4)
p



## COMPUTING DIFFERENCES WITH R
diff.frame <- data.frame()
for (s in sessions) {
  session <- pr[pr$session == s, ]
  session.frame <- computeDistSession(session)
  diff.frame <- rbind(diff.frame, session.frame)
}
row.names(diff.frame) <- c(1:nrow(diff.frame))
head(diff.frame)

r.diff <- melt(diff.frame, measure.vars=c("coo","choice","rand","com"), variable_name="condition")
r.diff <- r.diff[r.diff$value == 1,]
head(r.diff)

# MERGING THEM IN PR
pr <- merge(pr, diff.frame)

pr.faces <- melt(pr, measure.vars=c("coo","choice","rand","com"), variable_name="condition")
pr.faces <- pr.faces[pr.faces$value == 1,]


###############
### TESTS

session <- pr[pr$session == 10,]

faces <- session[session$round == 1,13:25]

if (any(is.na(faces))) {
  return(rep(NA,9))
}

faces.norm <- session[session$round == 1, 26:38]
  
faces.matrix <- as.matrix(faces)
faces.norm.matrix <- as.matrix(faces.norm)

faces.dist <- dist(faces)
faces.norm.dist <- dist(faces.norm)

faces.dist.matrix <- as.matrix(faces.dist)
faces.norm.dist.matrix <- as.matrix(faces.norm.dist)

faces.dist.mean <- rowMeans(faces.dist.matrix)
faces.norm.dist.mean <- rowMeans(faces.norm.dist.matrix)

faces.dist.mean
faces.norm.dist.mean

computeDistRound(session, 1)

computeDistSession(session)


