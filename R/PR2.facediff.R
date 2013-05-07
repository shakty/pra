source("PR2.init.R")
library(gvlma)

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

## FIT

# PUB PREVIOUS

fit1 <- lm(100*d.pub.previous ~ round + relevel(condition, ref="coo"), data=pr.faces)
summary(fit1)

test.t.d.pub.previous <- t.test(d.pub.previous ~ com, data=pr)
test.t.d.pub.previous

#gvmodel <- gvlma(fit1)
#summary(gvmodel)

old <- par(mfrow=c(2,2))
plot(fit1)

confint(fit1)
anova(fit1)

old <- par(mfrow=c(2,2))
plot(fit1)

fit.aov <- aov(100*d.pub.previous ~ round + condition, data = pr.faces)
summary(fit.aov)

fit.aov$coeff
confint(fit.aov)


# SUB CURRENT

fit1 <- lm(100*d.sub.current ~ round + relevel(condition, ref="coo"), data=pr.faces)
summary(fit1)

test.t <- t.test(d.sub.current ~ com, data=pr)
test.t

old <- par(mfrow=c(2,2))
plot(fit1)


# PUB CUMULATIVE

fit1 <- lm(100*d.pub.cumulative ~ round + relevel(condition, ref="coo"), data=pr.faces)
summary(fit1)

test.t <- t.test(d.pub.cumulative ~ com, data=pr)
test.t

old <- par(mfrow=c(2,2))
plot(fit1)

# SELF PREVIOUS

fit1 <- lm(100*d.self.previous ~ round + relevel(condition, ref="coo"), data=pr.faces)
summary(fit1)

test.t <- t.test(d.self.previous ~ com, data=pr)
test.t

old <- par(mfrow=c(2,2))
plot(fit1)

#######################
## PLOTS

## global
#########

# PUB PREVIOUS
title <- ggtitle("Group Diversity")
p <- ggplot(pr, aes(round, d.pub.previous))
p <- p + geom_smooth() 
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
p
ggsave(file="./img/distance/dist_global_pubprevious.jpg")

# SELF PREVIOUS
title <- ggtitle("Personal Innovation")
p <- ggplot(pr, aes(round, d.self.previous))
p <- p + geom_smooth() 
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
p
ggsave(file="./img/distance/dist_global_selfprevious.jpg")

# CURRENTLY SUBMITTED
title <- ggtitle("Group Innovation")
p <- ggplot(pr, aes(round, d.sub.current))
p <- p + geom_jitter(alpha=.2, shape=1)
p <- p + geom_smooth() 
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
p

ggsave(file="./img/distance/dist_global_submitted.jpg")


## decomposed: coo vs com
##############


title <- ggtitle("Group Innovation by level of competition")
p <- ggplot(pr, aes(round, d.pub.previous))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Face Difference") + xlab("Round")
p
ggsave(file="./img/distance/dist_coocom_groupinnovation.jpg")

title <- ggtitle("Personal Innovation by level of competition")
p <- ggplot(pr, aes(round, d.self.previous))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
#p <- p + geom_smooth(aes(colour=com),size=2, method=lm, se=FALSE)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Face Difference") + xlab("Round")
p
ggsave(file="./img/distance/dist_coocom_personalinnovation.jpg")

title <- ggtitle("Group Diversity by level of competition")
p <- ggplot(pr, aes(round, d.sub.current))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Face Difference") + xlab("Round")
p
ggsave(file="./img/distance/dist_coocom_groupdiversity.jpg")

## decomposed
##############

# PUB PREVIOUS

title <- ggtitle("Average distance from current submission and published faces \n in the previous round, per round per condition")

p.distance <- ggplot(pr, aes(round, d.pub.previous))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_pub_previous_facets.jpg")


p.distance <- ggplot(pr.faces, aes(round, d.pub.previous))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_pub_previous_points.jpg")

#dfc <- summarySE(pr, measurevar="d.pub.previous", groupvars=c("com", "round"), TRUE)

# SELF PREVIOUS

title <- ggtitle("Average distance of two subsquent submissions of the same player,\n per round per condition")

p.distance <- ggplot(pr, aes(round, d.self.previous))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_self_previous_facets.jpg")


p.distance <- ggplot(pr.faces, aes(round, d.self.previous))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_self_previous_points.jpg")


# SUB CURRENT

title <- ggtitle("Average distance between submitted faces, per round per condition")

p.distance <- ggplot(pr, aes(round, d.sub.current))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_sub_current_facets.jpg")


p.distance <- ggplot(pr.faces, aes(round, d.sub.current))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_sub_current_points.jpg")


# PUB CUMULATIVE

title <- ggtitle("Average distance between current submission and the average \n of all published faces, per round per condition")

p.distance <- ggplot(pr, aes(round, d.pub.cumulative))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_pub_cumulative_facets.jpg")

p.distance <- ggplot(pr.faces, aes(round, d.pub.cumulative))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_pub_cumulative_points.jpg")

## R MEASURED: SUB CURRENT NOT NORMALIZED

title <- ggtitle("**Validation - Distance computed with R dist method** \n Un-normalized average distance between submitted faces, \n per round per condition")

p.distance <- ggplot(pr, aes(round, d.R.sub.current))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets

ggsave(file="./img/distance/dist_R_UNNORMALIZED_sub_current_facets.jpg")


p.distance <- ggplot(pr.faces, aes(round, d.R.sub.current))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_R_UNNORMALIZED_sub_current_points.jpg")



## R MEASURED: SUB CURRENT NORMALIZED

title <- ggtitle("**Validation - Distance computed with R dist method** \n Average distance between submitted faces, \n per round per condition")

p.distance <- ggplot(pr, aes(round, d.R.norm.sub.current))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_R_NORMALIZED_sub_current_facets.jpg")


p.distance <- ggplot(pr.faces, aes(round, d.sub.current))
p.distance + geom_point(size=1) + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue") + title
ggsave(file="./img/distance/dist_R_NORMALIZED_sub_current_points.jpg")



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




################
### OTHER PLOTS


p.face <- ggplot(pr, aes(round, d.pub.previous))

#p.face + geom_point(aes(group=session, colour=session))
#p.face + geom_smooth(aes(group=session, colour=coo))

p.dist.self <- ggplot(pr.faces, aes(round, d.pub.previous))
p.dist.self + geom_point() + aes(colour=condition) + facet_grid(condition ~ ., margins = T)  + stat_smooth(method="lm", se=FALSE)
                      

p.dist.self + geom_point() + aes(colour=condition) + facet_grid(. ~ condition, margins = T)  + stat_smooth(method="lm", colour="darkblue")

p.dist.self + geom_point() + aes(colour=condition) + facet_grid(condition ~ ., margins = T)  + stat_smooth(method="lm", se=FALSE, aes(colour="black"))


p.face + geom_point(aes(colour=coo)) + geom_jitter(aes(colour=coo))

p.face + geom_smooth(aes(group=coo, colour=coo)) + stat_smooth(method="lm", se=FALSE, aes(group=coo, colour=coo))


p.face <- ggplot(pr, aes(round, d.pub.previous))
p.dist.self + geom_point(aes(colour=coo)) + geom_jitter(aes(colour=condition))


t.dist.self <- t.test(d.pub.previous ~ com, data=pr)


##################
### OLD PLOTS



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
