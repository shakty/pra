source("PR2.init.R")
library(gvlma)

# All obs

# Innovation: significant!
fit1 <- lm(100*d.pub.previous ~ com + choice, data=pr)
summary(fit1)

# Diversity: significant!
fit1 <- lm(100*d.sub.current ~ com + choice, data=pr)
summary(fit1)

# Self Innovation: little significant!
fit1 <- lm(100*d.self.previous ~ com + choice, data=pr)
summary(fit1)

# Self Innovation: significant!
fit1 <- lm(100*time.creation ~ com + choice, data=pr)
summary(fit1)



# One obs per session!!! -> 16 obs
groupvars <- c("session")
#measurevars <- c("time.creation", "d.pub.previous", "d.pub.cumulative", "d.sub.current")


s.time.creation <- summaryPlayers(pr, "time.creation", groupvars, na.rm=TRUE) 
s.diversity <- summaryPlayers(pr, "d.sub.current", groupvars, na.rm=TRUE)
s.innovation <- summaryPlayers(pr, "d.pub.previous", groupvars, na.rm=TRUE)
s.own.innovation <- summaryPlayers(pr, "d.self.previous", groupvars, na.rm=TRUE)                                   

summary.session <- merge(overview, s.time.creation)
summary.session <- merge(summary.session, s.diversity)
summary.session <- merge(summary.session, s.innovation)
summary.session <- merge(summary.session, s.own.innovation)

# Innovation: not significant (close though..)
fit1 <- lm(100*d.pub.previous ~ com + choice, data=summary.session)
summary(fit1)

# Diversity: not significant
fit1 <- lm(100*d.sub.current ~ com + choice, data=summary.session)
summary(fit1)

# Self Innovation: not significant
fit1 <- lm(100*d.self.previous ~ com + choice, data=summary.session)
summary(fit1)

# Time for creation: little significant!
fit1 <- lm(100*time.creation ~ com + choice, data=summary.session)
summary(fit1)


# One obs per subject per session!! -> 144 obs
mergeBy <- intersect(names(p.diversity), names(overviewPlayers))
groupvars <- c("session", "p.number")

p.time.creation <- summaryPlayers(pr, "time.creation", groupvars, na.rm=TRUE)
p.diversity <- summaryPlayers(pr, "d.sub.current", groupvars, na.rm=TRUE)
p.innovation <- summaryPlayers(pr, "d.pub.previous", groupvars, na.rm=TRUE)
p.own.innovation <- summaryPlayers(pr, "d.self.previous", groupvars, na.rm=TRUE)

summary.player <- merge(overviewPlayers, p.time.creation)
summary.player <- merge(summary.player, p.diversity)
summary.player <- merge(x=summary.player, y=p.innovation)
summary.player <- merge(summary.player, p.own.innovation)

# Innovation: significant
fit1 <- lm(100*d.pub.previous ~ com + choice, data=summary.player)
summary(fit1)

# Diversity: significant
fit1 <- lm(100*d.sub.current ~ com + choice, data=summary.player)
summary(fit1)

# Self Innovation: not significant
fit1 <- lm(100*d.self.previous ~ com + choice, data=summary.player)
summary(fit1)

# Time for creation: significant!
fit1 <- lm(100*time.creation ~ com + choice, data=summary.player)
summary(fit1)



## Redo plot p.28 DENSITY of review scores (from ggplot2,R)
p.evas <- ggplot(evas, aes(x=value, group=com, colour=com))

p.evas.density <- p.evas + geom_density(aes(fill=com),alpha=0.3)
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings by level of competition") 
p.evas.density.title<- p.evas.density.title + xlab('Rating') + ylab('Density')
p.evas.density.title


p.evas <- ggplot(evas, aes(x=value, group=rand, colour=rand))

p.evas.density <- p.evas + geom_density(aes(fill=rand),alpha=0.3)
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings by reviewer choice") 
p.evas.density.title<- p.evas.density.title + xlab('Rating') + ylab('Density')
p.evas.density.title

# no significant differences at visual analysis

p.evas <- ggplot(evas, aes(x=value, group=same.ex, colour=same.ex))
p.evas.density <- p.evas + geom_density(aes(fill=same.ex),alpha=0.3)
p.evas.density <- p.evas.density + xlab('Rating') + ylab('Density')
p.evas.density <- p.evas.density + scale_fill_manual(values=c("#E69F00", "#56B4E9"),
                                                            name="Exhibition",
                                                            labels=c("Another", "Same"))
p.evas.density <- p.evas.density + scale_colour_manual(values=c("#E69F00", "#56B4E9"),
                                                              name="Exhibition",
                                                              labels=c("Another", "Same"))
p.evas.density.title <- p.evas.density + ggtitle("Density curves of ratings for direct competitors and not") 


# faceting by competition
p.evas.density.title <- p.evas.density.title + facet_grid(~com, labeller=myLabeller)
p.evas.density.title  + theme(strip.text.x = element_text(size=16, face="bold"))


# faceting by competition
p.evas.density.title <- p.evas.density.title + facet_grid(~rand, labeller= myLabeller)
p.evas.density.title + theme(strip.text.x = element_text(size=16, face="bold"))

# strip.background = element_rect(colour="red", fill="#CCCCFF"))


myLabeller <- function(var, value){
  value <- as.character(value)
  if (var == "rand") { 
    value[value== 0] <- "Strategic"
    value[value== 1] <- "Random"
  }
  else if (var == "com") {
    value[value== 0] <- "Non competitive"
    value[value== 1] <- "Competitive"
  } 
  return(value)
}
