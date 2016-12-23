#------------------------------------------------------------------------------
# Name:FlowsFunctions.R
#
# Author: Z LEBOURGEOIS
# 
# Created: 28-08-2016
# 
# Version: 1.0
# 
# Description
# -----------
# This is the Functions R script for the Flows project.
# All the functions to perform the actual analysis in the project are stored here.
# This file should do nothing other than define the functions needed for analysis.
# 
#------------------------------------------------------------------------------   
#
# Function 1: Reduce ALLData to flux 
# (joining Description data from IFS and calculating frequencies)

rm(list=ls())

redVars  <- function(){

  fluxColnames <- colnames(flux)
  
# Add starting post for each unique chain of posts
  flux <- mutate(flux, MldSite = str_extract(PosteIFSMoulage, "^.."))
  
# Add index for each unique chain of posts
  flux <- mutate(flux, pKey = group_indices_(flux,
                                             .dots= fluxColnames))
  
  rm(fluxColnames)
  
# Add a frequency column
  flux <- 
    flux %>%
    group_by(pKey) %>%
    mutate(freq = n())

# Join the SA code and description

  flux <<- flux %>%
    ungroup() %>%
    left_join(SAData) %>%
    arrange(pKey)
  
}

#Other functions removed - available in FlowsFunctionsBK.R
#Function 8: Create links

createLinks <- function(spec){
  
  fluxLink1 <- 
    spec %>%
    ungroup() %>%
    group_by(PosteIFSMoulage, PosteIFSEbarbage, freq) %>%
    distinct(pKey) %>%
    select(N1 = PosteIFSMoulage, N2 = PosteIFSEbarbage, freq, pKey)
  
  fluxLink2 <- 
    spec %>%
    ungroup() %>%
    group_by(PosteIFSEbarbage, PosteIFSSechage, freq) %>%
    distinct(pKey) %>%
    select(N1 = PosteIFSEbarbage, N2 = PosteIFSSechage, freq, pKey)
  
  fluxLink3 <- 
    spec %>%
    ungroup() %>%
    group_by(PosteIFSSechage, PosteFinishing, freq) %>%
    distinct(pKey) %>%
    select(N1 = PosteIFSSechage, N2 = PosteFinishing, freq, pKey)
  
# Join the three sets of links into long table
  linked <- 
    bind_rows(fluxLink1, fluxLink2, fluxLink3)
  
  rm(list = c('fluxLink1', 'fluxLink2', 'fluxLink3'))
  
# Remove rows which are now empty  (due to rebut calcs)
  linked  <- linked %>%
    filter(!(N1 == "" & N2 == ""))
  
  linked  <- linked %>%
    ungroup %>%
    mutate(N2 = ifelse(N1 == grepl('reb', N1), NA, N2))
  
}

# # Function 11: Create dataframes of choices
# 
# choices <- function(){
# 
# formes    <<- data_frame(forme = str_sub(flux$Description, 1L, 5L), site = flux$MldSite) %>%
#   distinct_() %>%
#   na.omit()%>%
#   arrange(forme)
# 
# finishes  <<- data_frame(finish = str_sub(flux$Description, 14L, 15L)) %>%
#   distinct_() %>%
#   na.omit()%>%
#   arrange(finish)
# 
# sacs      <<- data_frame(sac = str_sub(flux$Description, 16L, 18L)) %>%
#   distinct_() %>%
#   na.omit()%>%
#   arrange(sac)
# 
# }