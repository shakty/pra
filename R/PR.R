# Init
source('PR_init.R')

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
