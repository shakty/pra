source("PR2.init.R")

## GLOBAL WINNING

#lm2 <- lm(pr$published ~ relevel(pr$coo,ref="R"))

pr.cast <- cast(pr, p.id ~ published)
pr.pubs <- merge(pr.cast, unique(pr[1:9]))
names(pr.pubs)[2:3] <- c("not.pub","pub")

pr.pubs$pub <- as.numeric(pr.pubs$pub)
pr.pubs$not.pub <- as.numeric(pr.pubs$not.pub)

pr.pubs$nrounds <- 30
pr.pubs[pr.pubs$session == 6,]$nrounds <- 26
pr.pubs$pub.rate <- pr.pubs$pub / pr.pubs$nrounds

pr.pubs <- melt(pr.pubs, measure.vars=c("coo","choice","rand","com"), variable_name="condition")
pr.pubs <- pr.pubs[pr.pubs$value == 1,]

meanPubs <- tapply(pr.pubs$pub, pr.pubs$condition, mean)

p.pubs <- ggplot(pr.pubs, aes(condition, pub))
p.pubs <- p.pubs + geom_point(colour="darkblue") + geom_jitter(colour="darkblue")
p.pubs + stat_summary(fun.y=mean, colour="red", geom="point", size=4)

p.pubs <- ggplot(pr.pubs, aes(condition, pub)) + geom_boxplot()
p.pubs

p.pubs <- ggplot(pr.pubs, aes(x=pub, group=condition, colour=condition))
p.pubs.density <- p.pubs + geom_density(aes(fill=condition),alpha=0.3)
p.pubs.density.title <- p.pubs.density + ggtitle("Density curves of number of publications by treatment condition")
p.pubs.density.title

p.pubs.facets <- p.pubs.density + aes(colour=com)  + facet_grid(rand ~ com, margins = T);
p.pubs.density.facets <- p.pubs.density.facets +  ggtitle("Density curves of ratings by treatment condition")
p.pubs.density.facets

p.pubs + geom_density()

table(pr.pubs$pub, pr.pubs$choice)

fit <- lm(pub ~ relevel(condition, ref="com"), data = pr.pubs)
summary(fit)

confint(fit)

anova(fit)

#vcovHC(fit)
old <- par(mfrow=c(2,2))
plot(fit)

pubs.aov <- aov(pub ~ condition, data = pr.pubs)
summary(pubs.aov)

pubs.aov$coeff


#POISSON

glm1 <- glm(pub ~ condition, family="poisson", data=pr.pubs)
summary(glm1)

# in Poisson regr dependent variable is log of conditional mean
exp(coef(glm1))

library(qcc)

qcc.overdispersion.test(pr.pubs$pub, type="poisson")

# there is overdispersion, trying with a quasipoisson
glm1.quasi <- glm(pub ~ condition, family="quasipoisson", data=pr.pubs)
summary(glm1.quasi)

exp(coef(glm1.quasi))

library(robust)

glm1.rob <- glmRob(pub ~ condition, family="poisson", data=pr.pubs)
summary(glm1.rob)

exp(coef(glm1.rob))

glm2 <- glm(pub ~ condition, offset=log(nrounds), family="poisson", data=pr.pubs)
summary(glm2)
