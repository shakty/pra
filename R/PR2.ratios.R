source("PR2.init.R")

pr$d.ratio.selfprev.pubprev <- pr$d.self.previous / pr$d.pub.previous
pr$d.ratio.selfprev.subcur <- pr$d.self.previous / pr$d.subcur

title <- ggtitle("Efficiency of Personal Innovation")
p <- ggplot(pr, aes(d.self.previous, d.pub.previous))
p <- p + geom_jitter(aes(colour=com), alpha=.2)
p <- p + geom_smooth(aes(colour=com),size=2, method=lm, se=FALSE)
p <- p + title + ylab("Group Innovation") + xlab("Personal Innovation")
p
ggsave(file="./img/ratios/efficiency_personal_inn.jpg")

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



p <- ggplot(pr, aes(com, d.ratio.selfprev.pubprev))
p + geom_bar()
            
p <- p + geom_bar(aes(filling = 1, colour = com, alpha=published))
p


  p <- ggplot(pr, aes(d.self.previous, d.sub.current))
  p <- p + geom_point(aes(group = 1, colour = com, alpha=published))
  p


mm <- ddply(pr, "d.ratio.selfprev.pubprev", summarise, d.ratio.sppp = mean(d.ratio.selfprev.pubprev))

b <- summaryPlayers(pr, "d.ratio.selfprev.pubprev", c("session", "p.id"), TRUE)

p <- ggplot(pr, aes(d.self.previous, d.sub.current))
p <- p + geom_bar(aes(group = 1, colour = com, alpha=published))
p
