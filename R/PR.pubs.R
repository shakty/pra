## Publications
###############
#pr.setwd(datadir, 'com_sel');

subPlayers <- read.csv(file="./pubs/pubs_x_round_x_player.csv", head=TRUE, sep=",")
subPlayers.count <- apply(subPlayers, 2, sum)
subPlayers.count


#jpeg('pubs/img/pubs_count_by_player.jpg',quality=100,width=600)
x <- barplot(subPlayers.count,
        col = colors,
        ylim=c(0,30),
        main='Number of publications by player')
y <- as.matrix(subPlayers.count)
text(x,y+0.5, labels=as.character(y))
#dev.off()
