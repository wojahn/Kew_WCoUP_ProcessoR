#' Makes A Google Sheet Form To Translate Multiple Words Into 106 Languages
#' @param pathway character: path to WCoUP PDF file
#' @param InstallDs character: path to WCoUP PDF file
#' @export
# Written by John M. A. Wojahn March 2021
# This is Free and Open-Source Software (F.O.S.S.)
# © S. Buerki, J. M. A. Wojahn
# Provided under the GNU GPLv3 License
# Funded by Idaho EPSCoR GEM3

Kew_WCoUP_ProcessoR <- function(pathway,InstallDs)
{
  if(InstallD == T)
  {
    message("Checking if dependancies are installed")
    donez <- installed.packages()
    if(!"devtools" %in% donez)
    {
      install.packages("devtools")
    }
    if(!"tabulizer" %in% donez)
    {
      devtools::install_github("ropensci/tabulizer")
    }
  }
  message("Reading in PDF")
  WCoUS <- as.data.frame(tabulizer::extract_text(pathway))
  WCoUS <- as.data.frame(unlist(strsplit(WCoUS[1,1], split = "\n")))
  WCoUS <- as.data.frame(WCoUS[-(1:777),]) #remove introduction
  #remove page numbers
  message("Removing page numbers")
  pages <- as.vector(matrix(nrow=689, ncol = 1))
  for(i in 1:689)
  {
    pages[i] <- paste0("Page ",i," of 689 ")
  }
  WCoUS <- as.data.frame(WCoUS[!WCoUS[,1] %in% pages,])
  gc()
  pages <- as.vector(matrix(nrow=689, ncol = 1))
  for(i in 1:689)
  {
    pages[i] <- paste0("Page ",i," of 689")
  }
  pb <- txtProgressBar(min = 1, max = 689, style = 3)
  for(i in 1:689)
  {
    setTxtProgressBar(pb, i)
    #print(i)
    if(grepl(pages[i], WCoUS))
    {
      #print("Removing missed")
      WCoUS <- as.data.frame(gsub(pages[i], "", WCoUS))
    }
  }
  gc()
  write.csv(WCoUS,"WCoUS_intermediate.csv", row.names = F)
  message("Removing headers and footers")
  bad1 <- WCoUS[128,1]
  bad2 <- WCoUS[129,1]
  WCoUS <- as.data.frame(WCoUS[!WCoUS[,1] == bad1,])
  WCoUS <- as.data.frame(WCoUS[!WCoUS[,1] == bad2,])
  WCoUS <- as.data.frame(WCoUS[!WCoUS[,1] == " ",])
  NWS <- as.data.frame(matrix(nrow=nrow(WCoUS),ncol=1))
  pb <- txtProgressBar(min = 1, max = nrow(WCoUS), style = 3)
  for(i in 1:nrow(WCoUS))
  {
    setTxtProgressBar(pb, i)
    NWS[i,1] <- trimws(WCoUS[i,1])
  }
  WCoUS <- as.data.frame(NWS)
  rm(NWS)
  message("Extracting, cleaning, and sorting text")
  WCoUS <- as.data.frame(WCoUS[-which(!grepl(" ",WCoUS[,1])),])
  Reformed <- as.data.frame(matrix(nrow=0,ncol=2))
  colnames(Reformed) <- c("Taxa", "Uses")
  colnames(WCoUS) <- "Part"
  pb <- txtProgressBar(min = 1, max = nrow(WCoUS), style = 3)
  for(i in 1:nrow(WCoUS))
  {
    setTxtProgressBar(pb, i)
    if(grepl("|",as.character(WCoUS[i,1]), fixed = T))
    {
      if(exists("nomen"))
      {
        tobind  <- as.data.frame(matrix(nrow=1,ncol=2))
        colnames(tobind) <- c("Taxa", "Uses")
        tobind[1,1] <- nomen
        tobind[1,2] <- as.character(WCoUS[i,1])
        Reformed <- as.data.frame(rbind(Reformed, tobind))
        rm(nomen)
      }else{
        Reformed[nrow(Reformed),2] <- paste0(Reformed[nrow(Reformed),2], " ", as.character(WCoUS[i,1]))
      }
    }else{
      if(exists("nomen"))
      {
        nomennovum <- as.character(WCoUS[i,1])
        nomen <- paste(nomen, " ", nomennovum)
        rm(nomennovum)
      }else{
        nomen <- as.character(WCoUS[i,1])
      }
    }
  }
  print("Populating outfile")
  OUT <- as.data.frame(matrix(nrow=nrow(Reformed),ncol=3))
  colnames(OUT) <- c("Species","Authority","Uses")
  pb <- txtProgressBar(min = 1, max = nrow(Reformed), style = 3)
  for(i in 1:nrow(Reformed))
  {
    setTxtProgressBar(pb, i)
    split <- as.data.frame(unlist(strsplit(Reformed[i,1], split = " ")))
    split <- as.data.frame(split[!split[,1] == " ",])
    OUT[i,1] <- paste0(split[1,1], " ", split[2,1])
    OUT[i,2] <- paste0(split[3:nrow(split),1], collapse = " ")
    split <- as.data.frame(unlist(strsplit(Reformed[i,2], split = "\\|")))
    OUT[i,3] <- split[2,1]
  }
  message("Replacing abbreviations with real uses")
  abbrv <- c("AF","EU","FU","GS","HF","IF","MA","ME","PO","SU")
  real <- c("AnimalFood","EnvironmentalUses","Fuels","GeneSources","HumanFood","InvertebrateFood","Materials","Medicines","Poisons","SocialUses")
  pb <- txtProgressBar(min = 1, max = nrow(OUT), style = 3)
  for(i in 1:nrow(OUT))
  {
    setTxtProgressBar(pb, i)
    uses <- as.character(OUT[i,3])
    uses <- trimws(uses)
    uses <- as.vector(unlist(strsplit(uses, split = " ")))
    for(j in 1:length(uses))
    {
      if(uses[j] %in% abbrv)
      {
        uses[j] <- as.character(real[abbrv == uses[j]])
      }
    }
    OUT[i,3] <- paste(uses, collapse = ",")
  }
  return(OUT)
}
