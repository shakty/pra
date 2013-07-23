source("PR2.init.R")
library(gvlma)

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

r1s <- a[trainindex,"r1"]
r2s <- a[trainindex2,"r2"]
r3s <- a[trainindex3,"r3"]
as <- cbind(r1s,r2s,r3s)

MAXSTD <- sqrt(6.66^2 + 3.33^2 + 3.33^2)
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
      r1s <- c(r1s, rows[trainindex,"r1"])
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
#ggsave(file="./img/ass/consensus_referees.jpg")

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



myLabeller <- function(var, value){
  value <- as.character(value)
  if (var == "published") { 
    value[value== 0] <- "Rejected"
    value[value== 1] <- "Published"
  }
  return(value)
}

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
p <- p + geom_smooth(method="lm")
p <- p + facet_grid(~com)
p

p <- ggplot(pr,aes(d.pub.previous, r.mean, color=published))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com)
p


p <- ggplot(pr,aes(d.pub.cumulative, r.mean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com,margins=T)
p

p <- ggplot(pr,aes(d.self.previous, r.mean))# + scale_colour_discrete(name = "Variable")
p <- p + geom_jitter(alpha=.2)
p <- p + geom_smooth()
p <- p + facet_grid(~com,margins=T)
p

#  + I(d.pub.previous^2)
fit <- lm(r.mean~d.pub.previous, data=pr[pr$com == 0,])
summary(fit)
# There seems to be an optimal distance between paintings and score. This is more true for COM. Although the data are very noisy


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

pr$ <- ifelse(pr$published, 
