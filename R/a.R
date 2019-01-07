a <- list.files("inst/data", full.names = TRUE)
b <- metaModule::createPool("example","inst/data")


dbQuery <- glue::glue_sql("SELECT *
                          FROM metaData"
                          )

conn <- pool::poolCheckout(b)
dbQuery <- DBI::dbGetQuery(conn, dbQuery)
#dbQuery <- DBI::dbFetch(dbQuery)

pool::poolReturn(conn)



selectedMeta <- cbind(Strain_ID = dbQuery$Strain_ID,
                      chosen = dbQuery$Genus)

b <- as.data.frame(selectedMeta, stringsAsFactors = FALSE)

d <- as.data.frame(as.matrix(dist(mtcars)))[1:12,1:12]
rownames(d) <- b[,1]
colnames(d) <- b[,1]
d <- as.dist(d)
d <- as.dendrogram(hclust(d))

cols <- colorBlindPalette()
colsd <- cols[factor(b$chosen)]


par(mar = c(5,5,5,10))
plot(d, horiz = T)

IDBacApp::colored_dots(colsd,
                       d,
                       #  rowLabels = names(coloredDend()$bigMatrix),
                       horiz = T,
                       sort_by_labels_order = TRUE)
