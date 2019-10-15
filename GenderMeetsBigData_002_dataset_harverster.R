#<%REGION File header%>
#=============================================================================
# File      : GenderMeetsBigData_001_comparison_search.R
# Author    : Tyszler, Marcelo <m.tyszler@kit.nl>
# Version   : 1.0
# Date      : July 15, 2019
# Changed   : October, 7 2019 9:35:56 AM
# Changed by: Gideon Kruseman (g.kruseman@cgiar.org)
# Published by: Community of Practice on Socio-economic Data, CGIAR Platform for Big Data in Agriculture
# Remarks   :
#   This code was developed under the mini-grant provided by Community of Practice on Socio-economic Data,
#   CGIAR Platform for Big Data in Agriculture to the CGIAR Gender Platform to identify gender related data sets
#   within the CGIAR.
#
#   This is an R-script for the gender datasets across the CGIAR data repositories
#
# License:
# Creative Commons Attribution License 4.0 International
# https://creativecommons.org/licenses/by/4.0/legalcode
#
# Citation:
# Tyszler, M. 2019 Dataset Harvester: searching for gender datasets at the CGIAR. GenderMeetsBigData_002_dataset_harverster.R
#=============================================================================

library(dataverse)
library(WriteXLS)
library(dplyr)
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")

# Loop over dataserve repositories
for (subtree in c("IFPRI",
                  "AfricaRice",
                  "Bioversity",
                  "CIAT",
                  "RiceResearch",
                  "ICRAF",
                  "worldfish",
                  "CCAFSbaseline",
                  "crp6")) {
  
  print (subtree)
  # read datasets with the word "gender" in a metadata field
  df1<-dataverse_search("gender", type = "dataset", subtree = subtree, per_page = 100)
  
  # select
  selection <-df1[c("name","url")]
  selection$server <- "dataverse.harvard.edu"
  selection$subtree <- subtree
  
  #combine
  if (exists("complete_selection")) {
    complete_selection <- rbind(complete_selection, selection)
  } else {
    complete_selection <- selection
  }
}

# loop over Dataverse repositories which require an authentication key
for (source in c("data.cifor.org",
                  "data.cimmyt.org",
                  "data.cipotato.org",
                  "dataverse.icrisat.org",
                 "data.mel.cgiar.org")) {
  
  print (source)
  # read datasets with the word "gender" in a metadata field
  if (source == "data.cipotato.org") {
    key = "USE_YOUR_OWN_KEY"
    df1<-dataverse_search("gender", type = "dataset", server = source, per_page = 100, key = key)
  
  } else  if (source == "data.cifor.org") {
    key = "USE_YOUR_OWN_KEY "
    df1<-dataverse_search("gender", type = "dataset", server = source, per_page = 100, key = key)
    
  } else  if (source == "dataverse.icrisat.org") {
    key = "USE_YOUR_OWN_KEY "
    #df1<-dataverse_search("gender", type = "dataset", server = source, per_page = 100, key = key)
    out <- jsonlite::fromJSON("http://dataverse.icrisat.org/api/search?q=gender&key= USE_YOUR_OWN_KEY &type=dataset&sort=name&order=asc&per_page=100&show_relevance=FALSE&show_facets=FALSE")
    n_total <- ngettext(out$data$total_count, "result", "results")
    message(sprintf(paste0("%s of %s ", n_total, " retrieved"), 
                    out$data$count_in_response, out$data$total_count))
  
    df1<-out$data$items
    
  } else  if (source == "data.mel.cgiar.org") {
    #df1<-dataverse_search("gender", type = "dataset", server = source, per_page = 100, key = key)
    out <- jsonlite::fromJSON("http://data.mel.cgiar.org/api/search?q=gender&type=dataset&sort=name&order=asc&per_page=100&show_relevance=FALSE&show_facets=FALSE")
    n_total <- ngettext(out$data$total_count, "result", "results")
    message(sprintf(paste0("%s of %s ", n_total, " retrieved"), 
                    out$data$count_in_response, out$data$total_count))
    
    df1<-out$data$items
  } else {
    df1<-dataverse_search("gender", type = "dataset", server = source, per_page = 100)
  }
  
  # select
  selection <-df1[c("name","url")]
  selection$server <- source
  selection$subtree <- ""
  
  #combine
  if (exists("complete_selection")) {
    complete_selection <- rbind(complete_selection, selection)
  } else {
    complete_selection <- selection
  }
  
  
}

## Cases where CKAN is used as data repository:
#ILRI
print ("data.ilri.org")
out <- jsonlite::fromJSON("http://data.ilri.org/portal/api/3/action/package_search?q=gender")
n_total <- ngettext(out$result$count, "result", "results")
message(sprintf(paste0("%s of %s ", n_total, " retrieved"), 
                out$result$count,out$result$count))
selection <-out$result$results %>% select(title, url)
colnames(selection)<-c("name","url")
selection$server <- "data.ilri.org"
selection$subtree <- "CKAN"

#combine
if (exists("complete_selection")) {
  complete_selection <- rbind(complete_selection, selection)
} else {
  complete_selection <- selection
}

#IITA
print ("data.iita.org")
out <- jsonlite::fromJSON("http://data.iita.org/api/3/action/package_search?q=gender")
n_total <- ngettext(out$result$count, "result", "results")
message(sprintf(paste0("%s of %s ", n_total, " retrieved"), 
                out$result$count,out$result$count))
selection <-out$result$results %>% select(title, identifier)
colnames(selection)<-c("name","url")
selection$server <- "data.iita.org"
selection$subtree <- "CKAN"

#combine
if (exists("complete_selection")) {
  complete_selection <- rbind(complete_selection, selection)
} else {
  complete_selection <- selection
}


# remove duplicates:
complete_selection<-distinct(complete_selection,url, .keep_all = TRUE)

#export
WriteXLS(complete_selection, "Gender_Inventory_Draft.xlsx", Encoding = "latin1")

## Compare with gardian
print ("gardian")
library(curl)

#authorize online if needed
#Client ID : USE_YOUR_OWN
#Username : USE_YOUR_OWN
#Password : USE_YOUR_OWN

h<-new_handle()
handle_setheaders(h,
                  "accept" = "application/json",
                  "authorization" = USE_YOUR_OWN ,
                  "Content-Type" = "multipart/form-data"
)
handle_setform(h,
               type = "dataset",
               keywords = "gender",
               size="200")
req <- curl_fetch_memory("https://gardian.bigdata.cgiar.org/api/v1/searchGARDIANbyKeyword.php", handle = h)
#jsonlite::prettify(rawToChar(req$content))
out<-jsonlite::fromJSON(rawToChar(req$content))

n_total <- nrow(out)
message(sprintf(paste0("%s of %s ", n_total, " retrieved"), 
                n_total,n_total))
selection <-out$`_source` %>% select(cg.title, cg.identifier.url,cg.contributor)
colnames(selection)<-c("name","url","server")
selection$subtree <- "gardian"

#export
WriteXLS(selection, "Gender_Inventory_Draft_GARDIAN.xlsx", Encoding = "latin1")

# combine
complete_selection_with_Gardian <- rbind(complete_selection, selection)

# remove duplicates:
complete_selection_with_Gardian<-distinct(complete_selection_with_Gardian,name, .keep_all = TRUE)

#export
WriteXLS(complete_selection_with_Gardian, "Gender_Inventory_Complete_Draft.xlsx", Encoding = "latin1")

#============================   End Of File   ================================
