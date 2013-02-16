a = 1L

?subset


set.seed(12345); par(mar=rep(0.2,4))
dataMatrix <- matrix(rnorm(400),nrow=40)
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])

par(mar=rep(0.2,4))
heatmap(dataMatrix)

set.seed(678910)
for(i in 1:40){
# flip a coin
coinFlip <- rbinom(1,size=1,prob=0.5)
# if coin is heads add a common pattern to that row
if(coinFlip){
dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,3),each=5)
}
}

par(mar=rep(0.2,4))
image(1:10,1:40,t(dataMatrix)[,nrow(dataMatrix):1])


par(mar=rep(0.2,4))
heatmap(dataMatrix)


hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered),40:1,,xlab="Row",ylab="Row Mean",pch=19)
plot(colMeans(dataMatrixOrdered),xlab="Column",ylab="Column Mean",pch=19)



library(UsingR); data(galton);
plot(galton$parent,galton$child,pch=19,col="blue")
lm1 <- lm(galton$child ~ galton$parent)
lines(galton$parent,lm1$fitted,col="red",lwd=3)


newGalton <- data.frame(parent=rep(NA,1e6),child=rep(NA,1e6))
newGalton$parent <- rnorm(1e6,mean=mean(galton$parent),sd=sd(galton$parent))
newGalton$child <- lm1$coeff[1] + lm1$coeff[2]*newGalton$parent + rnorm(1e6,sd=sd(lm1$residuals))
smoothScatter(newGalton$parent,newGalton$child)
abline(lm1,col="red",lwd=3)

set.seed(134325); sampleGalton1 <- newGalton[sample(1:1e6,size=50,replace=F),]
sampleLm1 <- lm(sampleGalton1$child ~ sampleGalton1$parent)
plot(sampleGalton1$parent,sampleGalton1$child,pch=19,col="blue")
lines(sampleGalton1$parent,sampleLm1$fitted,lwd=3,lty=2)
abline(lm1,col="red",lwd=3)

sampleLm <- vector(100,mode="list")
for(i in 1:100){
sampleGalton <- newGalton[sample(1:1e6,size=50,replace=F),]
sampleLm[[i]] <- lm(sampleGalton$child ~ sampleGalton$parent)
}


par(mar=c(4,4,0,2));plot(1:10,type="n",xlim=c(0,1.5),ylim=c(0,100),
xlab="Coefficient Values",ylab="Replication")
for(i in 1:100){
ci <- confint(sampleLm[[i]]); color="red";
if((ci[2,1] < lm1$coeff[2]) & (lm1$coeff[2] < ci[2,2])){color = "grey"}
segments(ci[2,1],i,ci[2,2],i,col=color,lwd=3)
}
lines(rep(lm1$coeff[2],100),seq(0,100,length=100),lwd=3)

x <- seq(-20,20,length=100)
plot(x,dt(x,df=(928-2)),col="blue",lwd=3,type="l")
arrows(summary(lm1)$coeff[2,3],0.25,summary(lm1)$coeff[2,3],0,col="red",lwd=4)


## Regressions with factors

download.file("http://www.rossmanchance.com/iscam2/data/movies03RT.txt",destfile="./data/movies.txt"
movies <- read.table("./data/movies.txt",sep="\t",header=T,quote="")
head(movies)


plot(movies$score ~ jitter(as.numeric(movies$rating)),col="blue",xaxt="n",pch=19)

              
axis(side=1,at=unique(as.numeric(movies$rating)),labels=unique(movies$rating))


lm1 <- lm(movies$score ~ as.factor(movies$rating))
summary(lm1)


lm2 <- lm(movies$score ~ relevel(as.factor(movies$rating),ref="R"))
summary(lm2)

anova(lm1)

lm1 <- aov(movies$score ~ as.factor(movies$rating))
TukeyHSD(lm1)

              

# Multiple regression

download.file("http://apps.who.int/gho/athena/data/GHO/WHOSIS_000008.csv?profile=text&filter=COUNTRY:
hunger <- read.csv("./data/hunger.csv")
hunger <- hunger[hunger$Sex!="Both sexes",]
head(hunger)

              
