# Within same exhibition
########################

diffSameEx <- read.csv(file="./diff/same_ex/diff_subs_by_ex.csv", head=TRUE, sep=",")
summary(diffSameEx)

my.ts.panel <- function(x, col = col, bg = bg, pch = pch, type = type,  vpos=8.75, ...) {
   lines(x, col = col, bg = bg, pch = pch, type = type, ...)                
   fit <- lm(x ~ seq(1:30))
   abline(fit, col="2", lty=2)
}

jpeg('diff/same_ex/img/diff_subs_ex.jpg', quality=100, width=600)
plot.ts(diffSameEx,
        type='o',
        main="Average difference of paintings submitted to the same exhibition per round",
        ylab="Normalized (0-1) face difference",
        xlab="Rounds",
        panel=my.ts.panel)
dev.off()

# Only published ones
diffSameEx.pub <- read.csv(file="./diff/same_ex/diff_pubs_by_ex.csv", head=TRUE, sep=",")
summary(diffSameEx.pub)

jpeg('diff/same_ex/img/diff_pubs_ex.jpg', quality=100, width=600)
plot.ts(diffSameEx.pub,
        type='o',
        main="Average difference of paintings published in the same exhibition per round",
        ylab="Normalized (0-1) face difference",
        panel=my.ts.panel)
dev.off()

#######################


# Between exhibition
########################
#pr.setwd(datadir, 'coo_rnd_orig');

diffBetweenEx <- read.csv(file="./diff/same_ex/diff_subs_ex_from_ex_by_ex.csv", head=TRUE, sep=",")
summary(diffBetweenEx)

my.ts.panel <- function(x, col = col, bg = bg, pch = pch, type = type,  vpos=8.75, ...) {
   lines(x, col = col, bg = bg, pch = pch, type = type, ...)                
   fit <- lm(x ~ seq(1:30))
   abline(fit, col="2", lty=2)
}

jpeg('diff/same_ex/img/diff_subs_ex_from_ex.jpg', quality=100, width=600)

plot.ts(diffBetweenEx,
        type='o',
        main="Average exhibition specialization per round",
        ylab="Normalized (0-1) face difference",
        xlab="Rounds",
        panel=my.ts.panel)

dev.off()

# Only published ones
diffSameEx.pub <- read.csv(file="./diff/same_ex/diff_pubs_by_ex.csv", head=TRUE, sep=",")
summary(diffSameEx.pub)

jpeg('diff/same_ex/img/diff_pubs_ex.jpg', quality=100, width=600)
plot.ts(diffSameEx.pub,
        type='o',
        main="Average difference of paintings published in the same exhibition per round",
        ylab="Normalized (0-1) face difference",
        panel=my.ts.panel)
dev.off()
