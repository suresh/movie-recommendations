data <- read.csv("ratings100k.csv")
db <- as(data, "realRatingMatrix")

movies <- read.csv("movies.csv")
movies$X <- NULL

m <- match(colnames(db), movies$movieId)
movies <- movies[m,]
ilabels <- movies$title

# remove duplicated movies
dup <- which(duplicated(ilabels))
ilabels <- ilabels[-dup]
db <- db[,-dup]

colnames(db) <- ilabels
MovieDB <- db
save(MovieDB, file = "MovieDB.rda")
