death <- read.csv("A:/smith/project big data/DeathRecords/deathrecords_sample1.csv")
icd10code <- read.csv("A:/smith/project big data/DeathRecords/Icd10Code.csv")
require(dplyr)

names(icd10code) <- c("Icd10Code","Icd10Code_Description")
death <- left_join(death,icd10code,by="Icd10Code")

death$Icd10Code <- factor(death$Icd10Code)
rm(icd10code)

require(tm)

set.seed(4334)
sample_size <- 699
icd_sample <- sample(1:nrow(death),sample_size)
icd <- as.character(death$Icd10Code_Description[icd_sample])

icd <- gsub("disease|diseas|unspecified|specified|acute|
            without|failure|failur|chronic|specification|
            describe|describ|chronic|acute|biological|
            essential|elsewhere|without","",icd)
write.csv(icd,"temp.csv")


myCorpus <- Corpus(VectorSource(readLines("temp.csv")))
myCorpus <- tm_map(myCorpus,tolower)
myCorpus <- tm_map(myCorpus,removePunctuation)
myCorpus <- tm_map(myCorpus,removeNumbers)
myCorpus <- tm_map(myCorpus,removeWords,stopwords("english"))
myCorpus <- tm_map(myCorpus,stemDocument)
myCorpus <- tm_map(myCorpus,PlainTextDocument)

require(wordcloud)

wordcloud(myCorpus,scale=c(4,0.4),random.order=FALSE,max.words=150,
          rot.per=0.35,use.r.layout=FALSE,colors=brewer.pal(8,"Dark2"))
