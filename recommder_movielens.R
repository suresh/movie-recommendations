setwd("C:/Users/SURESH/Dropbox/projects/bapm/spring 2016/data mining/project/code")
library(recommenderlab)

# Load training data
load("MovieDB.rda")
MovieLense100 <- MovieDB[rowCounts(MovieDB) > 100, ]
train <- MovieLense100[1:100]

# RecommenderLab - Association Rules
rec <- Recommender(train, method = "POPULAR")
rec
pre <- predict(rec, MovieLense100[101:102], n = 10)
pre
as(pre, "list")
pre1 <- predict(rec, MovieLense100[101, 102], type = "ratings")
as(pre1, "matrix")[, 1:10]
train
head(train)
head(as(train, "list"))

