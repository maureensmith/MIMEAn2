#!/usr/local/bin Rscript --vanilla --slave


##############################################################################
# Create project.txt files for MIMEAnTo Calls:
# Voraussetzung: sample_sheet enthalt eine Spalte mit "Sample" und "Encoding,
# unbound, bound (und ggf WT) die zueinander gehören sind gleich sortiert
# oder WT kommt nur einmal vor (für alle)
# U_1 B_1 WT_1 U_2 B_2 WT_2
# Für denn Fall dass WT für je U und B vorhanden ist: TODO: noch anpassen
##############################################################################


# clear the environment variables
rm(list = ls())
library(stringr)
library(seqinr)
#Read in arguments
args = commandArgs(trailingOnly = TRUE)

if(length(args) < 9) {
  cat("\nCall the script with at least 5 arguments: sample_sheet_file refFile count_dir result_dir selected_sample_name unselected_sample_name selected_wt_sample_name unselected_wt_sample_name\n
  #terminate without saving workspace\n\n")
  quit("no")
}

cat(c("Arguments: ", args, "\n"), sep = "\n")


sample_sheet_file=args[1]
refFile<-args[2]
countDir <- args[3]
resultDir <- file.path(args[4])
s_sample=args[5]
u_sample=args[6]
wt_s_sample=args[7]
wt_u_sample=args[8]
m=args[9]

writeFile <- function(projectFile,
                      u_samples, b_samples,
                      u_sampleName, b_sampleName,
                      u_wt_samples, b_wt_samples,
                      reffile, countDir) {
  seqEnd <- length(read.fasta(refFile)[[1]])

  write(paste("refSeqFile", refFile, sep = "\t"), file=projectFile, append = F)
  write(paste("dataDir", countDir, sep = "\t"), file=projectFile,append = T)
  write(paste("alpha", "0.05", sep = "\t"), file=projectFile, append = T)
  write(paste("cutValueBwd", 0, sep = "\t"), file=projectFile, append = T)
  write(paste("cutValueFwd", 0, sep = "\t"), file=projectFile, append = T)
  write(paste("minimumNrCalls", "250000", sep = "\t"), file=projectFile, append = T)
  write(paste("minNumberEstimatableKds", "50", sep = "\t"), file=projectFile, append = T)
  write(paste("minSignal2NoiseStrength", "2", sep = "\t"), file=projectFile, append = T)
  write(paste("minMutRate", "4", sep = "\t"), file=projectFile, append = T)
  write(paste("seqBegin", "1", sep = "\t"), file=projectFile, append = T)
  write(paste("seqEnd", seqEnd, sep = "\t"), file=projectFile, append = T)
  write(paste("percOfMaxCov", "0.5", sep = "\t"), file=projectFile, append = T)
  write(paste("joinErrors", "false", sep = "\t"), file=projectFile, append = T)
  write(paste("signThreshold", 0, sep = "\t"), file=projectFile, append = T)

  for(i in seq(length(u_samples))) {
    name <- paste0(u_sampleName[i],"vs",b_sampleName[i], "_", i)
    write(paste("selected", b_wt_samples[i], name, 0, sep = "\t"), file=projectFile, append = T)
    write(paste("nonselected", u_wt_samples[i], name, 0, sep = "\t"), file=projectFile, append = T)

    write(paste("selected", b_samples[i], name, i, sep = "\t"), file=projectFile, append = T)
    write(paste("nonselected", u_samples[i], name, i, sep = "\t"), file=projectFile, append = T)
  }
}

if(file.exists(sample_sheet_file)) {


  sample_sheet=read.table(sample_sheet_file,header=T, sep=";")

  #WORKAROUND: copy count files with barcode
  # for(i in seq(nrow(sample_sheet))) {
  #   countfile=paste0(countDir,"/1d/", sample_sheet$Sample[i],".txt")
  #   countfile_copy=paste0(countDir,"/1d/", sample_sheet$Sample.Number[i],".txt")
  #   #print(countfile)
  #   system(paste("cp", countfile, countfile_copy))
  #   countfile=paste0(countDir,"/2d/", sample_sheet$Sample[i],".txt")
  #   countfile_copy=paste0(countDir,"/2d/", sample_sheet$Sample.Number[i],".txt")
  #   #print(countfile)
  #   system(paste("cp", countfile, countfile_copy))
  # }

  # use regular expressession for later
  # since the files have to be with integer input, write them the barcode
  s_barcodes <- sample_sheet$Encoding[str_detect(sample_sheet$Sample,s_sample)]
  u_barcodes <- sample_sheet$Encoding[str_detect(sample_sheet$Sample,u_sample)]
  s_names <- sample_sheet$Sample[str_detect(sample_sheet$Sample,s_sample)]
  u_names <- sample_sheet$Sample[str_detect(sample_sheet$Sample,u_sample)]
  wt_s_barcodes<- sample_sheet$Encoding[str_detect(sample_sheet$Sample,wt_s_sample)]
  wt_u_barcodes<- sample_sheet$Encoding[str_detect(sample_sheet$Sample,wt_u_sample)]

  # because we only have one unselected sample vs several selected sample (0 vs 2,4,6,8)
  
  # because we only have one wt each
  # if(length(wt_s_barcodes) < length(s_barcodes))
  #   wt_s_barcodes<-rep(wt_s_barcodes, length(s_barcodes)/length(wt_s_barcodes))
  # if(length(wt_u_barcodes) < length(u_barcodes))
  #   wt_u_barcodes<-rep(wt_u_barcodes, length(u_barcodes)/length(wt_u_barcodes))
  
  print(s_barcodes)
  print(wt_s_barcodes)
  print(u_barcodes)
  print(wt_u_barcodes)


  if(length(u_barcodes) == length(s_barcodes)
     & length(u_barcodes) == length(wt_s_barcodes)
     & length(u_barcodes) == length(wt_u_barcodes)) {
    rDir=paste0(resultDir,"/", m)
    dir.create(rDir, showWarnings = FALSE, recursive = TRUE)
    projectFile <- paste0(rDir, "/project.txt")
    writeFile(projectFile, u_barcodes, s_barcodes, u_names, s_names, wt_u_barcodes, wt_s_barcodes, reffile, countDir)
  } else{
    cat("\nSomething went wrong with different sample lengths!\n\n")
    quit("no")
  }

} else {
  cat("\nSample sheet does not exist!\n\n")
  quit("no")
}
