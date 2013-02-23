source("PR2.init.R")

survey <- read.table(file="./all_survey.csv", head=TRUE, sep=",")


survey$startTimePOSIX <- as.POSIXlt(strptime(paste(survey$date, survey$startTime), "%d-%m-%Y %H:%M:%S"))
survey$endTimePOSIX <- as.POSIXlt(strptime(paste(survey$date, survey$endTime), "%d-%m-%Y %H:%M:%S"))
survey$duration <- difftime(survey$endTimePOSIX,survey$startTimePOSIX)
                            
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



#p.survey <- ggplot(survey, 
