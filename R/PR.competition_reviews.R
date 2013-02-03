# mean eva for submitting to the same exhibition or not
#######################################################

#pr.setwd(datadir, 'coo');
#pr.setwd(datadir, 'com');

ingroup <- read.csv(file="./ingroup/all_reviews.csv", head=TRUE, sep=",")
head(ingroup)

ingroup.sameex <- ingroup[ingroup$sameex == 1,]
ingroup.sameex.changed <- ingroup.sameex[ingroup.sameex$changed == 1,]
head(ingroup.sameex)


ingroup.otherex <- ingroup[ingroup$sameex != 1,]
ingroup.otherex.changed <- ingroup.otherex[ingroup.otherex$changed == 1,]
head(ingroup.otherex)


#plot.ts(ingroup.sameex$score)

stats.inex = summary(ingroup.sameex$score); stats.inex
stats.outex = summary(ingroup.otherex$score); stats.outex


plotEvaSameVsOtherEx(ingroup.sameex, ingroup.otherex,"same_other_ex")

plotEvaSameVsOtherEx(ingroup.sameex.changed, ingroup.otherex.changed, "same_other_ex_changed")
                     
boxplotEvaSameVsOtherEx(ingroup.sameex, ingroup.otherex, "same_other_ex_boxplot")

boxplotEvaSameVsOtherEx(ingroup.sameex.changed, ingroup.otherex.changed, "same_other_ex_boxplot_changed")




# are mean different?
t = t.test(ingroup.otherex$score, ingroup.sameex$score)
t

n = length(ingroup.sameex$score)
sigma = sd(ingroup.sameex$score) / sqrt(n)
meanIn = as.numeric(stats.inex["Mean"])
meanOut = as.numeric(stats.outex["Mean"])
diffMeans = meanIn - meanOut
test = diffMeans / sigma
test


# plot.ts(cbind(ingroup=ingroup.same$score, outgroup=ingroup.other$score),
# main='Review scores for in-group and out-group (color)',
# xlab='time')

jpeg('./ingroup/img/reviews_in_out_ts.jpg', quality=100, width=600)
old = par(mfrow=c(2,1), oma = c(0,0,3,0))
plot.ts(ingroup.sameex$score,
        main='In-group',
        xlab='time',
        ylab="score")
plot.ts(ingroup.otherex$score,
        main='Out-group',
        ylab="score",
        xlab='time')
mtext("Review scores for in-group and out-group (color)", outer = TRUE )
par(old)
dev.off()

jpeg('./ingroup/img/reviews_in_out_boxplot.jpg', quality=100, width=600)
old = par(oma = c(3,0,0,0))
boxplot(cbind(ingroup=ingroup.sameex$score, outgroup=ingroup.otherex$score),
        main="Distribution of review scores for ingroup and outgroup (color)",
        ylab="Score")
txt = sprintf('In-mean = %f, Out-mean = %f, t(%i) = %f, p < .05', meanIn, meanOut, (n-1), test)
#txt = 'Difference is statistically not significant p < .1'
#mtext(txt, side = 1, outer=FALSE, padj=5)
par(old)
dev.off()

#qplot(score, data=ingroup,col = as.factor(ingroup$sameex), beside=TRUE)


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
