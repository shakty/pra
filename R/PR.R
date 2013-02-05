# Init
source('PR_init.R')

session <- 'coo_choice_1_feb_2013'
session <- 'com_rand_1_feb_2013'

session <- 'coo_rand_31_jan_2013'
session <- 'com_choice_31_jan_2013'

session <- 'coo_choice_30_jan_2013'
session <- 'coo_rand_30_jan_2013'

session <- 'com_rand_25_jan_2013'
session <- 'com_choice_25_jan_2013'

session <- 'coo_rand_4_feb_2013'
session <- 'com_rand_4_feb_2013'

session <- 'com_aggregate'
session <- 'coo_aggregate'

pr.setwd(datadir, session);

## Publications
###############
pr.source('PR.pubs.R')

## Evaluations
##############
pr.source('PR.evas.R')

# Submissions
#############
pr.source('PR.subs.R')

# Between exhibition
########################
pr.source('PR.same_ex.R')

#######################
# Diff Self
pr.source('PR.diff_self.R')  

##############
# Face diffs
pr.source('PR.diff_faces.R')  

########
# COPIES
pr.source('PR.copies.R')

#########
# Diff and score
pr.source('PR.diff_score.R')

#################
# Ingroup by color
pr.source('PR.color.R')

#################
# Competition in reviews
pr.source('PR.competition_reviews.R')
