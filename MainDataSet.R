# Shree Rai Mijarguttu, Karelys Osuna Esquijarosa, Brandon Harden, Anani Assoutovi 

# Clean Environment:
rm(list = ls())

# Function: installing and loading of packages
install_load <- function (packages)  {   
  
  # Start loop to determine if each package is installed
  for(package in packages){
    
    # If package is installed locally, load
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package))
    
    # If package is not installed locally, download, then load
    else {
      install.packages(package, dependencies = TRUE)
      do.call("library", list(package))
    }
  } 
}
# Generic libraries loading
libs <- c("ggplot2", "maps", "MASS", "gdata", "foreign", "devtools","tidyverse","dplyr","uuid","random")
install_load(libs)

# Specific methods libraries loading
libs.methods <- c("C50", "lattice", "caret", "nnet", "e1071","Matrix", "foreach","glmnet","C50","randomForest","ipred","rpart")
install_load(libs.methods)

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  return(tolower(os))
}
setWorkDir <- function(){
  if(get_os() == "windows"){
    setWork <- setwd("C:/Users/aassoutovi/Documents/RStudioFiles/CaseStudies")
  }
  else if(get_os() == "osx"){
    setWork <- setwd("~/Desktop/PRACTICUM_II/Thesis/")
  }
  else{
    print("I DO NOT RECOGNIZED YOUR OS!!!")
  }
}
setWorkDir()
getwd()

# Loading the dataset
Main_Data <- read.csv("survey.csv", header =T, sep =",")

# Adding New Data Variables
set.seed(1)
  #Adding Contry.ID as correspondent to Country
Main_Data <- transform(Main_Data,CountryID=as.numeric(factor(Country)))
  #Adding Contry.ID as correspondent to Country
Main_Data$No_Of_Family_Membs <- sample(1:8, size = nrow(Main_Data), replace = TRUE)
Main_Data$PersonID <- sample(1000:5000, nrow(Main_Data), replace=F)
Main_Data$CompanyName <- as.vector(randomStrings(n=nrow(Main_Data), len=5, digits=FALSE, upperalpha=TRUE,
                                                 loweralpha=FALSE, unique=FALSE, check=TRUE))
Main_Data <- transform(Main_Data,CompanyID=as.numeric(factor(CompanyName)))
Main_Data$Head_Of_Family <- sample(c("Yes","No"), nrow(Main_Data), replace=T)

# Selecting Data Variables by names
Persons <- Main_Data[c("Timestamp","Age","Gender","self_employed","treatment","work_interfere",
                       "tech_company","seek_help","anonymity","mental_health_consequence",
                       "phys_health_consequence","coworkers","supervisor","mental_health_interview",
                       "phys_health_interview","mental_vs_physical","obs_consequence","comments",
                       "PersonID","CompanyID","CountryID")]
Countries <- Main_Data[c("Timestamp","Country","state","CountryID")]
FamilyInformation <- Main_Data[c("Timestamp","family_history","PersonID","No_Of_Family_Membs","Head_Of_Family")]
CompanyInformation <- Main_Data[c("Timestamp","no_employees","remote_work","benefits","care_options",
                                  "wellness_program","leave","CompanyName","Country","CompanyID")]

write.csv(Persons, "Persons.csv", row.names =T)
write.table(Countries, "Countries.sql", row.names =T)
write.table(FamilyInformation, "FamilyInformation.txt", row.names =T)
write.table(CompanyInformation, "CompanyInformation.xlsx", row.names =T)

# Creating a New Data from modified Dataset
NewMainData <- Main_Data
columnNames <- as.array(colnames(NewMainData))
NHH <- data.frame(rbind(as.matrix(NewMainData), as.matrix(NewMainData,nrow=nrow(NewMainData)*5,ncol=ncol(NewMainData))))
MediumData <- rbind(NewMainData, NHH, stringsAsFactors=FALSE)
MediumHighData <- rbind(NHH, MediumData, stringsAsFactors=FALSE)
HighData <- rbind(MediumData, MediumHighData, stringsAsFactors=FALSE)
