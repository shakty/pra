source("PR2.init.R")

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
