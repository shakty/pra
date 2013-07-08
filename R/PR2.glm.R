source("PR2.init.R")

library(car)
library(plm)
library(logitnorm)
#notPubBefore.clean <- na.omit(notPubBefore)

ppr <- pdata.frame(pr, index=c('p.id','round'))

ppr$r.mean.lag <- lag(ppr$r.mean, 1)
ppr$published.lag <- lag(ppr$published, 1)
ppr$ex.lag <- lag(ppr$ex, 1)
ppr$ex.stay <- (ppr$ex == ppr$ex.lag) * 1

pr <- as.data.frame(ppr)

# Creating classes of received review scores
labelsReviews <- c("Awful", "Negative", "Positive", "Great")
pr$r.mean.class.lag <- cut(pr$r.mean.lag, breaks=c(0, 2.5, 5, 7.5, 10), labels=labelsReviews)

# Logit previously published
############################
logOddStay <- glm(ex.stay ~ published.lag, data=pr, family="binomial")
summary(logOddStay)

exp(logOddStay$coeff)
exp(confint(logOddStay))
# odds have a little effect but are strongly significant

plot(na.omit(pr$ex.stay),logOddStay$fitted,pch=19,col="blue",xlab="Stayed",ylab="Prob Stay")

invlogit(coef(logOddStay)[1] + coef(logOddStay)[2]*mean(as.numeric(pr$published.lag), na.rm=TRUE))

# Logit on previous score
#########################
logOddStay <- glm(ex.stay ~ r.mean.lag, data=pr, family="binomial")
summary(logOddStay)

exp(logOddStay$coeff)
exp(confint(logOddStay))

meanPreviousScore <- mean(as.numeric(pr$r.mean.lag), na.rm=TRUE)

#Derivate of the logit at X = meanPreviousScore

NUM = coef(logOddStay)[2]*exp(coef(logOddStay)[1] + coef(logOddStay)[2]*meanPreviousScore)
der = NUM / (1 + NUM)^2

slope = coef(logOddStay)[2]*exp(der) / (1 + coef(logOddStay)[2]*exp(der))^2

# Adding 1 to the mean review score in the previous round, increases your probabiloty of staying in the same exhibiton by ~ 1 %

invlogit(coef(logOddStay)[1] + coef(logOddStay)[2]*mean(as.numeric(pr$r.mean.lag), na.rm=TRUE))


# Logit on previous review class
################################
logOddStay <- glm(ex.stay ~ r.mean.class.lag, data=pr, family="binomial")
summary(logOddStay)

exp(logOddStay$coeff)
exp(confint(logOddStay))

invlogit(coef(logOddStay)[1] + coef(logOddStay)[2]*mean(as.numeric(pr$r.mean.class.lag), na.rm=TRUE))

# Average Predictive Difference
hi <- 6
low <- 4
invlogit(coef(logOddStay)[1] + coef(logOddStay)[2]*low) - invlogit(coef(logOddStay)[1] + coef(logOddStay)[2]*hi)
# A jump from a review score of score to 6 creates an increase of ~ 6% probability in staying in the same ex





### More...

stay.melted <- melt(pr, measure.vars=c("coo","choice","rand","com"), variable_name="condition")
stay.melted <- stay.melted[stay.melted$value == 1,]


logOddStay.melted <- glm(ex.stay ~ published.lag + condition, data=stay.melted, family="binomial")


summary(logOddStay.melted)

exp(logOddStay.melted$coeff)

exp(confint(logOddStay.melted))


anova(logOddStay.melted,test="Chisq")


# 

fit <- lm(e.mean ~ published.lag, data=pr)
summary(fit)


logOdd.melted <- glm(ex.stay ~ published.lag + condition, data=stay.melted, family="binomial")
