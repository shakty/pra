source("PR2.init.R")
library(gvlma)

sd.b <- function(row) {
  v <- c()
  v <- c(v,as.numeric(row["r1"]))
  v <- c(v,as.numeric(row["r2"]))
  v <- c(v,as.numeric(row["r3"]))
  return(sd(v))
}

########
## START
########


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


## Quantitative tests

# Do x and y come from the same distribution?
pr.clean <- pr[!is.na(pr.clean$dfa.pub.prev.bigcut),]
x = pr.clean[pr.clean$com == 1 & pr.clean$dfa.pub.prev.bigcut == "Very Similar\n(0-.05)","r.mean.clean"]
y = pr.clean[pr.clean$com == 0 & pr.clean$dfa.pub.prev.bigcut == "Very Similar\n(0-.05)","r.mean.clean"]
ks.test(x, y) # not enough points

x = pr.clean[pr.clean$com == 1 & pr.clean$dfa.pub.prev.bigcut == "Avg Diversity\n(0.05-0.4)","r.mean.clean"]
y = pr.clean[pr.clean$com == 0 & pr.clean$dfa.pub.prev.bigcut == "Avg Diversity\n(0.05-0.4)","r.mean.clean"]
ks.test(x, y) # not enough points


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

