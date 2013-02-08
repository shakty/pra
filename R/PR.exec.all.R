sessions <- c(
              # PRETEST
              #'coo_rand_orig',
              #'coo_choice_err',
              #'com_choice_good',
              #'com_rand_fake',
              # 25 JAN 2013
              'com_rand_25_jan_2013',
              'com_choice_25_jan_2013',
              # 30 JAN 2013
              'coo_rand_30_jan_2013',
              'coo_choice_30_jan_2013',
              # 31 JAN 2013
              'com_choice_31_jan_2013',
              'coo_rand_31_jan_2013',
              # 1 FEB 2013
              'com_rand_1_feb_2013',
              'coo_choice_1_feb_2013',
              # 4 FEB 2013
              'com_rand_4_feb_2013',
              'coo_rand_4_feb_2013'
              )

for (s in sessions) {
  pr.setwd(datadir, s)
  pr.source('PR.R')
}
