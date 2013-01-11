# load data -- this script assumes data frame SR already exists

# get hits-by-phrase count
Hits.by.Phrase <- aggregate(list(Hits=SR$Hit.Count), SR["Phrase"], sum)

# get docs-by-phrase count
Docs.by.Phrase <- aggregate(list(Docs=SR$Doc.Id), SR["Phrase"], length)

# get docs-with-single-phrase count
DocID.Freq <- as.data.frame(table(SR$Doc.Id))
names(DocID.Freq)[1] <- "DocID"
DocIDs.with.single.Phrase <- as.vector(DocID.Freq$DocID[DocID.Freq$Freq==1])
subSR <- subset(SR, select=c(Doc.Id, Phrase), subset=(SR$Doc.Id %in% DocIDs.with.single.Phrase))
Docs.with.single.Phrase <- aggregate(list("Docs with single Phrase"=subSR$Phrase), subSR["Phrase"], length)

# build final by-phrase report
SR.by.Phrase <- merge (Hits.by.Phrase, Docs.by.Phrase)
SR.by.Phrase <- merge (SR.by.Phrase,   Docs.with.single.Phrase)

# get hits-by-custodian count
Hits.by.Custodian <- aggregate(list(Hits=SR$Hit.Count), SR["Custodian"], sum)

# get docs-by-custodian count
Docs.by.Custodian <- aggregate(list(Docs=SR$Doc.Id), SR["Custodian"], length)

# build final by-custodian report
SR.by.Custodian <- merge (Hits.by.Custodian, Docs.by.Custodian)

# export final reports
write.csv(SR.by.Phrase,    file="Search Hit Report by Phrase.csv",    row.names=FALSE)
write.csv(SR.by.Custodian, file="Search Hit Report by Custodian.csv", row.names=FALSE)
