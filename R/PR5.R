source("PR2.init.R")
library(gvlma)

# All obs

# Innovation: significant!
fit1 <- lm(100*d.pub.previous ~ com + choice, data=pr)
summary(fit1)

# Diversity: significant!
fit1 <- lm(100*d.sub.current ~ com + choice, data=pr)
summary(fit1)

# Self Innovation: little significant!
fit1 <- lm(100*d.self.previous ~ com + choice, data=pr)
summary(fit1)

# Creation Time: significant!
fit1 <- lm(100*time.creation ~ com + choice, data=pr)
summary(fit1)

# Test t for difference in time significant
test.t.time.creation <- t.test(time.creation ~ com, data=pr)
test.t.time.creation

# One obs per session!!! -> 16 obs
###################################

groupvars <- c("session")
#measurevars <- c("time.creation", "d.pub.previous", "d.pub.cumulative", "d.sub.current")


s.time.creation <- summaryPlayers(pr, "time.creation", groupvars, na.rm=TRUE) 
s.diversity <- summaryPlayers(pr, "d.sub.current", groupvars, na.rm=TRUE)
s.innovation <- summaryPlayers(pr, "d.pub.previous", groupvars, na.rm=TRUE)
s.own.innovation <- summaryPlayers(pr, "d.self.previous", groupvars, na.rm=TRUE)                                   

summary.session <- merge(overview, s.time.creation)
summary.session <- merge(summary.session, s.diversity)
summary.session <- merge(summary.session, s.innovation)
summary.session <- merge(summary.session, s.own.innovation)

# Innovation: not significant (close though..)
fit1 <- lm(100*d.pub.previous ~ com + choice, data=summary.session)
summary(fit1)

# Diversity: not significant
fit1 <- lm(100*d.sub.current ~ com + choice, data=summary.session)
summary(fit1)

# Self Innovation: not significant
fit1 <- lm(100*d.self.previous ~ com + choice, data=summary.session)
summary(fit1)

# Time for creation: little significant!
fit1 <- lm(100*time.creation ~ com + choice, data=summary.session)
summary(fit1)

# test t

# diversity: significant!
test.t.div <- t.test(100*d.sub.current ~ com, data=summary.player)
test.t.div

# inno: significant!
test.t.inno <- t.test(100*d.pub.previous ~ com, data=summary.player)
test.t.inno

# self inno: not significant!
test.t.self.inno <- t.test(100*d.self.previous ~ com, data=summary.player)
test.t.self.inno

# time creation little significant (p<0.5)
test.t.time.creation <- t.test(time.creation ~ com, data=summary.session)
test.t.time.creation

# One obs per subject per session!! -> 144 obs
##############################################

groupvars <- c("session", "p.number")

p.time.creation <- summaryPlayers(pr, "time.creation", groupvars, na.rm=TRUE)
p.diversity <- summaryPlayers(pr, "d.sub.current", groupvars, na.rm=TRUE)
p.innovation <- summaryPlayers(pr, "d.pub.previous", groupvars, na.rm=TRUE)
p.own.innovation <- summaryPlayers(pr, "d.self.previous", groupvars, na.rm=TRUE)

summary.player <- merge(overviewPlayers, p.time.creation)
summary.player <- merge(summary.player, p.diversity)
summary.player <- merge(x=summary.player, y=p.innovation)
summary.player <- merge(summary.player, p.own.innovation)

# Innovation: significant
fit1 <- lm(100*d.pub.previous ~ com + choice, data=summary.player)
summary(fit1)

# Diversity: significant
fit1 <- lm(100*d.sub.current ~ com + choice, data=summary.player)
summary(fit1)

# Self Innovation: not significant
fit1 <- lm(100*d.self.previous ~ com + choice, data=summary.player)
summary(fit1)

# Time for creation: significant!
fit1 <- lm(100*time.creation ~ com + choice, data=summary.player)
summary(fit1)


# t.tests

# diversity: significant!
test.t.div <- t.test(100*d.sub.current ~ com, data=summary.player)
test.t.div

# inno: significant!
test.t.inno <- t.test(100*d.pub.previous ~ com, data=summary.player)
test.t.inno

# self inno: not significant!
test.t.self.inno <- t.test(100*d.self.previous ~ com, data=summary.player)
test.t.self.inno

# creation time: significant! (p<0.01)
test.t.time.creation <- t.test(time.creation ~ com, data=summary.player)
test.t.time.creation

## Redo plot p.28 DENSITY of review scores (from ggplot2,R)
p.evas <- ggplot(evas, aes(x=value, group=com, colour=com))

p.evas.density <- p.evas + geom_density(aes(fill=com),alpha=0.3)
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings by level of competition") 
p.evas.density.title<- p.evas.density.title + xlab('Rating') + ylab('Density')
p.evas.density.title


p.evas <- ggplot(evas, aes(x=value, group=rand, colour=rand))

p.evas.density <- p.evas + geom_density(aes(fill=rand),alpha=0.3)
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings by reviewer choice") 
p.evas.density.title<- p.evas.density.title + xlab('Rating') + ylab('Density')
p.evas.density.title
ggsave(file="./img/evas/eva_density_by_reviewer_choice.jpg")
# no significant differences at visual analysis

p.evas <- ggplot(evas, aes(x=value, group=same.ex, colour=same.ex))
p.evas.density <- p.evas + geom_density(aes(fill=same.ex),alpha=0.3)
p.evas.density <- p.evas.density + xlab('Rating') + ylab('Density')
p.evas.density <- p.evas.density + scale_fill_manual(values=c("#E69F00", "#56B4E9"),
                                                            name="Exhibition",
                                                            labels=c("Another", "Same"))
p.evas.density <- p.evas.density + scale_colour_manual(values=c("#E69F00", "#56B4E9"),
                                                              name="Exhibition",
                                                              labels=c("Another", "Same"))
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings for direct competitors")


# faceting by competition
p.evas.density.title <- p.evas.density.title + facet_grid(~com, labeller=myLabeller)
p.evas.density.title  + theme(strip.text.x = element_text(size=16, face="bold"))
ggsave(file="./img/evas/eva_density_same_ex_or_not_new_colors_facet_com.jpg")

# faceting by review choice
p.evas.density.title <- p.evas.density.title + facet_grid(~rand, labeller= myLabeller)
p.evas.density.title + theme(strip.text.x = element_text(size=16, face="bold"))
ggsave(file="./img/evas/eva_density_same_ex_or_not_new_colors_facet_reviewer.jpg")
# strip.background = element_rect(colour="red", fill="#CCCCFF"))

# Do x and y come from the same distribution?
x = evas[evas$com == 1 & evas$same.ex == 1,"value"]
y = evas[evas$com == 1 & evas$same.ex == 0,"value"]
ks.test(x, y)

# Do x and y come from the same distribution?
x = evas[evas$rand == 1,"value"]
y = evas[evas$rand == 0,"value"]
ks.test(x, y)


myLabeller <- function(var, value){
  value <- as.character(value)
  if (var == "rand") { 
    value[value== 0] <- "Strategic"
    value[value== 1] <- "Random"
  }
  else if (var == "com") {
    value[value== 0] <- "Non competitive"
    value[value== 1] <- "Competitive"
  } 
  return(value)
}


### Abstract faces: ALL OBS

ABS.TS <- 15;
pr$abs.hr <- pr$f.head_radius < ABS.TS
MAX <- 90

p.abs <- ggplot(pr, aes(x=round, y = MAX - f.head_radius))
p.abs <- p.abs + geom_jitter(aes(colour=com), alpha=.3)
p.abs <- p.abs + geom_smooth(aes(colour=com), size=2)
p.abs <- p.abs + xlab('Rounds') + ylab('Zoom Level')
p.abs <- p.abs + scale_colour_discrete(name="Competition", labels=c("Low", "High"))
p.abs <- p.abs + ggtitle("Zoom level in time by level of competition")
p.abs <- p.abs + geom_abline(intercept=MAX-ABS.TS, slope=0)
#p.abs <- p.abs + annotate("rect", xmin = 0, xmax = 31, ymin = MAX - ABS.TS, ymax = MAX,
  alpha = .2)
p.abs <- p.abs + annotate("text", x = 3, y = 82, label = "Abstract zone")
p.abs
ggsave(file="./img/abs/zoom_levesl_by_competition.jpg")

p.abs <- ggplot(pr, aes(x=round, y = MAX - f.head_radius))
p.abs <- p.abs + geom_jitter(aes(colour=rand), alpha=.3)
p.abs <- p.abs + geom_smooth(aes(colour=rand), size=2)
p.abs <- p.abs + xlab('Rounds') + ylab('Zoom Level')
p.abs <- p.abs + scale_colour_discrete(name="Reviewer choice", labels=c("Random", "History"))
p.abs <- p.abs + ggtitle("Zoom level in time by reviewer choice condition")
p.abs <- p.abs + geom_abline(intercept=MAX-ABS.TS, slope=0, linetype="dashed", colour="darkred", size=2)
#p.abs <- p.abs + annotate("rect", xmin = 0, xmax = 31, ymin = MAX - ABS.TS, ymax = MAX,
  alpha = .2)
p.abs <- p.abs + annotate("text", x = 3, y = 82, label = "Abstract zone")
p.abs
ggsave(file="./img/abs/zoom_levesl_by_review_choice.jpg")




# does not seem that abstract faces have an advantage in general
p <- ggplot(pr, aes(f.head_radius, e.mean))
p <- p + geom_point()
p




fit <- lm(f.head_radius ~ com + choice, data = pr)
summary(fit)


p <- ggplot(pr[pr$round > 20,], aes(f.head_radius, e.mean))
p <- p + geom_point()
p

fit <- glm(published ~ abs.hr, data = pr, family="binomial")
summary(fit)

fit <- glm(published ~ abs.hr, data = pr[pr$round < 21,], family="binomial")
summary(fit)

# Does not correlate with com or choice
fit <- lm(abs.hr ~ com + choice, data = pr)
summary(fit)

# In the last 10 rounds more abstract faces have a bonus
fit <- glm(published ~ abs.hr, data = pr[pr$round > 20,], family="binomial")
summary(fit)

# In the last 10 rounds more abstract faces have a bonus under NON-COM cond
fit <- glm(published ~ abs.hr, data = pr[pr$round > 20 & pr$com == 0,], family="binomial")
summary(fit)

# In the last 10 rounds more abstract faces do NOT have a bonus under COM cond
fit <- glm(published ~ abs.hr, data = pr[pr$round > 20 & pr$com == 1,], family="binomial")
summary(fit)


fit <- lm(e.mean ~ com + abs.hr + round, data = pr)
summary(fit)



table(pr$abs.hr, pr$com, pr$published)

# repeating the glm with averages on player levels (1obs x player x session = 144)
groupvars <- c("session", "p.number")

p.abs201 <- summaryPlayers(pr[pr$round > 20 & pr$com == 0 & pr$abs.hr == 1,], "e.mean", groupvars, na.rm=TRUE)

p.abs200 <- summaryPlayers(pr[pr$round > 20 & pr$com == 0 & pr$abs.hr == 0,], "e.mean", groupvars, na.rm=TRUE)

t.test(p.abs201$e.mean, p.abs200$e.mean)

p.abs201 <- pr[pr$round > 20 & pr$com == 0 & pr$abs.hr == 1,]
p.abs200 <- pr[pr$round > 20 & pr$com == 0 & pr$abs.hr == 0,]
t.test(p.abs201$e.mean, p.abs200$e.mean)


summary.player <- merge(overviewPlayers, p.time.creation)



### Abs faces: 1 per session -> 16
groupvars <- c("session")
s.f.head_radius <- summaryPlayers(pr, "f.head_radius", groupvars, na.rm=TRUE)
summary.abs.session <- merge(overview, s.f.head_radius)

# not significant
fit <- lm(f.head_radius ~ com + choice, data = summary.abs.session)
summary(fit)

### Abs faces 1 per session split-up

# Last 10 rounds
s2030.f.head_radius <- summaryPlayers(pr[pr$round > 20,], "f.head_radius", groupvars, na.rm=TRUE)
s2030.e.mean <- summaryPlayers(pr[pr$round > 20,], "e.mean", groupvars, na.rm=TRUE)

summary.abs.session2030 <- merge(overview, s2030.f.head_radius)
summary.abs.session2030 <- merge(summary.abs.session2030, s2030.e.mean)

# not significant
fit <- lm(e.mean ~ f.head_radius, data = summary.abs.session2030)
summary(fit)


### Abs faces: 1 per subject per session -> 144
groupvars <- c("session", "p.number")
p.f.head_radius <- summaryPlayers(pr, "f.head_radius", groupvars, na.rm=TRUE)
summary.abs.player <- merge(overview, p.f.head_radius)

# little significant
fit <- lm(f.head_radius ~ com + choice, data = summary.abs.player)
summary(fit)

### Consistent reviewers: Difference between face submitted by a reviewer and face reviewed and score
#####################################################################################################

getFace <- function(session, round, p.id, data=pr) {
  return(data[data$session == session & data$round == round & data$p.id == p.id,13:25])
}

getFaceDist <- function(f1, f2, method="euclidian") {
  if (any(is.na(f1)) | any(is.na(f2))) {
    return(NA)
  }
  else {
    f <- as.matrix(rbind(f1,f2))
    return(dist(f, method=method))
  }
}


pr$e1.d <- NA
pr$e2.d <- NA
pr$e3.d <- NA
pr$e.d <- NA
pr$e1.d.pub.previous <- NA
pr$e2.d.pub.previous <- NA
pr$e3.d.pub.previous <- NA

# This takes a long to execute...
# Need to re-run evas afterwards
for (s in unique(pr$session)) {
  for (r in unique(pr$round)) {
    tmp <- pr[pr$session == s & pr$round == r,]
    for (p in unique(tmp$p.id)) {
      row <- tmp[tmp$p.id == p,]
      f <- getFace(s,r,p,tmp) # own face
      f1 <- getFace(s,r,row$e1.id,tmp)
      f2 <- getFace(s,r,row$e2.id,tmp)
      f3 <- getFace(s,r,row$e3.id,tmp)
      f1d <- getFaceDist(f,f1)
      f2d <- getFaceDist(f,f2)
      f3d <- getFaceDist(f,f3)
      # this works as long as p.id is unique across all sessions
      # somehow I cannot select both session and p.id ...
      pr[pr$round == r & pr$p.id == p,]$e1.d <- f1d
      pr[pr$round == r & pr$p.id == p,]$e2.d <- f2d
      pr[pr$round == r & pr$p.id == p,]$e3.d <- f3d
      pr[pr$round == r & pr$p.id == p,]$e.d <- mean(c(f1d,f2d,f3d))
      # for convenience adding diff from d.pub.previous
      pr[pr$round == r & pr$p.id == p,]$e1.d.pub.previous <- ifelse(is.na(row$e1.id), NA, tmp[tmp$p.id == row$e1.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e2.d.pub.previous <- ifelse(is.na(row$e2.id), NA, tmp[tmp$p.id == row$e2.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e3.d.pub.previous <- ifelse(is.na(row$e3.id), NA, tmp[tmp$p.id == row$e3.id, "d.pub.previous"])
    }
  }
}

# JUST pub.prev
for (s in unique(pr$session)) {
  for (r in unique(pr$round)) {
    tmp <- pr[pr$session == s & pr$round == r,]
    for (p in unique(tmp$p.id)) {
      row <- tmp[tmp$p.id == p,]
      # for convenience adding diff from d.pub.previous
      pr[pr$round == r & pr$p.id == p,]$e1.d.pub.previous <- ifelse(is.na(row$e1.id), NA, tmp[tmp$p.id == row$e1.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e2.d.pub.previous <- ifelse(is.na(row$e2.id), NA, tmp[tmp$p.id == row$e2.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e3.d.pub.previous <- ifelse(is.na(row$e3.id), NA, tmp[tmp$p.id == row$e3.id, "d.pub.previous"])
    }
  }
}

names.pr <- names(pr)
pr.melted <- melt(pr, id=names.pr[c(-64, -70, -76)])
evas <- data.frame()
for (e in c("e1", "e2", "e3")) {
  mydata <- pr.melted[pr.melted$variable == e, ]
  sameex <- paste0(e, ".same.ex")
  samecol <- paste0(e, ".same.color")
  d <- paste0(e, ".d")
  pub.prev <- paste0(e, ".d.pub.previous")
  sameex.column <- with(mydata, get(sameex))
  samecol.column <- with(mydata, get(samecol))
  d.column <- with(mydata, get(d))
  pub.prev.column <- with(mydata, get(pub.prev))
  metadata <- mydata[,sessions.ids]
  myeva <- data.frame(metadata,
                      round=mydata$round,
                      changed=mydata$e.changed,
                      copy=mydata$copy, published=mydata$published,
                      order=mydata$variable, value=mydata$value,
                      same.ex=sameex.column, same.color=samecol.column,
                      dist=d.column, d.pub.prev=pub.prev.column)  
  evas <- rbind(evas, myeva) 
}
evas$same.ex <- as.factor(evas$same.ex)
evas$same.color <- as.factor(evas$same.color)
evas$same.changed <- as.factor(evas$changed)


p <- ggplot(evas, aes(x=dist,y=value))
p + geom_point(aes(colour=com))


# Todo take difference from previous published stuff


evas$consistent <- evas$dist / max(evas$dist, na.rm = T) - (evas$value / 10)

p <- ggplot(evas, aes(x=dist, y=value))
p + geom_point(aes(colour=com)) + facet_grid(session~.)


p <- ggplot(evas, aes(x=round,y=consistent))
p + geom_jitter(aes(colour=com)) + geom_smooth(aes(group=com, color=com))

# it seems that coo and com are equally consistent
p <- ggplot(evas, aes(x=consistent, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=0.3)
p


#
DIST.TS <- 25
evas$inconsistent <- evas$dist < DIST.TS & evas$value < 5
table(evas$inconsistent, evas$com)

DIST.TS2 <- 100
evas$inconsistent2 <- evas$dist > DIST.TS2 & evas$value > 5
table(evas$inconsistent2, evas$com)


# It seems that COM accepts those who are very different a little more than COO
# It seems that COO punishes those who are very similar more than COM

p <- ggplot(evas, aes(inconsistent2))
p + geom_bar(aes(colour=com, fill=com),position="dodge")


p <- ggplot(evas, aes(x=d.pub.prev,y=value))
p + geom_point(aes(colour=com))


DIST.TS <- 0.1
evas$inconsistent <- evas$d.pub.prev < DIST.TS & evas$value > 5 & evas$value > 0.5
table(evas$inconsistent, evas$com, evas$same.ex)


# Diversity is welcome, as long as it is not in my exhibition!
DIST.TS2 <- 0.4
evas$inconsistent2 <- evas$d.pub.prev > DIST.TS2 & evas$value > 5
table(evas$inconsistent2, evas$com)

DIST.TS2 <- 0.4
evas$inconsistent2 <- evas$d.pub.prev > DIST.TS2 & evas$value > 5
table(evas$inconsistent2, evas$com, evas$same.ex)

table(evas$inconsistent, evas$com) / table(evas$d.pub.prev > DIST.TS2, evas$com)

table(evas$d.pub.prev > DIST.TS2 & evas$value > 5, evas$com) / table(evas$d.pub.prev > DIST.TS2, evas$com)


table(evas$d.pub.prev > 0.1, evas$com)

cutLabels <- c("Very Low", "Low", "Medium", "High", "Very High")
evas$d.prev.pub.cut <- cut(evas$d.pub.prev, breaks=seq(0,max(evas$d.pub.prev, na.rm = T),0.1), labels=cutLabels)

table(evas$d.prev.pub.cut, evas$com)

a <- table(evas$d.prev.pub.cut, evas$com, evas$positive)

evas$positive <- evas$value > 5
evas.clean <- evas[!is.na(evas$d.prev.pub.cut) & !is.na(evas$positive),]

p1 <- ggplot(evas.clean, aes(fill=com)) + geom_histogram(aes(x=d.prev.pub.cut), color="black", position="dodge")

p2 <-

  ggplot(evas.clean, aes(fill=com)) + geom_histogram(aes(x=d.prev.pub.cut), color="black", position="dodge") + facet_wrap(~positive)

library(gridExtra)
grid.arrange(p1,p2)

table(evas$dist.cut)

hist(evas$d.pub.prev)


 ggplot(b, aes(fill=Freq)) + geom_histogram(aes(x=Var1, color=Var2), color="black", position="dodge")

### Color

p.color <- ggplot(evas)
p.color + geom_boxplot(aes(x=same.color, y=value)) + facet_wrap(~com, ncol=4)

color.same <- evas[evas$same.color == 1,]
head(color.same)


color.other <- evas[evas$same.color != 1,]
head(color.other)

# are mean different?
t = t.test(color.same$value, color.other$value)
t
# in general no!

# within a treatment condition?
# competition: NO!
t <- t.test(value ~ same.color, data=evas[evas$com == 1,])
t

# no comp: no, but close...
t <- t.test(value ~ same.color, data=evas[evas$com == 0,])
t

# what if at the beginning we are racist?
# no comp: YES
t <- t.test(value ~ same.color, data=evas[evas$com == 0 & evas$round < 10,])
t

# differences in time
ts = c()
for (r in unique(evas$round)) {
  tmp <- evas[evas$com == 0 & evas$round == r,] # or == r
  t = t.test(value ~ same.color, data = tmp)
  ts <- rbind(ts,c(t$estimate, t$p.value))
}
ts.fr <- data.frame(ts)
colnames(ts.fr) <- c("other","same", "p.value")
ts.fr$diff <- ts.fr$same - ts.fr$other
ts.fr$round <- seq(1:30)

p <- ggplot(ts.fr, aes(x=round, y=diff))
p + geom_line() + ylab("Difference") + xlab("Round") + ggtitle("Difference in evaluation between colors")


p <- ggplot(ts.fr, aes(x=round))
p + geom_line(aes(y=same, color="same")) + geom_line(aes(y=other, color="other")) + ylab("Difference") + xlab("Round") + ggtitle("Evaluations same vs other color non-COM")
ggsave(file="./img/color/same_vs_other_color_ts_nonCOM.jpg")


p <- ggplot(ts.fr, aes(x=round, y=p.value))
p + geom_line()


# In the first 10-12 rounds of the non competitive condition reviewers give a plus to people of the same color


