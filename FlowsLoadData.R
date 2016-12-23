#------------------------------------------------------------------------------
# Name:FlowsLoadData.R
#
# Author: Z LEBOURGEOIS
# 
# Created: 28-08-2016
# 
# Version: 1.0
# 
# Description
# -----------
# Load of raw data for Flows project
# 
#------------------------------------------------------------------------------   

# Raw data plus SA article descriptions (GA articles available in case further work on analysing rebut is required)

  #filepath     <- "G:/SERVICE/METHODE/SERVICE/DONNEES DE BASE/1 SERVICE DONNEES DE BASE/3 CHANTIERS ENQUETES ET SUIVIS/1 EN COURS/R project/"
  filename_ALL <- "FLUX.xlsx"
  filename_SA  <- "SA Articles.xlsx"
  # filename_GA  <- "GA Articles.xlsx"

  #ALLfile <- paste0(filepath, filename_ALL)
  ALLfile <- paste0(filename_ALL)
  #SAfile  <- paste0(filepath, filename_SA)
  SAfile  <- paste0(filename_SA)
  # GAfile  <- paste0(filepath, filename_GA)
  
  ALLData <- read_excel(ALLfile, sheet = "A")

  SAData <- read_excel(SAfile)
  SAData <- SAData %>%
    select(ArticleSA     = `N° Article`,
           Description   = `Description article`) %>%
           distinct()
  
  # GAData <- read_excel(GAfile)
  # GAData <- GAData %>%
  #   select(ArticleGA     = `N° Article`,
  #          Description   = `Description article`) %>%
  #   distinct()
  

  flux <- ALLData %>%
    select(Reference, 
           #ArticleGA,
           PosteIFSMoulage,
           PosteIFSEbarbage,
           PosteIFSSechage,
           PosteFinishing,
           ArticleSA = ArticlesFinishing)
  

# Run redVars for basic data set    
  redVars()
  
# Replace the asterisks in Description with underscores  
  
  flux <- flux %>%
    mutate(Description = (str_replace_all(flux$Description,"[*]", "_")))
  
# Create new variables for choices
  
  flux <- flux %>%
    mutate(forme = str_sub(flux$Description, 1L, 5L)) %>%
    mutate(finish = str_sub(flux$Description, 14L, 15L)) %>%
    mutate(sac = str_sub(flux$Description, 16L, 18L))
  
# Set up dataframes of lookups for choices  - to remove function
  # choices()
  
# Clean up  
  rm(list = c('filepath', 'filename_ALL','filename_SA','ALLfile', 'GAfile', 'GAData', 'SAfile', 'SAData','ALLData'))

  