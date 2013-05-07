source("PR2.init.R")

library(car)
library(plm)
#notPubBefore.clean <- na.omit(notPubBefore)

ppr <- pdata.frame(pr, index=c('p.id','round'))

ppr$published.lag <- lag(ppr$published, 1)
ppr$ex.lag <- lag(ppr$ex, 1)
ppr$ex.stay <- (ppr$ex == ppr$ex.lag) * 1

pr <- as.data.frame(ppr)

logOddStay <- glm(ex.stay ~ published.lag, data=pr, family="binomial")
summary(logOddStay)

exp(logOddStay$coeff)
exp(confint(logOddStay))


plot(na.omit(pr$ex.stay),logOddStay$fitted,pch=19,col="blue",xlab="Stayed",ylab="Prob Stay")

# odds have a little effect but are strongly significant


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
