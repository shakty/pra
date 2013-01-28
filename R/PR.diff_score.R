################
# DIFF and SCORE

df <- read.csv(file="./diff/diffandscore/diffandscore.csv", head=TRUE, sep=",")

jpeg('./diff/diffandscore/img/diffandscore.jpg', quality=100, width=600)
plot(df$D ~ df$S, main='Face distance from pub. faces in the previous round vs score', ylab='Distance from published faces in the previous round', xlab='Review score')
abline(v=5, col='red',lwd=2)
abline(v=7, col='orange', lwd=1)
dev.off()


df.copy <- read.csv(file="./diff/diffandscore/diffandscore_copy.csv", head=TRUE, sep=",")

jpeg('./diff/diffandscore/img/diffandscore_copy.jpg', quality=100, width=600)
plot(df.copy$D ~ df.copy$S, main='Face distance from pub. faces in the previous round vs score (just copies)', ylab='Distance from published faces in the previous round', xlab='Review score')
abline(v=5, col='red',lwd=2)
abline(v=7, col='orange', lwd=1)
dev.off()

df.copyoriginal <- read.csv(file="./diff/diffandscore/copy_from_original_andscore.csv", head=TRUE, sep=",")

jpeg('./diff/diffandscore/img/copy_from_original_andscore.jpg', quality=100, width=600)
plot(df.copyoriginal$D ~ df.copyoriginal$S, main='Face distance from original faces vs score', ylab='Distance from published faces in the previous round', xlab='Review score')
abline(v=5, col='red',lwd=2)
abline(v=7, col='orange', lwd=1)
dev.off()
