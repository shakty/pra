# InGroup
#########

#pr.setwd(datadir, 'com_aggregate')

ingroup <- read.csv(file="./ingroup/all_reviews.csv", head=TRUE, sep=",")
head(ingroup)


# boxplot(ingroup$score ~ ingroup$same)

# mean eva for different colors

ingroup.same <- ingroup[ingroup$same == 1,]
head(ingroup.same)


ingroup.other <- ingroup[ingroup$same != 1,]
head(ingroup.other)


stats.in = summary(ingroup.same$score)
stats.out = summary(ingroup.other$score)

# are mean different?
t = t.test(ingroup.same$score, ingroup.other$score)

n = length(ingroup.same$score)
sigma = sd(ingroup.same$score) / sqrt(n)
meanIn = as.numeric(stats.in["Mean"])
meanOut = as.numeric(stats.out["Mean"])
diffMeans = meanIn - meanOut
test = diffMeans / sigma
test


alpha = .05
t.half.alpha = qt(1-alpha/2, df=n-1)
c(-t.half.alpha, t.half.alpha)

R2 = test^2 / (test^2 + n - 1)
R2


# plot.ts(cbind(ingroup=ingroup.same$score, outgroup=ingroup.other$score),
# main='Review scores for in-group and out-group (color)',
# xlab='time')

jpeg('./ingroup/img/reviews_in_out_ts.jpg', quality=100, width=600)
old = par(mfrow=c(2,1), oma = c(0,0,3,0))
plot.ts(ingroup.same$score,
        main='In-group',
        xlab='time',
        ylab="score")
plot.ts(ingroup.other$score,
        main='Out-group',
        ylab="score",
        xlab='time')
mtext("Review scores for in-group and out-group (color)", outer = TRUE )
par(old)
dev.off()

jpeg('./ingroup/img/reviews_in_out_boxplot.jpg', quality=100, width=600)
old = par(oma = c(3,0,0,0))
boxplot(list(ingroup=ingroup.same$score, outgroup=ingroup.other$score),
        main="Distribution of review scores for ingroup and outgroup (color)",
        ylab="Score")
txt = sprintf('In-mean = %f, Out-mean = %f, t(%i) = %f, p < .05', meanIn, meanOut, (n-1), test)
#txt = 'Difference is statistically not significant p < .1'
mtext(txt, side = 1, outer=FALSE, padj=5)
par(old)
dev.off()

#library(ggplot2)
#qplot(score, data=ingroup,col = as.factor(ingroup$same), beside=TRUE)


ingroup.players <- read.csv(file="./ingroup/player_reviews.csv", head=TRUE, sep=",")
head(ingroup.players)



names(ingroup.players)


scorecolumns <- regexpr("score", names(ingroup.players)) > 0

ingroup.scores <- ingroup.players[scorecolumns]
ingroup.scores

jpeg('./ingroup/img/reviews_players_ts.jpg', quality=100, width=600)
plot(zoo(ingroup.scores),
     ylim=c(0,10),
     main="Evolution of individual review scores in time",
     xlab='Rounds')     
dev.off()

