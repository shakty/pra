# Submissions
#############

#pr.setwd(datadir, session);

# x player
subPlayers <- read.table(file="./sub/sub_x_round_x_player.csv", head=TRUE, sep=",")
subPlayers

jpeg('sub/img/players_sub_ts.jpg',quality=100,width=600)
plot.ts(subPlayers,type='o', plot.type="multiple", main='Exhibition choice over 30 rounds')
dev.off()


# If we load the _int version we can produce this graph
#subPlayers.int <- read.table(file="./sub/sub_x_round_x_player_int.csv", head=TRUE, sep=",")
#subPlayers.int
#subPlayers.int.jitter = apply(subPlayers.int, 2, jitter, amount=0.05)
#plot.ts(subPlayers.int.jitter, type='p', plot.type="single")

playerSubs <- apply(subPlayers, 2, table)
playerSubs

#oldpar = par(mar=c(5,4,4,8), xpd=T)
#par(oldpar)

jpeg('sub/img/player_subs_all.jpg',quality=100,width=600)
barplot(playerSubs,
        col = brewer.pal(3,"Set1"),
        border="white",
        ylim=c(0,35),
        main='Players submissions by exhibition',
        legend.text = c('A','B','C'),
        args.legend = list(bty="n", horiz=TRUE, x="top"))
dev.off()

winlose <- read.table(file="win_lose/win_lose_all.csv", head=TRUE, sep=",")
head(winlose)

#qplot(P_02_ex, shape=as.factor(P_02_pub), data=winlose)

# test qplot??

#geom_line(aes(group=1), colour="#000099") +  # Blue lines
#geom_point(size=3, colour="#CC0000")         # Red dots
#theme_blank() 
#qplot(data=winlose, ex, color=as.factor(published), shape=ex) 

#facets= round ~ player

#filepath<-"http://dl.dropbox.com/u/1648032/ggplot2_tutorial_dataset.txt"
#read in the tab delimited text file using the url() function
#myData<-read.table(file=url(filepath),header=T,sep="\t")
#qplot(data=myData,x=BM,y=var1,log="xy",color=Tribe,facets = Hab~Tribe)


# x round (not working well)
#subRounds <- read.csv(file="./sub/sub_x_round.csv", head=TRUE, sep=",")

#subRounds.tableF <- apply(subRounds, 2, factor, lev=exhs.names); subRounds.tableF
#subRounds.table <- apply(subRounds.tableF, 2, table); subRounds.table
      
#barplot(do.call(cbind,subRounds.table),
#        col = brewer.pal(3,"Set1"),
#        border="white",
#        legend.text = exhs.names,
#        args.legend = list(bty="n", horiz=TRUE, x="top"))
      
#subRounds.table <- apply(subRounds, 2, table, dnn=c('A','B','C'), row.names=c('A','B','C'))
#subRounds.table

#plot.ts(subRounds.table, type='p', plot.type="single")
      
# x ex round_count (not found!)
#subExRounds.count <- read.csv(file="./sub/sub_x_ex_round_count.csv", head=TRUE, sep=",")

#old = par(mai=c(1,1,1,1))

#jpeg('sub/img/exhibs_count_ts.jpg',quality=100,width=600)
#barplot(as.matrix(subExRounds.count),
#        col = brewer.pal(3,"Set1"),
#        border="white",
#        ylim=c(0,10),
#        main='Submission by exhibition per round',
#        legend.text = exhs.names,
#        args.legend = list(bty="n", horiz=TRUE, x="top"))
#dev.off()

#par(old)

# x ex
subExRound <- read.csv(file="./sub/sub_x_ex_round.csv", head=TRUE, sep=","); subExRound
summary(subExRound)

subExRound.t <- t(subExRound); subExRound.t

jpeg('sub/img/exhibs_count_ts.jpg',quality=100,width=600)
barplot(as.matrix(subExRound.t),
        col = brewer.pal(3,"Set1"),
        border="white",
        ylim=c(0,10),
        main='Submission by exhibition per round',
        legend.text = exhs.names,
        args.legend = list(bty="n", horiz=TRUE, x="top"))
dev.off()

#plot.ts(subExRound, type='o', plot.type="single", col=exhs.colors)
#legend("top", legend=exhs.names, col = exhs.colors, lty = rep(1,9), lwd = rep (2,9), ncol = 3)
