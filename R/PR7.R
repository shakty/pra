source("PR2.init.R")
library(gvlma)

########
## START
########


### Are subjects becoming more different withing one trajectory
### Are sessions becoming incresingly more different each other

# Average distance of each face from the faces submitted in the same round in other exhibitions


p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = dse.pub.prev.1, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.2, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.3, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.4, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.5, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.6, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.7, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.8, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.9, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.10, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.11, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.12, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.13, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.14, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.15, colour=com), se=FALSE)
p <- p + geom_smooth(aes(y = dse.pub.prev.16, colour=com), se=FALSE)
#p <- p + geom_smooth(aes(y = d.sub.current, linetype=com, colour = "Diversity"))
#p <- p + geom_smooth(aes(y = d.self.previous, linetype=com, colour = "Personal Change"))
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_smooth(aes(y = e.mean / 10, colour=com))
p <- p + facet_wrap(~session, ncol=4)
#p <- p + scale_y_log10()
p


p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = dse.pub.prev.1, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.2, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.3, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.4, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.5, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.6, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.7, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.8, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.9, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.10, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.11, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.12, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.13, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.14, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.15, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.16, colour=com))
#p <- p + geom_smooth(aes(y = d.sub.current, linetype=com, colour = "Diversity"))
#p <- p + geom_smooth(aes(y = d.self.previous, linetype=com, colour = "Personal Change"))
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_smooth(aes(y = e.mean / 10, colour=com))
p <- p + facet_wrap(~session, ncol=4)
#p <- p + scale_y_log10()
p



sesCOM <- overview[overview$com == 1, "session"]
sesCOO <- overview[!overview$com == 1, "session"]

groupvars <- c("session","round","com")
mm <- summaryPlayers(pr, "dse.pub.prev.2", groupvars, na.rm=TRUE)

p <- ggplot(pr, aes(round, group=com))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = dse.pub.prev.1, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.2, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.3, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.4, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.5, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.6, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.7, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.8, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.9, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.10, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.11, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.12, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.13, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.14, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.15, colour=com))
p <- p + geom_smooth(aes(y = dse.pub.prev.16, colour=com))
#p <- p + geom_smooth(aes(y = d.sub.current, linetype=com, colour = "Diversity"))
#p <- p + geom_smooth(aes(y = d.self.previous, linetype=com, colour = "Personal Change"))
p <- p + title + ylab("Face Difference") + xlab("Round") # + theme(panel.background = element_blank())
#p <- p + geom_smooth(aes(y = e.mean / 10, colour=com))
p <- p + facet_wrap(~com, ncol=4)
#p <- p + scale_y_log10()
p

b <- pr[pr$session == 1 & pr$round == 1,]

sesids <- seq(1,16)
coo <- function(row) {
  ids <- sesids[-row["session"]]
  
  return(c(1,2,3,4))
}

c <- apply(b,1,coo)

coo <- function(row) {
  v <- c()
  if (as.numeric(row["r1.ass.kill"]) == 0) {
    v <- c(v,row["r1"])
  }
  if (as.numeric(row["r2.ass.kill"]) == 0) {
    v <- c(v,row["r2"])
  }
  if (as.numeric(row["r3.ass.kill"]) == 0) {
    v <- c(v,row["r3"])
  }
  if (length(v)>1) {
    return(sd(v))
  }
  else {
    return(NA)
  }
}

p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = dse.pub.prev.mean.com, color="From COM"))
p <- p + geom_smooth(aes(y = dse.pub.prev.mean.coo, color="From COO"))
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Average difference across sessions of ")
p


p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = d.pub.previous, colour=published))
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.com, color="From COM"))
p <- p + geom_smooth(aes(y = dse.sub.curr.mean.coo, color="From COO"))
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Average difference across sessions of ")
p


p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = dse.pub.cum.mean.com))
p <- p + geom_smooth(aes(y = dse.pub.cum.mean.com, color="From COM"))
p <- p + geom_smooth(aes(y = dse.pub.cum.mean.coo, color="From COO"))
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Average difference across sessions of ")
p


p <- ggplot(pr, aes(round))# + scale_colour_discrete(name = "Variable")
#p <- p + geom_point(aes(y = dse.sub.curr.mean))
p <- p + geom_smooth(aes(y = dse.sub.curr.mean, color=com))
p <- p + facet_wrap(~session,ncol=4) + ggtitle("Average difference across sessions of ")
p

# TODO: there is something wrong in sub.curr. The scale is too high
