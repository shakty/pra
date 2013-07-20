source("PR2.init.R")



prcopy <- pr[pr$round > 2,]
prcopy <- pr


#a <- summaryPlayers(prcopy, "time.review", c("session", "p.id"), TRUE)
#a <- merge(a, overview)
a <- summaryPlayers(prcopy, "time.review", c("session", "p.id"), TRUE)
a <- merge(a, overviewPlayers)
b <- summaryPlayers(prcopy, "time.creation", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "time.dissemination", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "r.mean", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "e.mean", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.pub.previous", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.sub.current", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.self.previous", c("session", "p.id"), TRUE)
a <- cbind(a, b)

# ASS and TIME
b <- summaryPlayers(prcopy, "ass.kill", c("session", "p.id"), TRUE)
a <- cbind(a, b)

p <- ggplot(a, aes(log(time.review), ass.kill))
p + geom_point(aes(col=com))

# The more time for creating a painting the less likely they are an ass
# Interestingly, not the more time for a review... (also try the log)
fit <- lm(ass.kill ~ com + choice + time.creation, data=a)
summary(fit)


names(pr.pubs)[2:3] <- c("not.pub","pub")

# SUCCESS and ASS
sumPubs <- function(xx, col) {
  c(npubs = sum(as.numeric(xx[,col])-1, na.rm=TRUE))
}

a$npubs = ddply(prcopy,  c("session", "p.id"), .drop = TRUE, .fun = sumPubs, "published")$npubs

p <- ggplot(a[a$com==1,], aes(ass.kill, npubs))
p + geom_point(aes(col=com))


# CREATION TIME AND SUCCESS

p <- ggplot(a, aes(time.creation, npubs))
p + geom_point(aes(col=com))


# The more time you use for the creation the more likely you are to publish!
fit <- lm(npubs ~ com + choice + time.creation, data=a)
summary(fit)

# This is true in both conditions separately
fit <- lm(npubs ~ time.creation, data=a[a$com==0,])
summary(fit)

## Creation density curve

title <- ggtitle("Density curve for the creation of new paintings")
p <- ggplot(pr, aes(x=time.creation, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=0.3)
p <-  p + title + ylab("Density") + xlab("Time")
p
ggsave(file="./img/timing/timeing_per_round_density.jpg")

## Creation time per round

title <- ggtitle("Time to complete a new painting")
p <- ggplot(pr, aes(round, time.creation))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Time in seconds") + xlab("Round")
p
ggsave(file="./img/timing/timeing_per_round.jpg")

## Test T

test.t.time.creation <- t.test(time.creation ~ com, data=pr)
test.t.time.creation

test.t.time.review <- t.test(time.review ~ com, data=pr)
test.t.time.review

fit <- lm(npubs~time.creation, data=aa)
summary(fit)

fit <- glm(npubs~time.creation, data=aa, family=poisson)

hist(a$time.review)

plot(a$time.dissemination,a$npubs)


title <- ggtitle("Average distance between current submission and the average \n of all published faces, per round per condition")

p.distance <- ggplot(a, aes(round, ))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets

title <- ggtitle("Average distance between submitted faces, per round per condition")

p.distance <- ggplot(pr, aes(round, d.sub.current))
p.distance.facets <- p.distance + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.distance.facets <- p.distance.facets + title
p.distance.facets
ggsave(file="./img/distance/dist_sub_current_facets.jpg")



### Single players self distance
for (s in unique(pr$session)) {

  tmp <- pr[pr$session == s,]
  tmp$p.numberf <- as.factor(tmp$p.number)
  p <- ggplot(tmp, aes(round, d.self.previous))
  p <- p + geom_line(aes(group = p.numberf, colour = p.numberf))
  p
  
}
            
plot(tmp$d.self.previous, tmp$d.pub.previous)

plot(tmp$d.self.previous, tmp$published)


pr$d.ratio.selfprev.pubprev <- pr$d.self.previous / pr$d.pub.previous
pr$d.ratio.selfprev.subcur <- pr$d.self.previous / pr$d.subcur

p <- ggplot(pr, aes(com, d.ratio.selfprev.pubprev))
p + geom_bar()
            
p <- p + geom_bar(aes(filling = 1, colour = com, alpha=published))
p


  p <- ggplot(pr, aes(d.self.previous, d.sub.current))
  p <- p + geom_point(aes(group = 1, colour = com, alpha=published))
  p


mm <- ddply(pr, "d.ratio.selfprev.pubprev", summarise, d.ratio.sppp = mean(d.ratio.selfprev.pubprev))

b <- summaryPlayers(pr, "d.ratio.selfprev.pubprev", c("session", "p.id"), TRUE)

ggplot(mm, aes(x = factor(cyl), y = mmpg)) + geom_bar(stat = "identity")

  p <- ggplot(pr, aes(d.self.previous, d.sub.current))
  p <- p + geom_bar(aes(group = 1, colour = com, alpha=published))
  p
