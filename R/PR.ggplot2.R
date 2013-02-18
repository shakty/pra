

all.rounds.d.pub.previous <- tapply(pr.clean$d.pub.previous, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.pub.previous)

all.rounds.d.sub.current <- tapply(pr.clean$d.sub.current, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.sub.current)

all.rounds.d.self.previous <- tapply(pr.clean$d.self.previous, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.self.previous)

all.rounds.d.pub.cumulative <- tapply(pr.clean$d.pub.cumulative, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.pub.cumulative)

pr.com.clean <- na.omit(pr[pr$com == 1, ])

com.rounds.d.pub.previous <- tapply(pr.com.clean$d.pub.previous, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.com.clean$d.sub.current, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.com.clean$d.self.previous, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.com.clean$d.pub.cumulative, pr.com.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.coo.clean <- na.omit(pr[pr$coo == 1, ])

com.rounds.d.pub.previous <- tapply(pr.coo.clean$d.pub.previous, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.coo.clean$d.sub.current, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.coo.clean$d.self.previous, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.coo.clean$d.pub.cumulative, pr.coo.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.choice.clean <- na.omit(pr[pr$choice == 1, ])

com.rounds.d.pub.previous <- tapply(pr.choice.clean$d.pub.previous, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.choice.clean$d.sub.current, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.choice.clean$d.self.previous, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.choice.clean$d.pub.cumulative, pr.choice.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)


pr.rand.clean <- na.omit(pr[pr$rand == 1, ])

com.rounds.d.pub.previous <- tapply(pr.rand.clean$d.pub.previous, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.previous)

com.rounds.d.sub.current <- tapply(pr.rand.clean$d.sub.current, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.sub.current)

com.rounds.d.self.previous <- tapply(pr.rand.clean$d.self.previous, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.self.previous)

com.rounds.d.pub.cumulative <- tapply(pr.rand.clean$d.pub.cumulative, pr.rand.clean$round, mean)
plot.ts(seq(2:30), com.rounds.d.pub.cumulative)







myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...
## modifiction of plclust for plotting hclust objects *in colour*!
## Copyright Eva KF Chan 2009
## Arguments:
##
## hclust:
## hclust object
##
## lab:
## a character vector of labels of the leaves of the tree
##
## lab.col:
## colour for the labels; NA=default device foreground colour
##
## hang:
## as in hclust & plclust
## Side effect:
##
A display of hierarchical cluster with coloured leaf labels.
y <- rep(hclust$height,2); x <- as.numeric(hclust$merge)
y <- y[which(x<0)]; x <- x[which(x<0)]; x <- abs(x)
y <- y[order(x)]; x <- x[order(x)]
plot( hclust, labels=FALSE, hang=hang, ... )
text( x=x, y=y[hclust$order]-(max(hclust$height)*hang),
labels=lab[hclust$order], col=lab.col[hclust$order],
srt=90, adj=c(1,0.5), xpd=NA, ... )
}


countGroupsInSession <- function(session, cutoff) {
  
  session.groups <- matrix(nrow=30, ncol=9, dimnames=list(rnames, pnames))
  session.max <- matrix(nrow=30, ncol=1, dimnames=list(rnames, "max"))
  session.metadata <- data.frame()
  for (round in seq(1:30)) {
    # perform Hierchical clustering and cut the tree at "cutoff"
    round.groups <- countGroups(session, round, cutoff)
    round.ngroups <- max(round.groups)   
    session.groups[round,] <- round.groups
    session.max[round,] <- round.ngroups
    session.metadata <- rbind(session.metadata, session[1,sessions.ids])
  }
  session.frame <- data.frame(session.metadata, round=c(1:30), session.groups, session.max)
  return(session.frame)
}

countGroups <- function(session, round, cutoff) {
  faces <- session[session$round == round,13:25]
  
  if (any(is.na(faces))) {
    return(rep(NA,9))
  }
  #faces.norm <- session[session$round == round, 26:38]
  
  faces.matrix <- as.matrix(faces)
  #faces.norm.matrix <- as.matrix(faces.norm)

  faces.dist <- dist(faces)
  #faces.norm.dist <- dist(faces.norm)

  faces.hclust <- hclust(faces.dist)
  #faces.norm.hclust <- hclust(faces.norm.dist)

  #plot(faces.hclust,labels=seq(2:10)+1)
  #plot(faces.norm.hclust,labels=seq(2:10)+1)

  #heatmap(faces.matrix)

  faces.groups<-cutree(faces.hclust, h=cutoff)

  return(faces.groups)
}



#### START ####
#mysession <- pr[pr$session == 3, ]
#source('PR_init.R')
library(plyr)
library(ggplot2)
library(reshape)
library(MASS)

setwd("/var/www/pra/data/ALL/")

pr <- read.table(file="./all.csv", head=TRUE, sep=",")

pr$com <- as.factor(pr$com)
pr$coo <- as.factor(pr$coo)
pr$rand <- as.factor(pr$rand)
pr$choice <- as.factor(pr$choice)
pr$session <- as.factor(pr$session)
pr$date <- as.factor(pr$date)
pr$morning <- as.factor(pr$morning)
pr$afternoon <- as.factor(pr$afternoon)

pr$e1.same.color <- as.factor(pr$e1.same.color)
pr$e2.same.color <- as.factor(pr$e2.same.color)
pr$e3.same.color <- as.factor(pr$e3.same.color)

pr$e1.same.ex <- as.factor(pr$e1.same.ex)
pr$e2.same.ex <- as.factor(pr$e2.same.ex)
pr$e3.same.ex <- as.factor(pr$e3.same.ex)
                              
pr$ex <- as.factor(pr$ex)
pr$published <- as.factor(pr$published)
pr$copy <- as.factor(pr$copy)

pr$treatment <- paste0(pr$coo, pr$rand)

pr.clean <- na.omit(pr)

players.labels=seq(2:10)+1
sessions.ids <- seq(1,8)

pnames <- paste0("p", seq(2:10)+1)
rnames <- paste0("r", seq(1:30))

sessions <- unique(pr$session)
cutoff = 30

names.pr <- names(pr)
pr.melted <- melt(pr, id=names.pr[c(-64, -70, -76)])


# CLUSTERS

groups.frame <- data.frame()
for (s in sessions) {
  session <- pr[pr$session == s, ]
  session.frame <- countGroupsInSession(session, cutoff)
  groups.frame <- rbind(groups.frame, session.frame)
}
row.names(groups.frame) <- c(1:nrow(groups.frame))
head(groups.frame)

p <- ggplot(groups.frame, aes(round, max, group=session))

#p.line.com <- p + aes(colour=com) + geom_line(); p.line.com
#p.line.rand <- p + aes(colour=rand) + geom_line(); p.line.rand

p <- ggplot(groups.frame, aes(round, max))
p.facets <- p + aes(colour=com) + geom_smooth() + facet_grid(rand ~ com, margins = T);
p.facets <- p.facets + ggtitle("Number of clusters per round per treatment condition")
#p.facets  + opts(strip.text.x = theme_text(size = 8, colour = "red", angle = 90))
p.facets

groups.t.com <- t.test(max ~ com, data=groups.frame)


ggsave(file="./img/clusters_by_condition.jpg")


# PUBLICATIONS AND COPIES

p.copies <- ggplot(pr.clean, aes(com, colour=com))
stat_bin(aes(ymax = ..count.. / ))

p.published <- ggplot(pr.clean, aes(com, colour=com))
p.copies + stat_bin(aes(ymax = ..count.. )) + facet_grid(. ~ rand)

p.copies.boxplot <- p.copies + geom_boxplot(aes(x=treatment,y=copy))
p.copies.boxplot

table(pr$copy, pr$treatment)

copies <- tapply(pr$copy, pr$com, table)
published <- tapply(pr$published, pr$com, table)

copies <- table(pr$copy, pr$com)
copies <- copies[2,]

published <- table(pr$published, pr$com)
published <- published[2,]

copies.relfreq <- copies / published

copies.relfreq.full[1] <- copies.relfreq

copies.relfreq[3:4] <- 1 - copies.relfreq


copies.barplot <- rbind(published,copies)

jpeg('./img/pubs_and_copies_count.jpg',quality=100,width=600)
barplot(copies.barplot, col=c(1,2), beside=TRUE, main="Number of Published, and copied paintings by level of competition", legend.text=c("published", "copied"))
dev.off()

copytab <- xtabs(~com+copy, data=pr)
chisq.test(copytab)

pubtab <- xtabs(~com+published, data=pr)
chisq.test(copytab)



##



# EVAS
evas <- data.frame()
for (e in c("e1", "e2", "e3")) {
  mydata <- pr.melted[pr.melted$variable == e, ]
  sameex <- paste0(e, ".same.ex")
  samecol <- paste0(e, ".same.color")
  sameex.column <- with(mydata, get(sameex))
  samecol.column <- with(mydata, get(samecol))
  metadata <- mydata[,sessions.ids]
  myeva <- data.frame(metadata,
                      round=mydata$round,
                      changed=mydata$e.changed,
                      copy=mydata$copy, published=mydata$published,
                      order=mydata$variable, value=mydata$value,
                      same.ex=sameex.column, same.color=samecol.column)  
  evas <- rbind(evas, myeva) 
}

evas$same.ex <- as.factor(evas$same.ex)
evas$same.color <- as.factor(evas$same.color)
evas$same.changed <- as.factor(evas$changed)

p.evas <- ggplot(evas, aes(x=value, group=com, colour=com))

#p.line.com <- p + aes(colour=com) + geom_line(); p.line.com
#p.line.rand <- p + aes(colour=rand) + geom_line(); p.line.rand

p.evas.density <- p.evas + geom_density(aes(fill=com),alpha=0.3)
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings by level of competition")
p.evas.density.title
ggsave(file="./img/evas/evas_density_com.jpg")

p.evas.density.facets <- p.evas.density + aes(colour=com)  + facet_grid(rand ~ com, margins = T);
p.evas.density.facets <- p.evas.density.facets +  ggtitle("Density curves of ratings by treatment condition")
p.evas.density.facets
ggsave(file="./img/evas/evas_density_all_conditions.jpg")


p.evas.hist <- p.evas + geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                   binwidth=.5)


p.evas.boxplot <- p.evas + geom_boxplot(aes(x=com,y=value))

#+ geom_density(alpha=.2, fill="#FF6666")  # Overlay with transparent density plot


p.evas.facets <- p.evas + aes(colour=com) + geom_boxplot()

summary(evas[evas$com==1,])
summary(evas[evas$com==0,])


evas.t.com <- t.test(value ~ com, data=evas)

evas.t.same.ex <- t.test(value ~ same.ex, data=evas)

evas.t.same.ex.com <- t.test(value ~ com, data=evas[evas$same.ex == 1,])

evas.t.same.color <- t.test(value ~ same.color, data=evas[evas$com==1,])


p.evas.color <- ggplot(evas, aes(x=same.color, y=value))
p.evas.color <- p.evas.color  + geom_boxplot(aes(group=com))
p.evas.color                       


evascom <- evas[evas$com == 1,]
p.evascom <- ggplot(evascom, aes(x=value, group=same.ex, colour=same.ex))
p.evascom.same.ex.density <- p.evascom + geom_density(aes(fill=same.ex),alpha=0.3)
p.evascom.same.ex.density.title <- p.evascom.same.ex.density + ggtitle("Density curves of ratings for direct competitors or not")
p.evascom.same.ex.density.title

evascoo <- evas[evas$com == 0,]

p.evascoo <- ggplot(evas.clean, aes(x=value, group=same.ex, colour=same.ex))
p.evascoo.same.ex.density <- p.evascoo + geom_density(aes(fill=same.ex),alpha=0.3) + facet_grid( . ~ com)
p.evascoo.same.ex.density.title <- p.evascoo.same.ex.density + ggtitle("Density curves of ratings: same ex or not, com or not")
p.evascoo.same.ex.density.title
ggsave(file="./img/evas/evas_density_same_ex_com.jpg")

vp.2h <- viewport(width = 0.5, height = 1, x = 0.5, y = 0.5)

print(p.evascoo.same.ex.density.title, vp = vp.2h)
print( p.evascom.same.ex.density.title, vp = vp.2h)


###
evas.clean <- na.omit(evas)
p.evas.clean <- ggplot(evas.clean, aes(x=value, group=com, colour=com))
p.evas.clean.density <- p.evas.clean + geom_density(aes(fill=com),alpha=0.3)
p.evas.clean.same.ex.density.facets <- p.evas.clean.density + aes(colour=com)  + facet_grid(rand ~ com ~ same.ex, margins = T);
p.evas.clean.same.ex.density.facets <- p.evas.clean.same.ex.density.facets +  ggtitle("Density curves of ratings by treatment condition - same ex")
p.evas.clean.same.ex.density.facets
ggsave(file="./img/evas/evas_density_same_ex_all_conditions.jpg")


p.evas.clean <- ggplot(evas.clean, aes(x=value, group=com, colour=com))
p.evas.clean.density <- p.evas.clean + geom_density(aes(fill=com),alpha=0.3)
p.evas.clean.same.ex.density.facets <- p.evas.clean.density + aes(colour=com)  + facet_grid(com ~ same.ex, margins = T);
p.evas.clean.same.ex.density.facets <- p.evas.clean.same.ex.density.facets +  ggtitle("Density curves of ratings by treatment condition - same ex")
p.evas.clean.same.ex.density.facets





evas.changed <- evas[evas$changed == 1, ]

evascom <- evas[evas.changed$com == 1 & evas$value < 5.1,]

mean(evascom[evascom$same.color == 1, ]$value, na.rm = TRUE)
mean(evascom[evascom$same.color == 0, ]$value, na.rm = TRUE)

p.evas.color.density <- ggplot(evascom, aes(x=value, group=same.color, colour=same.color))
p.evas.color.density <- p.evas.color.density  + geom_density()
p.evas.color.density


+ facet_grid(rand ~ com, margins = T);

p.evas.facets

p.facets <- p.facets + opts(title="Number of clusters per round per treatment condition")
#p.facets  + opts(strip.text.x = theme_text(size = 8, colour = "red", angle = 90))


# EVAS COLOR

## DISTANCE IN TIME



p.distance <- ggplot(pr, aes(round, d.sub.current)) + ylim(0,0.5)
p.distance <- p.distance + aes(colour=com, group=p.id) + geom_point() + facet_grid(rand ~ com, margins = T) 
p.distance + ggtitle("Painting distance from other paintings submitted at the same time")
ggsave("./img/distance/distance.cur.sub_all_conditions.jpg")

p.distance + geom_jitter(position = position_jitter(width=0.5))

p.evas.clean.same.ex.density.facets <- p.evas.clean.density + aes(colour=com) +  + facet_grid(rand ~ com ~ same.ex, margins = T);
p.evas.clean.same.ex.density.facets <- p.evas.clean.same.ex.density.facets +  ggtitle("Density curves of ratings by treatment condition - same ex")
p.evas.clean.same.ex.density.facets
ggsave(file="./img/evas/evas_density_same_ex_all_conditions.jpg")


all.rounds.d.pub.previous <- tapply(pr.clean$d.pub.previous, pr.clean$round, mean)
plot.ts(seq(2:30), all.rounds.d.pub.previous)



### LM


aggregate(groups.frame, by=list(iscom = groups.frame$com), mean, na.rm = TRUE)


molted <- melt(groups.frame

mysession <- groups.frame[session == 1,]
fit <- lm(data = mysession, formula = max ~ round)
summary(fit)


plot(fit)

com.rounds.d.pub.cumulative <- tapply(groups.frame$max, groups.frame$com, lm, formula = max ~ round, data = groups.frame)







## OLD STUFF

#for (s in sessions) {
#   session <- groups.frame[groups.frame$session == s, ]
#   main <- sprintf("COM: %s - RAND %s", session$com[1], session$rand[1])
#   plot.ts(session$max, main=main, ylim=c(1,10))
#   par(ask=TRUE) 
#}


#pr.melted.clean <- na.omit(pr.melted)
#vars.keep <- c("coo","com","rand","choice","e1.same.ex", "e1.same.color", "e2.same.ex", "e2.same.color", "e3.same.ex", "e3.same.color")
#pr.melted <- melt(pr, measure.vars=c("e1","e2","e3", "e1.same.ex", "e1.same.color", "e2.same.ex", "e2.same.color", "e3.same.ex", "e3.same.color"), id.vars=vars.keep)
#head(pr.melted)

#evas <- data.frame(row.names = c("session", "coo", "com", "rand", "choice", "order", "value", "same.ex", "same.color"))
