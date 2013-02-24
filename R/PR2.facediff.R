source("PR2.init.R")

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


fit1 <- lm(d.pub.previous ~ com, data=pr)

old <- par(mfrow=c(2,2))
plot(fit1)

library(gvlma)

gvmodel <- gvlma(fit1)
summary(gvmodel)

#######################
## PLOTS

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
