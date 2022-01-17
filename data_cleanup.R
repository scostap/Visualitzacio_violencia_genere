# Script to clean and arrange data to be loaded on Tableau for the Visualització de Violència de gènere

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)

# Read dataset
atencions_df <- read.csv("Atencions_dels_Serveis_i_oficines_d_informaci__i_atenci__a_les_dones_i_Oficines_de_l_Institut_Catal__de_les_Dones.csv", stringsAsFactors = FALSE)
trucades_df <- read.csv("L_nia_d_atenci__contra_la_viol_ncia_masclista_900_900_120.csv", stringsAsFactors = FALSE)

# Read additional datasets on Comarques
pib19_df <- read_csv(file="t13830com.csv", skip=8)
ist18_df <- read_csv(file="t14034com.csv", skip=8)
ise18_df <- read_csv(file="t14037com.csv", skip=10)
formacio19_df <- read_csv(file="t14540com.csv", skip=8)
atur20_df <- read_csv(file="t4299com.csv", skip=7)
irm12_df <- read_csv(file="t8228com.csv", skip=9)
iprosocial119_df <- read_csv(file="t8235com.csv", skip=12)
iprosocial219_df <- read_csv(file="t8236com.csv", skip=10)
poblacio21_df <- read_csv(file="t9122com.csv", skip=8)

# Update column names
colnames(poblacio21_df)[-c(1,2)] <- paste0("Poblacio.", colnames(poblacio21_df)[-c(1,2)])
colnames(ise18_df)[-c(1,2)] <- paste0("ISE.", colnames(ise18_df)[-c(1,2)])
colnames(irm12_df)[-c(1,2)] <- paste0("IRM.", colnames(irm12_df)[-c(1,2)])
colnames(iprosocial119_df)[-c(1,2)] <- paste0("IPROSOC.", colnames(iprosocial119_df)[-c(1,2)])
colnames(iprosocial219_df)[-c(1,2)] <- paste0("IPROSOC.", colnames(iprosocial219_df)[-c(1,2)])
colnames(formacio19_df)[-c(1,2)] <- paste0("Formacio.", colnames(formacio19_df)[-c(1,2)])
colnames(atur20_df)[-c(1,2)] <- paste0("Atur.", colnames(atur20_df)[-c(1,2)])

# Join data on Comarques in a single dataframe
dataList <- list(atur20_df, formacio19_df, iprosocial119_df, iprosocial219_df,
                 irm12_df, ise18_df, ist18_df, pib19_df, poblacio21_df)

comarques_df <- Reduce(function(...) merge(..., by=c("Codi", "Literal"), all=TRUE), dataList)
comarques_df <- head(comarques_df, -1)

# Clean memory
rm(dataList,atur20_df, formacio19_df, iprosocial119_df, iprosocial219_df,
   irm12_df, ise18_df, ist18_df, pib19_df, poblacio21_df)

## Clean and ammend data inconsistency data

# Map blank to NA
trucades_df[trucades_df == ""] <- NA
atencions_df[atencions_df == ""] <- NA

# Remap values for integrity on datasets
comarques_df$Literal[comarques_df$Literal == "Aran"] <- "Val d'Aran"

trucades_df$Comarca[trucades_df$Comarca == "Val d’Aran"] <- "Val d\'Aran"
trucades_df$Comarca[trucades_df$Comarca == "Pla de l’Estany"] <- "Pla de l\'Estany"
trucades_df$Comarca[trucades_df$Comarca == "Pla d’Urgell"] <- "Pla d\'Urgell"
trucades_df$Comarca[trucades_df$Comarca == "Ribera d’Ebre"] <- "Ribera d'Ebre"
trucades_df$Nacionalitat[trucades_df$Nacionalitat == "Unió europea"] <- "Unió Europea"

trucades_df$Provincia[trucades_df$Provincia == "Astúries"] <- "Asturias"
trucades_df$Provincia[trucades_df$Provincia == "Cádiz"] <- "Cadiz"
trucades_df$Provincia[trucades_df$Provincia == "Castellón"] <- "Castellon"
trucades_df$Provincia[trucades_df$Provincia == "Màlaga"] <- "Malaga"

trucades_df$Hora <- gsub("1899-12-31T", "", trucades_df$Hora)
trucades_df$Data <- as.Date(trucades_df$Data, format='%d/%m/%Y')
trucades_df$Datetime <-paste(as.character(trucades_df$Data), trucades_df$Hora, sep='T') 
trucades_df$Relació.agressor[trucades_df$Relació.agressor == "Fill / fills"] <- "Fill/fills"
trucades_df$Relació.agressor[trucades_df$Relació.agressor == "Germà / germans"] <- "Germà/germans"
trucades_df$Edat[trucades_df$Edat == "Menor de 18 anys"] <- "<18"
trucades_df$Edat[trucades_df$Edat == "Menors de 18 anys"] <- "<18"
trucades_df$Edat[trucades_df$Edat == "Entre 18 i 30 anys"] <- "18-30"
trucades_df$Edat[trucades_df$Edat == "Entre 18 i 31 anys"] <- "18-30"
trucades_df$Edat[trucades_df$Edat == "Entre 31 i 40 anys"] <- "31-40"
trucades_df$Edat[trucades_df$Edat == "Entre 41 i 50 anys"] <- "41-50"
trucades_df$Edat[trucades_df$Edat == "Entre 51 i 60 anys"] <- "51-60"
trucades_df$Edat[trucades_df$Edat == "Més de 60 anys"] <- ">60"
trucades_df$Llengua[is.na(trucades_df$Llengua)] <- "No consta"

# Define function to fill get mode
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Index rows to be corrected
idx.ForaCat <- (trucades_df$Comarca %in% comarques_df$Literal & trucades_df$Província.agrupada == "Fora de Catalunya")
trucades.errors <- trucades_df[idx.ForaCat,]

for (i in comarques_df$Literal) {
  if (sum(is.na(trucades.errors[trucades.errors$Comarca == i,]$Provincia)) != 0 |
      sum(trucades.errors[trucades.errors$Comarca == i,]$Provincia == "No consta") != 0) {
    trucades.errors[trucades.errors$Comarca == i,]$Provincia <- as.character(Mode(na.omit(trucades_df[trucades_df$Comarca == i,]$Provincia)))
  }
  if (sum(is.na(trucades.errors[trucades.errors$Comarca == i,]$Àmbit.territorial)) != 0 |
      sum(trucades.errors[trucades.errors$Comarca == i,]$Àmbit.territorial == "No consta") != 0) {
    trucades.errors[trucades.errors$Comarca == i,]$Àmbit.territorial <- as.character(Mode(na.omit(trucades_df[trucades_df$Comarca == i,]$Àmbit.territorial)))
  }
  if (sum(is.na(trucades.errors[trucades.errors$Comarca == i,]$Província.agrupada)) != 0 |
      sum(trucades.errors[trucades.errors$Comarca == i,]$Província.agrupada == "Fora de Catalunya") |
      sum(trucades.errors[trucades.errors$Comarca == i,]$Província.agrupada == "No consta") != 0) {
    trucades.errors[trucades.errors$Comarca == i,]$Província.agrupada <- as.character(Mode(na.omit(trucades_df[trucades_df$Comarca == i,]$Província.agrupada)))
  }
}

trucades_df[idx.ForaCat,] <- trucades.errors

trucades_df[trucades_df$Província.agrupada == "Fora de Catalunya",]$Comarca <- "Altres"
trucades_df[(trucades_df$Província.agrupada == "Fora de Catalunya" & is.na(trucades_df$Provincia)),]$Provincia <- "No consta"

# Delete records left with no data on Comarques
trucades_df <- trucades_df[!is.na(trucades_df$Comarca),]

# Correct Provincia and Província.agrapada
for (i in comarques_df$Literal) {
  prov <- as.character(Mode(na.omit(trucades_df[trucades_df$Comarca == i,]$Provincia)))
  provagr <- as.character(Mode(na.omit(trucades_df[trucades_df$Comarca == i,]$Provincia)))
  trucades_df[(trucades_df$Comarca == i & trucades_df$Provincia != prov), "Provincia"] <- prov
  trucades_df[(trucades_df$Comarca == i & trucades_df$Província.agrupada != provagr), "Província.agrupada"] <- provagr
}

atencions_df$Comarca[atencions_df$Comarca == "Conselh Generau d'Aran"] <- "Val d'Aran"

# Convert to categorical
atencions_df <- atencions_df %>% mutate_if(is.character,as.factor)
#str(atencions_df)
trucades_df[c(-6,-57)] <- trucades_df[c(-6,-57)] %>% mutate_if(is.character,as.factor)
trucades_df$Any <- as.factor(trucades_df$Any)
#summary(trucades_df)

# Write files to disk
#trucades_sm <- trucades_df %>% sample_frac(.2)
write.csv(trucades_df,"trucades.csv", row.names = TRUE)
write.csv(comarques_df,"comarques.csv", row.names = TRUE)

