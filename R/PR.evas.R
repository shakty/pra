## Evaluations
##############
#pr.setwd(datadir, 'com_sel');


# Load file

players <- read.csv(file="./eva/eva_x_player.csv", head=TRUE, sep=",")
summary(players)
#boxplot(players)

#players.ohne3 <- players[, !names(players) %in% c('P_03')]
#summary(players.ohne3)

# Mean review all players
#colMeans(cbind(colMeans(players.ohne3)))
# Mean review all players but P_03
#colMeans(cbind(colMeans(players)))


jpeg('eva/img/players_boxplot.jpg',quality=100,width=600)
boxplot(players,main="Distribution of evaluation scores per player")
dev.off()

# Time Series
jpeg('eva/img/players_eva_ts.jpg',quality=100,width=600)
plot(zoo(players),
       type='o',
       ylim=c(0,10),
       main="Review scores by player by round",
     xlab="Rounds")
dev.off()
#Mean = mean(mean(players))
#Mean
#abline(h=Mean)

# ROUNDS
rounds <- read.csv(file="./eva/eva_x_round.csv", head=TRUE, sep=",")
summary(rounds)
jpeg('eva/img/round_evas_boxplot.jpg',quality=100,width=600)
boxplot(rounds, main="Distribution of evaluation scores per round",ylab="Evaluation score")
dev.off()

meanRounds = apply(rounds, MARGIN=2, mean)
meanRounds

jpeg('eva/img/round_evas_mean.jpg',quality=100,width=600)
plot(meanRounds, main="Evaluation mean per round",ylab="Evaluation score",ylim=c(0,10))
lines(meanRounds)
abline(lm(meanRounds ~ c(1:30)))
dev.off()

varRounds = apply(rounds, MARGIN=2, sd)
varRounds
jpeg('eva/img/round_evas_var.jpg',quality=100,width=600)
plot(varRounds, main="Evaluation standard deviation per round",ylab="Evaluation score",ylim=c(0,10))
lines(varRounds)
dev.off()     
