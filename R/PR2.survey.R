source("PR2.init.R")

survey <- read.table(file="./all_survey.csv", head=TRUE, sep=",")


survey$startTimePOSIX <- as.POSIXlt(strptime(paste(survey$date, survey$startTime), "%d-%m-%Y %H:%M:%S"))
survey$endTimePOSIX <- as.POSIXlt(strptime(paste(survey$date, survey$endTime), "%d-%m-%Y %H:%M:%S"))
survey$duration <- difftime(survey$endTimePOSIX,survey$startTimePOSIX)
survey$dur <- as.numeric(survey$duration)

for (c in names(survey)) {
  if (length(grep(".comment", c)) > 0) {
    survey[[c]] <- as.character(survey[[c]])
  }
}

survey$special <- as.factor(survey$special)
survey$com <- as.factor(survey$com)
survey$coo <- as.factor(survey$coo)
survey$rand <- as.factor(survey$rand)
survey$choice <- as.factor(survey$choice)
survey$session <- as.factor(survey$session)
survey$date <- as.factor(survey$date)
survey$morning <- as.factor(survey$morning)
survey$afternoon <- as.factor(survey$afternoon)


strcount <- function(x, pattern, split) {
  #if (length(x) == 0) return(0)
  unlist(lapply(
    strsplit(x, split),
       function(z) na.omit(length(grep(pattern, z)))
   ))
}





## Points of duration of the questionnaire
p <- ggplot(survey, aes(session, dur))
p <- p + geom_point(aes(group = 1, colour = coo), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

## Barplot duration of the questionnaire
p <- ggplot(survey, aes(dur))
p <- p + geom_bar(aes(colour = coo), position="dodge") # + geom_jitter(aes(colour = coo), size = 3)
p

# add facets
# p <- p + facet_grid(session~.)
# p


## Density curves of duration of the questionnaire
p <- ggplot(survey, aes(x=dur, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=.3, na.rm = TRUE)
p


funwords <- c("nice","fun","FUN","excit","EXCIT","NICE","cool","COOL",":)",":D",";)",";D","laugh","LAUGH","great")
stresswords <- c("bore","BORE","tired","TIRED","stress","STRESS","borin","BORIN","piss","PISS")

survey$fun <- 0
survey$stress <- 0
for (n in names(survey)) {
  if (length(grep(".comment", n)) != 0) {
    column <- as.matrix(get(n, survey))
    for (w in funwords) {
      count <- apply(column, 1, strcount, pattern=w, split=" ")
      survey$fun <- survey$fun + count
    }
    for (w in stresswords) {
      count <- apply(column, 1, strcount, pattern=w, split=" ")
      survey$stress <- survey$stress + count
    }   
  }
}

# STRESS COUNT
p <- ggplot(survey, aes(x=stress, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=.3, na.rm = TRUE)
p <- p + facet_wrap(~session, ncol=3)
p

# FUN COUNT
p <- ggplot(survey, aes(x=fun, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=.3, na.rm = TRUE)
p <- p + facet_wrap(~session, ncol=3)
p


p <- ggplot(survey, aes(x = as.numeric(com), fill = fun))
p <- p + geom_bar()
p

p <- ggplot(survey, aes(x=fun, group=com, colour=com))
p <- p + geom_density(aes(fill=com),alpha=.3, na.rm = TRUE)
p <- p + facet_wrap(~session, ncol=3)
p




survey[,c("dur","session","PC","fun","stress")]



merge(

#p.survey <- ggplot(survey, 

