

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
