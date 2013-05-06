source("PR2.init.R")


# Cleaning PR times
pr <- read.table(file="./allnew.csv", head=TRUE, sep=",")

pr[!is.na(pr$time.creation) & (pr$time.creation > 150 | pr$time.creation < 0), "time.creation"] <- NA
pr[!is.na(pr$time.dissemination) & (pr$time.dissemination > 150 | pr$time.dissemination < 0), "time.dissemination"] <- NA

LOVE = 9.5
HATE = 0.5

pr.ass.love.all <- pr$e.mean > LOVE
pr.ass.kill.all <- pr$e.mean < HATE

p <- ggplot(pr, aes(as.factor(ass)))
p <- p + geom_bar(aes(colour = com))
p

# p <- p  + geom_jitter(aes(colour = com))

prcopy <- pr[pr$round > 2,]
prcopy <- pr

a <- summaryPlayers(prcopy, "time.review", c("session", "p.id"), TRUE)
a <- merge(a, overview)
b <- summaryPlayers(prcopy, "time.creation", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "time.dissemination", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "r.mean", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "e.mean", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.sub.previous", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.sub.current", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.self.previous", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.kill", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.love", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.kill.all", c("session", "p.id"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.love.all", c("session", "p.id"), TRUE)
a <- cbind(a, b)


sumPubs <- function(xx, col) {
  c(npubs = sum(as.numeric(xx[,col])-1, na.rm=TRUE))
}
a$npubs = ddply(prcopy,  c("session", "p.id"), .drop = TRUE, .fun = sumPubs, "published")$npubs


fit <- glm(npubs~time.review, data=a, family=poisson)

plot(a$time.review,a$npubs)


aa <- a[a$round > 2,]

plot(a$time.creation,a$npubs)

p <- ggplot(a, aes(ass.love.all, npubs))
p <- p + geom_point(aes(group = 1, colour = coo), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

p <- ggplot(pr, aes(x=ass.love, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=0.3)
p


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
