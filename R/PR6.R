source("PR2.init.R")
library(gvlma)

myLabeller <- function(var, value){
  value <- as.character(value)
  if (var == "published") { 
    value[value== 0] <- "Rejected"
    value[value== 1] <- "Published"
  }
  else if (var == "com") {
    value[value== 0] <- "NON-COM"
    value[value== 1] <- "COM"
  } 
  return(value)
}
sd.clean.asskill <- function(row) {
  v <- c()
  if (as.numeric(row["r1.ass.kill"]) == 0) {
    v <- c(v,row["r1"])
  }
  if (as.numeric(row["r2.ass.kill"]) == 0) {
    v <- c(v,row["r2"])
  }
  if (as.numeric(row["r3.ass.kill"]) == 0) {
    v <- c(v,row["r3"])
  }
  if (length(v)>1) {
    return(sd(v))
  }
  else {
    return(NA)
  }
}
cix.clean.asskill <- function(row) {
  v <- c()
  if (as.numeric(row["r1.ass.kill"]) == 0) {
    v <- c(v,row["r1"])
  }
  if (as.numeric(row["r2.ass.kill"]) == 0) {
    v <- c(v,row["r2"])
  }
  if (as.numeric(row["r3.ass.kill"]) == 0) {
    v <- c(v,row["r3"])
  }
  if (length(v) == 2) {
    return(1 - sd(v)/MAXSTD2)
  }
  else if (length(v) == 3) {
    return(1 - sd(v)/MAXSTD)
  }
  else {
    return(NA)
  }
}

sd.clean.5 <- function(row) {
  v <- c()
  if (!is.na(row["r1.changed"]) & as.numeric(row["r1.changed"]) == 1) {
    v <- c(v,row["r1"])
  }
  if (!is.na(row["r2.changed"]) & as.numeric(row["r2.changed"]) == 1) {
    v <- c(v,row["r2"])
  }
  if (!is.na(row["r3.changed"]) & as.numeric(row["r3.changed"]) == 1) {
    v <- c(v,row["r3"])
  }
  if (length(v)>1) {
    return(sd(v))
  }
  else {
    return(NA)
  }
}
cix.clean.5 <- function(row) {
  v <- c()
  if (!is.na(row["r1.changed"]) & as.numeric(row["r1.changed"]) == 1) {
    v <- c(v,row["r1"])
  }
  if (!is.na(row["r2.changed"]) & as.numeric(row["r2.changed"]) == 1) {
    v <- c(v,row["r2"])
  }
  if (!is.na(row["r3.changed"]) & as.numeric(row["r3.changed"]) == 1) {
    v <- c(v,row["r3"])
  }
  if (length(v) == 2) {
    return(1 - sd(v)/MAXSTD2)
  }
  else if (length(v) == 3) {
    return(1 - sd(v)/MAXSTD)
  }
  else {
    return(NA)
  }
}

sd.clean <- function(row) {
  v <- c()
  if (!is.na(row["r1.changed"]) & as.numeric(row["r1.changed"]) == 1 & as.numeric(row["r1.ass.kill"]) == 0 ) {
    v <- c(v,row["r1"])
  }
  if (!is.na(row["r2.changed"]) & as.numeric(row["r2.changed"]) == 1 & as.numeric(row["r2.ass.kill"]) == 0) {
    v <- c(v,row["r2"])
  }
  if (!is.na(row["r3.changed"]) & as.numeric(row["r3.changed"]) == 1 & as.numeric(row["r3.ass.kill"]) == 0) {
    v <- c(v,row["r3"])
  }
  if (length(v) > 1) {
    return(sd(v))
  }
  else {
    return(NA)
  }
}
cix.clean <- function(row) {
  v <- c()
  if (!is.na(row["r1.changed"]) & as.numeric(row["r1.changed"]) == 1 & as.numeric(row["r1.ass.kill"]) == 0 ) {
    v <- c(v,row["r1"])
  }
  if (!is.na(row["r2.changed"]) & as.numeric(row["r2.changed"]) == 1 & as.numeric(row["r2.ass.kill"]) == 0) {
    v <- c(v,row["r2"])
  }
  if (!is.na(row["r3.changed"]) & as.numeric(row["r3.changed"]) == 1 & as.numeric(row["r3.ass.kill"]) == 0) {
    v <- c(v,row["r3"])
  }
  if (length(v) == 2) {
    return(1 - sd(v)/MAXSTD2)
  }
  else if (length(v) == 3) {
    return(1 - sd(v)/MAXSTD)
  }
  else {
    return(NA)
  }
}

#####################
## START
####################

# Are ratings just spreading out more?

p <- ggplot(evas)
p + geom_boxplot(aes(factor(round), value, color=com)) + facet_grid(~com, margins=T) + xlab("Round") + ylab("Review score") + ggtitle("Distributions of review scores in time by level of competition")
ggsave(file="./img/evas/distribution_reviews_in_time.jpg")

# Under competitive conditions yes

# Shuffle ratings

a <- pr[pr$session ==1 & pr$round == 2,c("r1","r2","r3")]

index <- 1:nrow(a)
trainindex1 <- sample(index)
trainindex2 <- sample(index)
trainindex3 <- sample(index)

r1s <- a[trainindex1,"r1"]
r2s <- a[trainindex2,"r2"]
r3s <- a[trainindex3,"r3"]
as <- cbind(r1s,r2s,r3s)


MAXSTD <- sd(c(0,0,10))
MAXSTD2 <- sd(c(0,10))


library(matrixStats)
ITER <- 100

stds <- c()
prs <- pr
for (i in 1:ITER) {
  r1s <- c()
  r2s <- c()
  r3s <- c()
  for (s in unique(pr$session)) {
    for (r in unique(pr$round)) {
      rows <- pr[pr$session == s & pr$round == r,]
      index <- 1:nrow(rows)
      trainindex1 <- sample(index)
      trainindex2 <- sample(index)
      trainindex3 <- sample(index)
      r1s <- c(r1s, rows[trainindex1,"r1"])
      r2s <- c(r2s, rows[trainindex2,"r2"])
      r3s <- c(r3s, rows[trainindex3,"r3"])
    }
  }
  s <- as.data.frame(cbind(r1s,r2s,r3s))
  stds <- cbind(stds,  rowSds(s))
}
pr$rs.sd <- rowMeans(stds)


pr$r.consensus <- 1 - pr$r.std / MAXSTD

pr$rs.consensus <- 1 - pr$rs.sd / MAXSTD

title <- ggtitle("Consensus among referees")
p <- ggplot(pr, aes(round, r.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/consensus_referees.jpg")

title <- ggtitle("Consensus among referees\n shuffled reviews (100x)")
p <- ggplot(pr, aes(round, rs.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/consensus_referees_shuffled_100.jpg")

title <- ggtitle("Difference in consensus among referees\n original reviews - shuffled reviews (100x)")
p <- ggplot(pr, aes(round, r.consensus - rs.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/diff_consensus_referees_original_shuffled_100.jpg")


# What if we remove the ass reviews?
####################################

pr$r.sd.clean.asskill <- apply(pr, 1, sd.clean.asskill)
pr$r.sd.clean.5 <- apply(pr, 1, sd.clean.5)
pr$r.sd.clean <- apply(pr, 1, sd.clean)

pr$r.consensus.clean <- apply(pr, 1, cix.clean)
pr$r.consensus.clean.5 <- apply(pr, 1, cix.clean.5)
pr$r.consensus.clean.asskill <- apply(pr, 1, cix.clean.asskill)

title <- ggtitle("Cleaned consensus among referees")
p <- ggplot(pr, aes(round, r.consensus.clean))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Cleaned Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/diff_cleaned_consensus_referees.jpg")

title <- ggtitle("Consensus among referees cleaned from ASS reviews")
p <- ggplot(pr, aes(round, r.consensus.clean.asskill))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/diff_cleaned_from_ASS_consensus_referees.jpg")

title <- ggtitle("Consensus among referees cleaned from 3FIVES reviews")
p <- ggplot(pr, aes(round, r.consensus.clean.5))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/diff_cleaned_from_5_consensus_referees.jpg")


title <- ggtitle("Difference in consensus among referees\n original **cleaned** reviews - shuffled reviews (100x)")
p <- ggplot(pr, aes(round, r.consensus.clean - rs.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p

title <- ggtitle("Difference in consensus among referees\n original **cleaned from ASS** reviews - shuffled reviews (100x)")
p <- ggplot(pr, aes(round, r.consensus.clean.asskill - rs.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p

title <- ggtitle("Difference in consensus among referees\n original **cleaned from 3FIVES** reviews - shuffled reviews (100x)")
p <- ggplot(pr, aes(round, r.consensus.clean.5 - rs.consensus)) #  
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p

ggsave(file="./img/ass/diff_consensus_referees_original_shuffled_100.jpg")


### Are subjects becoming more different withing one trajectory
### Are sessions becoming incresingly more different each other

# Average distance of each face from the faces submitted in the same round in other exhibitions



### Innovation measured only between published faces
# initial measure was: current submission - previous published


title <- ggtitle("Two measures of Group Innovation:\n \"All Subs\" vs \"Pubs Only\" - \"Pubs prev. round\"")
p <- ggplot(pr, aes(round, d.pub.previous))
p <- p + geom_jitter(aes(colour=published), alpha=.2)
p <- p + geom_smooth(aes(colour=published),size=2)
p <- p + title + ylab("Innovation") + xlab("Round")
p <- p +  scale_colour_discrete(name="Measures", labels=c("All Subs", "Pubs Only"))
p
ggsave(file="./img/innovation/inn_only_pub_or_all.jpg")

pr.clean <- pr[!is.na(pr$published),]
title <- ggtitle("Group Innovation:  \"Pubs Only\" - \"Pubs prev. round\"")
p <- ggplot(pr.clean, aes(round, d.pub.previous))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + facet_grid(~published, margin=F)
p <- p + title + ylab("Innovation") + xlab("Round")
p
ggsave(file="./img/innovation/inn_only_pub_or_all_by_COM.jpg")




pr.clean <- pr[!is.na(pr$published),]
title <- ggtitle("Group Innovation measured as \"Pubs Only\" - \"Pubs prev. round\"")
p <- ggplot(pr.clean, aes(round, d.pub.previous))
#p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + facet_grid(~published, margin=F, labeller=myLabeller)
p <- p + title + ylab("Innovation") + xlab("Round")
p
ggsave(file="./img/innovation/inn_only_pub_or_all_by_COM.jpg")

# On the average of all conditions there seems to be no big difference in measuring Group Innovation in the following two ways:
# A - submitted - pub.prev
# B - published.now - pub.prev
# I think that B is the most correct way of defining group innovation
# If I distinguish between each treatment condition I see that choosing B over A makes a big difference for non COM
# Group Innovation is largely decreasing earlier, and more markedly


### Is there a preference for diversity that is driving the process of differentiation


# e1, e2, e3 are evaluations DONE by the player
# r1, r2, r3 are reviews RECEIVED by the player

# ATTENTION!! r*.same.ex is always 0. However, e*.same.ex is correctly set
# ATTENTION!! r*changed seems unreliable sometimes

p <- ggplot(pr,aes(d.pub.previous, r.mean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from faces published in the previous round and score")
p
ggsave(file="./img/optimaldist/pubprev_score.jpg")


p <- ggplot(pr,aes(d.pub.previous, r.mean, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from faces published in the previous round and **clean** score")
p
ggsave(file="./img/optimaldist/pubprev_score_by_com.jpg")

p <- ggplot(pr,aes(d.pub.previous, r.mean, color=published))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com, labeller=myLabeller) + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from faces published in the previous round and score")
p
ggsave(file="./img/optimaldist/pubprev_score_by_com_by_pub.jpg")

p <- ggplot(pr,aes(d.pub.cumulative, r.mean,color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from all previously published faces and score")
p
ggsave(file="./img/optimaldist/pubcum_score_by_com.jpg")

p <- ggplot(pr,aes(d.self.previous, r.mean, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from all previously published faces and **clean** score")
p
ggsave(file="./img/optimaldist/selfdist_score_by_com.jpg")



## using clean mean
p <- ggplot(pr,aes(d.pub.previous, r.mean.clean, color=com))
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Cleaned Review Score') + ggtitle("Distance from all previously published faces and **clean** score")
p
ggsave(file="./img/optimaldist/pubprev_cleanmean_by_com.jpg")

 <- ggplot(pr,aes(d.pub.previous, r.mean.clean, color=published))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com, labeller=myLabeller) + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from faces published in the previous round and score")
p
ggsave(file="./img/optimaldist/pubprev_cleanmean_by_com_by_pub.jpg")


p <- ggplot(pr,aes(d.pub.previous, r.mean.clean.asslove, color=com))
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('ASS-free Review Score') + ggtitle("Distance from all previously published faces and **ASS-free** score")
p
ggsave(file="./img/optimaldist/pubprev_asskillfree_by_com.jpg")


p <- ggplot(pr,aes(d.pub.cumulative, r.mean.clean, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Cleand Review Score') + ggtitle("Distance from all previously published faces and **clean** score")
p
ggsave(file="./img/optimaldist/pubcum_cleanmean_by_com.jpg")



cutLabels <- c("0-5", "5-10", "10-15", "15-20","20-25","25-30")
pr$round.cut5 <- cut(pr$round, breaks=seq(0,30,5), labels=cutLabels)

cutLabels <- c("0-10", "10-20", "20-30")
pr$round.cut10 <- cut(pr$round, breaks=seq(0,30,10), labels=cutLabels)

p <- ggplot(pr,aes(d.pub.previous, r.mean.clean, color=com))
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Clean Review Score') + ggtitle("Distance from all previously published faces\n and **clean** score divided by rounds")
#p <- p + facet_grid(~round.cut10)
p <- p + facet_wrap(~round.cut5,ncol=2)
p
ggsave(file="./img/optimaldist/pubprev_cleanmean_by_rounds_by_com.jpg")

pr$d.pub.previous.cut <- cut(pr$d.pub.previous, breaks=seq(0,max(pr$d.pub.previous,na.rm=T),0.05))


pr.clean <- pr[!is.na(pr$d.pub.previous.cut),]
p <- ggplot(pr.clean,aes(d.pub.previous.cut, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_boxplot(aes(y=r.mean.clean)) + xlab('Distance') + ylab('Clean Review Score') + ggtitle("Distributions from all previously published faces\n and **clean** score divided by rounds")
p <- p + facet_grid(round.cut10~., margin=T)
#p <- p + facet_wrap(~round.cut5,ncol=2)
p
ggsave(file="./img/optimaldist/pubprev_cleanmean_boxplot_by_round_by_com.jpg")


## Distance from the average face and score

p <- ggplot(pr,aes(dfa.pub.prev, r.mean.clean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from **avg-face** published in the previous round\n and **clean** score")
p
ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean.jpg")


p <- ggplot(pr,aes(dfa.pub.prev, r.mean.clean, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth() + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from **avg-face** published in the previous round\n and **clean** score")
p
ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean_by_com.jpg")


p <- ggplot(pr,aes(dfa.pub.prev, r.mean.clean, color=published))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com, labeller=myLabeller) + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from **avg-face** published in the previous round\n and **clean** score")
p
ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean_by_com_by_pub.jpg")


p <- ggplot(pr,aes(dfa.pub.prev, r.mean.clean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.5, aes(color=session))
p <- p + geom_smooth()
p <- p + facet_grid(round.cut5~com, labeller=myLabeller) + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from the average published face\n in the previous round and **clean** score") + ylim(0, 10)
p




fit <- rlm(r.mean.clean ~ dfa.pub.prev + I(dfa.pub.prev^2) , data=pr[pr$com == 0,])
summary(fit)

opar <- par(mfrow = c(2, 2), oma = c(0, 0, 1.1, 0))
plot(ols, las = 1)
plot(fit)
par(opar)
a <- predict(fit,newdata=pr)
plot(pr$dfa.pub.prev,a)


a <- loess(pr$dfa.pub.prev ~ pr$r.mean.clean)
plot(a$x, a$y)

ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean_by_com.jpg")


pr$dfa.pub.prev.cut <- cut(pr$dfa.pub.prev, breaks=seq(0,max(pr$dfa.pub.prev,na.rm=T),0.02))

pr.clean <- pr[!is.na(pr$dfa.pub.prev.cut),]
p <- ggplot(pr.clean,aes(dfa.pub.prev.cut, color=com))# + scale_colour_discrete(name = "Variable")
p <- p + geom_boxplot(aes(y=r.mean),notch=T)
#p <- p + facet_grid(round.cut10~.)
#p <- p + facet_wrap(~round.cut5,ncol=2)
p

cutLabels <- c("A", "B", "C")
cutLabels <- c("Very Similar\n(0-.05)", "Avg Diversity\n(0.05-0.4)", "Highly diverse\n(>0.4)")
pr$dfa.pub.prev.bigcut <- cut(pr$dfa.pub.prev, breaks=c(0,0.05,0.4,max(pr$dfa.pub.prev,na.rm=T)),labels=cutLabels)

pr.clean <- pr[!is.na(pr$dfa.pub.prev.bigcut),]
p <- ggplot(pr.clean,aes(x=dfa.pub.prev.bigcut, color=com))
p <- p + geom_boxplot(aes(y=r.mean.clean)) + xlab('Distance') + ylab('Review Score') + ggtitle("Distance from the average published face\n in the previous round and **clean** score")
p
ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean_by_com_boxplots_bigcuts.jpg")

pr.clean <- pr[!is.na(pr$dfa.pub.prev.bigcut),]
p <- ggplot(pr.clean,aes(x=r.mean.clean, group=com,color=com))
p <- p + geom_density(aes(fill=com),alpha=0.3)
p <- p + facet_grid(~dfa.pub.prev.bigcut) + xlab('Clean Review Score') + ylab('Frequency') + ggtitle("Freq. distributions of **clean** review score by diversity group")
p
ggsave(file="./img/optimaldist/dfa_pubprev_cleanmean_by_com_freqdistr_bigcuts.jpg")


## Other tests

p <- ggplot(pr[pr$session==1,],aes(d.pub.previous, r.mean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_wrap(~round,ncol=4)
p

p <- ggplot(pr[pr$session==1,],aes(d.pub.previous, r.mean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_wrap(~round,ncol=4)
p

p <- ggplot(pr[pr$session==9,],aes(d.pub.previous, r.mean, color=com) )# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_wrap(~round,ncol=1) + opts(strip.background = theme_blank(),
                             strip.text.x = theme_blank())
p

p <- ggplot(pr[pr$session==9,],aes(d.pub.previous, r.mean, color=com) )# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_wrap(~round,ncol=1) + opts(strip.background = theme_blank(),
                             strip.text.x = theme_blank())
p

p <- ggplot(pr[pr$session==9,],aes(round, d.pub.previous) )# + scale_colour_discrete(name = "Variable")
p <- p +  geom_linerange(aes(ymin=0,ymax=0.7)) + coord_flip()
p



pr$maxPubInn <- max(pr$d.pub.previous,na.rm)




p <- ggplot(pr)# + scale_colour_discrete(name = "Variable")
p <- p + geom_smooth(aes(d.pub.previous, r.mean, colour=published))
p <- p + facet_grid(round~com)
p

pr$r.mean.from5 <- pr$r.mean - 5



### how many 3fives reviews by condition



pr.clean <- pr[!is.na(pr$e.changed) & pr$e.changed == 0,]
p <- ggplot(pr.clean,aes(x=as.factor(e.changed), group=com,color=com))
p <- p + geom_bar(aes(fill=com),alpha=0.3, position="dodge")
p <- p + facet_grid(~round.cut5) + xlab('Clean Review Score') + ylab('Frequency') + ggtitle("Freq. distributions of **clean** review score by diversity group")
p

