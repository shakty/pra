################
# DIFF and SCORE

df <- read.csv(file="./diff/diffandscore/diffandscore.csv", head=TRUE, sep=",")
jpeg('./diff/diffandscore/img/diffandscore.jpg', quality=100, width=600)
plot(df$S ~ df$D, main='Face distance from pub. faces in the previous round vs score', xlab='Distance from published faces in the previous round', ylab='Review score')
abline(h=5, col='orange',lwd=2)
#abline(h=7, col='orange', lwd=1)
fit <- lm(df$S ~ df$D)
abline(fit, col="2", lty=1)
dev.off()


df.copy <- read.csv(file="./diff/diffandscore/diffandscore_copy.csv", head=TRUE, sep=",")
jpeg('./diff/diffandscore/img/diffandscore_copy.jpg', quality=100, width=600)
plot(df.copy$S ~ df.copy$D, main='Face distance from pub. faces in the previous round vs score (just copies)', xlab='Distance from published faces in the previous round', ylab='Review score')
abline(h=5, col='orange',lwd=1)
fit <- lm(df.copy$S ~ df.copy$D)
abline(fit, col="2", lty=1)
dev.off()

df.copyoriginal <- read.csv(file="./diff/diffandscore/copy_from_original_andscore.csv", head=TRUE, sep=",")
jpeg('./diff/diffandscore/img/copy_from_original_andscore.jpg', quality=100, width=600)
plot(df.copyoriginal$S ~ df.copyoriginal$D, main='Face distance between copy and original face vs score', xlab='Distance from original face', ylab='Review score')
abline(h=5, col='orange',lwd=1)
fit <- lm(df.copyoriginal$S ~ df.copyoriginal$D)
abline(fit, col="2", lty=1)
dev.off()
