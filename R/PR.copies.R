# COPIES
########

#plotDiffFeaturesDir("./copy/")

copies.normalized <- read.csv(file="./copy/copy_x_round_x_player_norm.csv", head=TRUE, sep=",")


jpeg('./copy/img/ts_copy_multiple_normalized.jpg', quality=100, width=600)
plot(zoo(copies.normalized),
     ylim=c(0,1),
     main="How old are the copied faces by each player? (normalized)",
     xlab='Rounds')

dev.off()         

copies.normalized[copies.normalized == 0] = NA
old = par(yaxs="i", las="1")
jpeg('./copy/img/distr_copy_normalized.jpg', quality=100, width=600)
hist(as.matrix(copies.normalized),
     breaks=20,
     main='Distribution: How many rounds away is the original (normalized)',
     col="black", border="white",
     ylim=c(0,70),
     xlab="Normalized distance in round (max=1)")
box(bty="l")
grid(nx=NA, ny=NULL, lty=1, lwd=1, col="gray")
dev.off()
par(old)


copies <- read.csv(file="./copy/copy_x_round_x_player.csv", head=TRUE, sep=",")
realCopies = copies      
realCopies[realCopies == 0] = NA

jpeg('./copy/img/ts_copy_multiple.jpg', quality=100, width=600) 
plot.ts(copies, type='o',ylim=c(0,30),  ylab="The copied face is from N round ago", xlab="Round", main="How old are the copied faces by each player?")
dev.off()

jpeg('./copy/img/ts_copy_single.jpg', quality=100, width=600)
plot.ts(copies, type='o',ylim=c(0,30), plot.type="single", ylab="The copied face is from N round ago", xlab="Round", col = colors, main="How old are the copied faces by each player?")
legend(0.5,30, colnames(copies), col = colors, lty = rep(1,9), lwd = rep (2,9), ncol = 3)
abline(a=0,b=1)
dev.off()
      
# biased      
# boxplot(copies)
      
jpeg('./copy/img/boxplot_copy.jpg', quality=100, width=600)  
boxplot(realCopies, main="How old are the copied faces by each player?", ylab="The copied face is from N round ago", xlab="Player")
dev.off()

copies <- read.csv(file="./copy/copy_diffs.csv", head=TRUE, sep=",")

jpeg('./copy/img/diffs_distr.jpg', quality=100, width=600)
hist(x=copies$DIFFS, breaks=10, xlab="Normalized difference between copied faces", main="Distribution of normalized differences between copied faces" )
#d <- density(copies$DIFFS, from=0, kernel="epanechnikov") # returns the density data
#lines(d, col="red", lwd=4) # plots the results
grid(nx=NA, ny=NULL, lty=1,lwd=1, col="gray")
dev.off()      
