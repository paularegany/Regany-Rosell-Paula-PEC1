
install.packages("BiocManager")
library(BiocManager)
BiocManager::install("SummarizedExperiment")

library(SummarizedExperiment)

# Carreguem les dades
dades <- read.csv("C:/Users/pregany/Desktop/MÀSTER/ADO/PAC_1/2018-MetabotypingPaper/DataValues_S013.csv", row.names = 1)
metadades <- read.csv("C:/Users/pregany/Desktop/MÀSTER/ADO/PAC_1/2018-MetabotypingPaper/DataInfo_S013.csv", row.names = 1)


SE <- SummarizedExperiment(
  assays = list(counts = as.matrix(dades)), # matriu amb les dades numèriques
  colData = metadades # metadades
)

SE

# Guardem el summarized experiment

save(SE, file = "dades_metabol_paper.Rda")

# Guardem exclusivament la matriu de dades en una variable per tal de treballar amb elles

assay_data <- assay(SE)

# Mirem l'estructura de les dades
str(assay_data)
head(assay_data)

# Comprovem que no hi hagis NA a les dades
sum(is.na(assay_data))

# Com que hi ha molts NAs anem a mirar com estan distribuits dins el dataset

na_count <- colSums(is.na(assay_data))
na_percentage <- (na_count / nrow(assay_data)) * 100

na_report <- data.frame(
  Column = colnames(assay_data),
  NA_Count = na_count,
  NA_Percentage = na_percentage
)

print(na_report)

threshold <- 5
eliminar_cols <- na_report$Column[na_report$NA_Percentage > threshold]
print(eliminar_cols)

# Com podem veure borrariem 167 del total de 695 variables
# Accedim a les metadades de les columnes amb colData
metadades_info <- colData(SE)

# Filtrem la descripció i el tipus de les columnes a borrar
eliminar_cols_info <- metadades_info[eliminar_cols, c("varTpe", "Description")]

print(eliminar_cols_info)
# Primer filtrem les columnes perjudicials
assay_filtered <- assay_data[, !(colnames(assay_data) %in% eliminar_cols)]

# Comprovem que hi ha diferència entre els dos datasets
dim(assay_data)

dim(assay_filtered)

# Eliminem les files amb NA del conjunt original
assay_data_dropped <- na.omit(assay_data)

# Eliminem files amb Na del conjunt de dades filtrat
assay_filtered_dropped <- na.omit(assay_filtered)




