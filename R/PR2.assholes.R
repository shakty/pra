source("PR2.init.R")


# Cleaning PR times
#pr <- read.table(file="./allnew.csv", head=TRUE, sep=",")

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


p <- ggplot(a, aes(ass, npubs))
p <- p + geom_point(aes(group = 1, colour = session, alpha=com), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

acoo <- a[a$coo ==1,]
p <- ggplot(acoo, aes(ass.love, npubs))
p <- p + geom_line(aes(group = 1, colour = session), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p <- p + facet_grid(session~., margins = T);
p

## ASS,KILL and npubs
acom <- a[a$com ==1,]
p <- ggplot(acom, aes(ass.kill, npubs))
p <- p + geom_line(aes(group = 1, colour = session), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p <- p + facet_grid(session~., margins = T);
p


p <- ggplot(acoo, aes(ass.love.all, npubs))
p <- p + geom_point(aes(group = 1, colour = session), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

p <- ggplot(pr, aes(x=ass.love, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=0.3)
p


