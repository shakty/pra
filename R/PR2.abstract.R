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


# Low in abstract art
non.abs <- overview[overview$abs.ste <= 1,]

for (s in non.abs$session) {
  
}


