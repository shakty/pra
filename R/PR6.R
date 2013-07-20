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
