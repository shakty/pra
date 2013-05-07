source("PR2.init.R")

# Ste thinks they went abstract

# abs = 0 (no), 1 (little), 2 (yes), 3 (a lot)

overview$abs.ste <- 0


# COM
overview[overview$session == 12,]$abs.ste <- 0 # com_choice_6_feb
overview[overview$session == 15,]$abs.ste <- 1 # between 0 and 1 com_choice_8_feb
overview[overview$session == 2,]$abs.ste <- 4 # com_choice_25_jan
overview[overview$session == 5,]$abs.ste <- 2 # between and 1 and 2 beginning nothing in the end a lot com_choice_31_jan
overview[overview$session == 7,]$abs.ste <- 6 # a lot! com_rand_1_feb
overview[overview$session == 9,]$abs.ste <- 2 # between 1 and 2 in the end com_rand_4_feb
overview[overview$session == 13,]$abs.ste <- 3 # between 2 and 3 com_rand_7_feb
overview[overview$session == 1,]$abs.ste <- 3 # 2/3 com_rand_25_jan
# COO
overview[overview$session == 8,]$abs.ste <- 3 # 2/3 1 coo_choice_1_feb
overview[overview$session == 6,]$abs.ste <- 1 # between 0 and 1 coo_choice_6_feb
overview[overview$session == 16,]$abs.ste <- 1 # between 0 and 1 coo_choice_8_feb
overview[overview$session == 4]$abs.ste <- 2 # between 1 and 2 coo_choice_30_jan
overview[overview$session == 10,]$abs.ste <- 1 # between 0 and 1 coo_rand_4_feb
overview[overview$session == 14,]$abs.ste <- 5 # coo_rand_7_feb (very much, stopped at 26)
overview[overview$session == 3,]$abs.ste <- 3 # between 2 and 3 coo_rand_30_jan
overview[overview$session == 6,]$abs.ste <- 1 # coo_rand_31_jan


overview$assmax <- 0
overview$assmean <- 0
overview$asskillmax <- 0
overview$asskillmean <- 0
overview$asslovemean <- 0
overview$asslovemax <- 0
for (s in overview$session) {
  overview[overview$session == s,"assmax"] <- max(a[a$session == s,"ass"])
  overview[overview$session == s,"assmean"] <- mean(a[a$session == s,"ass"])
  overview[overview$session == s,"asskillmean"] <- mean(a[a$session == s,"ass.kill"])
  overview[overview$session == s,"asskillmax"] <- max(a[a$session == s,"ass.kill"])
  overview[overview$session == s,"asslovemean"] <- mean(a[a$session == s,"ass.love"])
  overview[overview$session == s,"asslovemax"] <- max(a[a$session == s,"ass.love"])
  overview[overview$session == s,"emean"] <- mean(a[a$session == s,"e.mean"])
  overview[overview$session == s,"npubs"] <- mean(a[a$session == s,"npubs"])
}


plot(overview$assmax,overview$abs.ste)

plot(overview$assmean,overview$abs.ste)

p <- ggplot(overview, aes(asskillmax, abs.ste))
p <- p + geom_point(aes(group = 1, colour = com), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p


p <- ggplot(overview, aes(asslovemean, abs.ste))
p <- p + geom_point(aes(group = 1, colour = coo, alpha = coo), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p


p <- ggplot(overview, aes(emean, abs.ste))
p <- p + geom_point(aes(group = 1, colour = coo), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p

p <- ggplot(overview, aes(npubs, abs.ste))
p <- p + geom_point(aes(group = 1, colour = coo), size=3) # + geom_jitter(aes(colour = coo), size = 3)
p


# Ass and pubs

p <- ggplot(pr, aes(x = ass, fill = published))
p <- p + geom_bar()
p


p <- ggplot(pr, aes(x=published, group= as.factor(ass), colour = as.factor(ass)))
p <- p + geom_density(aes(fill=as.factor(ass)),alpha=.3, na.rm = TRUE)
p




p <- p + geom_bar(aes(stat=identity, colour = coo)) # + geom_jitter(aes(colour = coo), size = 3)
p



logOddPubIfAss <- glm(published ~ ass, data=pr, family="binomial")
summary(logOddPubIfAss)
