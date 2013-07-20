source("PR2.init.R")


# Cleaning PR times
#pr <- read.table(file="./allnew.csv", head=TRUE, sep=",")

LOVE = 9.5
HATE = 0.5

pr.ass.love.all <- pr$e.mean > LOVE
pr.ass.kill.all <- pr$e.mean < HATE


title <- ggtitle("A.S.S.+ reviews counts by level of competition")
p <- ggplot(pr[!is.na(pr$ass),], aes(as.factor(ass)))
p <- p + geom_bar(aes(colour = com, fill=com), position="dodge", na.rm=TRUE)
p <-  p + title + ylab("Count") + xlab("A.S.S.+ levels")
p
ggsave(file="./img/ass/assplus_reviews_count.jpg")


title <- ggtitle("A.S.S. reviews counts by level of competition")
p <- ggplot(pr[!is.na(pr$ass.kill),], aes(as.factor(ass.kill)))
p <- p + geom_bar(aes(colour = com, fill=com), position="dodge", na.rm=TRUE)
p <-  p + title + ylab("Count") + xlab("A.S.S. levels")
p
ggsave(file="./img/ass/ass_reviews_count.jpg")



title <- ggtitle("Average A.S.S.+ index in time")
p <- ggplot(pr, aes(round, ass))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("A.S.S. index") + xlab("Round")
p
ggsave(file="./img/ass/assplus_reviews_intime.jpg")

title <- ggtitle("Average A.S.S. index in time")
p <- ggplot(pr, aes(round, ass.kill))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("A.S.S. index") + xlab("Round")
p
ggsave(file="./img/ass/ass_reviews_intime.jpg")


MAXSTD <- sqrt(6.66^2 + 3.33^2 + 3.33^2)
pr$r.consensus <- 1 - pr$r.std / MAXSTD


title <- ggtitle("Consensus among referees")
p <- ggplot(pr, aes(round, r.consensus))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2)
p <- p + title + ylab("Consensus Idx") + xlab("Round")
p
ggsave(file="./img/ass/consensus_referees.jpg")

# Test T


meanconscom <- mean(pr[pr$round == 1 & pr$com == 1, "r.consensus"])
meanconscoo <- mean(pr[pr$round == 1 & pr$coo == 1, "r.consensus"], na.rm = TRUE)

meanconscom.final <- mean(pr[pr$round == 30 & pr$com == 1, "r.consensus"])
meanconscoo.final <- mean(pr[pr$round == 30 & pr$coo == 1, "r.consensus"], na.rm = TRUE)

# Drops in %
1 - meanconscom.final / meanconscom
1 - meanconscoo.final / meanconscoo 


test.t <- t.test(r.consensus ~ com, data=pr)
test.t


# Test T on averages 1 player x session: 144 obs

groupvars <- c("session", "p.number")
p.summary.r.consensus <- summaryPlayers(pr, "r.consensus", groupvars, na.rm=TRUE)

summary.player <- merge(overviewPlayers, p.summary.r.consensus)

test.t <- t.test(r.consensus ~ com, data=summary.player)
test.t

# Test T on averages 1 x session: 16 obs: significant!

groupvars <- c("session")
s.summary.r.consensus <- summaryPlayers(pr, "r.consensus", groupvars, na.rm=TRUE)

summary.session <- merge(overview, s.summary.r.consensus)

test.t <- t.test(r.consensus ~ com, data=summary.session)
test.t

# p <- p  + geom_jitter(aes(colour = com))

prcopy <- pr[pr$round > 2,]
prcopy <- pr

a <- summaryPlayers(prcopy, "time.review", c("session", "p.number"), TRUE)
a <- merge(a, overview)
b <- summaryPlayers(prcopy, "time.creation", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "time.dissemination", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "r.mean", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "e.mean", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.pub.previous", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.sub.current", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "d.self.previous", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.kill", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.love", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.kill.all", c("session", "p.number"), TRUE)
a <- cbind(a, b)
b <- summaryPlayers(prcopy, "ass.love.all", c("session", "p.number"), TRUE)
a <- cbind(a, b)


b <- summaryPlayers(prcopy, "d.pub.previous", c("session"), TRUE)
overview <- merge(b, overview)

b <- summaryPlayers(prcopy, "d.self.previous", c("session"), TRUE)
overview <- merge(b, overview)

b <- summaryPlayers(prcopy, "d.sub.current", c("session"), TRUE)
overview <- merge(b, overview)



title <- ggtitle("A.S.S. reviewers counts by level of competition")
p <- ggplot(a, aes(ass.kill))
p <- p + geom_bar(aes(fill = com), colour="white", binwidth=0.25)
p <- p + title + ylab("Counts") + xlab("A.S.S. levels") #+ scale_x_discrete(breaks=c(0, 0.2, 1))
p
ggsave(file="./img/ass/asscounts_by_competition.jpg")

title <- ggtitle("A.S.S.+ reviewers counts by level of competition")
p <- ggplot(a, aes(ass))
p <- p + geom_bar(aes(fill = com), colour="white", binwidth=0.25)
p <- p + title + ylab("Counts") + xlab("A.S.S.+ levels") #+ scale_x_discrete(breaks=c(0, 0.2, 1))
p
ggsave(file="./img/ass/asspluscounts_by_competition.jpg")


sumPubs <- function(xx, col) {
  c(npubs = sum(as.numeric(xx[,col])-1, na.rm=TRUE))
}
a$npubs = ddply(prcopy,  c("session", "p.number"), .drop = TRUE, .fun = sumPubs, "published")$npubs


p <- ggplot(a, aes(ass, d.sub.current))
p <- p + geom_point(aes(group = 1, colour = session), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

acoo <- a[a$coo ==1,]
p <- ggplot(acoo, aes(ass.love, npubs))
p <- p + geom_line(aes(group = 1, colour = session), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p <- p + facet_grid(session~., margins = T);
p

## A.S.S.,KILL and npubs
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


