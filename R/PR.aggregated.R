#######################
# Diff Self

pr.setwd(datadir, 'com_aggregate')
#pr.setwd(datadir, 'coo_aggregate')

# player with the previous submission      
diffFacesPlayers <- read.csv(file="./diff/global/consensus.csv", head=TRUE, sep=",")
diffFacesPlayers = diffFacesPlayers[-1] # for aggregated data

diffFacesPlayers$round <- factor(diffFacesPlayers$round, levels=seq(1:30))
diffFacesPlayers$session <- as.factor(diffFacesPlayers$session)
diffFacesPlayers$file <- as.factor(diffFacesPlayers$file)

summary(diffFacesPlayers)



jpeg('diff/global/img/diff_faces_x_round_x_player_self.jpg', quality=100, width=600)      


boxplot(diffFacesPlayers, main="Distributions of difference between two subsequent submissions")


dev.off()

# mean x round
diffFacesPlayers.clean = diffFacesPlayers[-1] # for aggregated data
avgRoundFaceDiffPrevious = rowMeans(diffFacesPlayers.clean, na.rm = FALSE, dims = 1)


jpeg('diff/global/img/diff_faces_x_round_x_player_self_detail.jpg', quality=100, width=600)  
plot.ts(avgRoundFaceDiffPrevious, type='o', main="Average face innovation per round", ylab="Normalized (0-1) face difference")
fit <- lm(avgRoundFaceDiffPrevious ~ seq(1:length(avgRoundFaceDiffPrevious)))
abline(fit, col="2", lty=2)
dev.off()


# TODO: Check if this is printed somewhere else??
#plot.ts(diffFacesPlayers, type='o', ylim=rep(c(0,200),9))
#
#plot.ts(diffFacesPlayers, type='o', ylim = c(0,0.6), plot.type="single",  col = colors)
#legend(0.5,0.6, colnames(diffFacesPlayers), col = colors, lty = rep(1,9), lwd = rep (2,9), ncol = 3)


# player with the average submission of the round
avgDiffFacesPlayers <- read.csv(file="./diff/global/diff_faces_x_round_x_player_mean.csv", head=TRUE, sep=",")
summary(avgDiffFacesPlayers)
#boxplot(avgDiffFacesPlayers)

# mean x round
avgdiffFacesPlayers.clean = avgDiffFacesPlayers[-1] # for aggregated data
avgRoundFaceDiff = rowMeans(avgdiffFacesPlayers.clean, na.rm = FALSE, dims = 1)

jpeg('diff/global/img/diff_faces_x_round_x_player_mean_detail.jpg', quality=100, width=600)
plot.ts(avgRoundFaceDiff, type='o', main="Average face difference per round", ylab="Normalized (0-1) face difference")
fit <- lm(avgRoundFaceDiff ~ seq(1:length(avgRoundFaceDiff)))
abline(fit, col="2", lty=2)
dev.off()

# TODO: Check if this is printed somewhere else??
#plot.ts(avgDiffFacesPlayers, type='o',ylim=rep(c(0,200),4))
#plot.ts(avgDiffFacesPlayers, type='o', col = colors, ylim=range(avgDiffFacesPlayers), plot.type="single")
#legend(0.5,0.5, colnames(diffFacesPlayers), col = colors, lty = rep(1,9), lwd = rep (2,9), ncol = 3)
