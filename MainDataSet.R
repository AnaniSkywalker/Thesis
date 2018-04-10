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
Main.Data <- read.csv("survey.csv", header =T, sep =",")

# Adding New Data Variables
set.seed(1)
  #Adding Contry.ID as correspondent to Country
Main.Data <- transform(Main.Data,Country.ID=as.numeric(factor(Country)))
  #Adding Contry.ID as correspondent to Country
Main.Data$No.Of.Family.Membs <- sample(1:8, size = nrow(Main.Data), replace = TRUE)
Main.Data$PersonID <- sample(1000:5000, nrow(Main.Data), replace=F)
Main.Data$CompanyID <- sample(1000:5000, nrow(Main.Data), replace=F)
Main.Data$Head.Of.Family <- sample(c("Yes","No"), nrow(Main.Data), replace=T)

#Main.Data <- Main.Data %>% mutate(NewRow = row_number())
Main.Data$CompanyName <- as.vector(randomStrings(n=nrow(Main.Data), len=5, digits=FALSE, upperalpha=TRUE,
                                                 loweralpha=FALSE, unique=FALSE, check=TRUE))

# Selecting Data Variables by names
Persons <- Main.Data[c("Timestamp","Age","Gender","self_employed","treatment","work_interfere",
                       "tech_company","seek_help","anonymity","mental_health_consequence",
                       "phys_health_consequence","coworkers","supervisor","mental_health_interview",
                       "phys_health_interview","mental_vs_physical","obs_consequence","comments",
                       "PersonID","CompanyID","Country.ID")]
Countries <- Main.Data[c("Timestamp","Country","state","Country.ID")]
FamilyInformation <- Main.Data[c("Timestamp","family_history","PersonID","No.Of.Family.Membs","Head.Of.Family")]
CompanyInformation <- Main.Data[c("Timestamp","no_employees","remote_work","benefits","care_options",
                                  "wellness_program","leave","CompanyName","Country","CompanyID")]

write.csv(Persons, "Persons.csv", row.names =T)
write.table(Countries, "Countries.sql", row.names =T)
write.table(FamilyInformation, "FamilyInformation.txt", row.names =T)
write.table(CompanyInformation, "CompanyInformation.xlsx", row.names =T)



