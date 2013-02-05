#coo

# 'ingroup/all_reviews.csv'
mergeDatasets <- function(file, DIR, sessions, out.dir, out.file = FALSE) {
  
  files <- createFileList(file, datadir, sessions)
  #return(files)

  data <- read.tables(files)

  data <- setRoundsColumn(data)
  
  if (out.file == FALSE) {
    rm(out.file)
    out.file <- file
  }

  out <- sprintf("%s%s/csv/%s", DIR, out.dir, out.file)

  write.csv(data, out)
}

mergeDatasets.H <- function(file, DIR, sessions, out.dir, out.file = FALSE) {
  
  files <- createFileList(file, datadir, sessions)
  #return(files)
  
  data <- read.tables.H(files)
  data <- setRoundsColumn(data)
  
  if (out.file == FALSE) {
    rm(out.file)
    out.file <- file
  }
  
  out <- sprintf("%s%s/csv/%s", DIR, out.dir, out.file)
  
  write.csv(data, out)
}

setRoundsColumn <- function(df, nrounds=30) {
  df$round <- seq(0,nrow(df)-1)
  df$round <- (df$round %% nrounds) + 1
  sessions <- strsplit(df$file, "/")
  df$session <- sapply(sessions, "[[", 6)
  return(df)
}

# does not work well...different csv are joined differently
mergeSessions <- function(sessions, outdir) {
  s <- sessions[length(sessions)]
  sessiondir <- getCSVPath(datadir, s)
  sessiondir.files <- list.files(sessiondir, recursive=TRUE, pattern = "\\.csv$");
  for (f in sessiondir.files) {
    mergeDatasets(f, datadir, sessions, outdir)
  }
  #return(sessiondir.files)
}

mergeDatasets('diff/global/diff_faces_x_round_x_player_mean.csv',
              datadir, session.com, 'com_aggregate', 'diff/global/consensus.csv')

mergeDatasets('diff/global/diff_faces_x_round_x_player_mean.csv',
              datadir, session.coo, 'coo_aggregate', 'diff/global/consensus.csv')

mergeDatasets.H('diff/global/diff_faces_x_round_x_player_mean.csv', datadir, session.com, 'com_aggregate')
mergeDatasets.H('diff/global/diff_faces_x_round_x_player_mean.csv', datadir, session.coo, 'coo_aggregate')

mergeDatasets.H('diff/global/diff_faces_x_round_x_player_self.csv', datadir, session.com, 'com_aggregate')
mergeDatasets.H('diff/global/diff_faces_x_round_x_player_self.csv', datadir, session.coo, 'coo_aggregate')

# mergeSessions(session.com, 'com_aggregate')

#mergeDatasets('ingroup/all_reviews.csv', datadir, sessions.coo, 'coo')
#mergeDatasets('ingroup/all_reviews.csv', datadir, sessions.com, 'com')

mergeDatasets.H('diff/global/diff_faces_x_round_x_player_mean.csv', datadir, sessions.com, 'com')
mergeDatasets.H('diff/global/diff_faces_x_round_x_player_mean.csv', datadir, sessions.coo, 'coo')

mergeDatasets.H('diff/global/diff_faces_x_round_x_player_self.csv', datadir, sessions.com, 'com')
mergeDatasets.H('diff/global/diff_faces_x_round_x_player_self.csv', datadir, sessions.coo, 'coo')



getCommonDatasets <- function(DIR, sessions) {
  for (s in sessions) {
    myFile <- sprint("%s%s/csv/", DIR, s)
    files <- c(files, myFile)
  }

}



filenames <- list.files(getFilePath(datadir, 'com_sel', 'ingroup'), pattern="*.csv", full.names=TRUE)
filename
ldf <- lapply(filenames, read.csv)



res <- lapply(ldf, summary)
names(res) <- substr(filenames, 6, 30)

filenames <- list.files("temp", pattern="*.csv")
paste("temp", filenames, sep="/")
