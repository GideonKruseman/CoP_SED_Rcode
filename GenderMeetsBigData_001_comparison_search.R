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
#   This is an R-script for the comparison search using the identified gender data sets at IFPRI
#
# License:
# Creative Commons Attribution License 4.0 International
# https://creativecommons.org/licenses/by/4.0/legalcode
#
# Citation:
# Tyszler, M. 2019 Comparison search: use case IFPRI gender data sets. enderMeetsBigData_001_comparison search.R
#=============================================================================
#<%/REGION File header%>
library(dataverse)
library(WriteXLS)
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")

## Supporting functions
keywords <-function(id) {
  # load dataset metadata
  ds<-dataset_metadata(id)
  content<-ds$fields$value

  # search for keywords list
  for (i in 1:length(content)){
    sub_content <- content[[i]]
    if ("keywordValue" %in% colnames(sub_content)) {
      list_of_kw <- paste(sort(sub_content$keywordValue$value), collapse = ",")
      return(list_of_kw)
    }
  }


}


ifpri<-data.frame(c("hdl:1902.1/17954",
                    "hdl:1902.1/11189",
                    "hdl:1902.1/11180",
                    "hdl:1902.1/17753",
                    "hdl:1902.1/17801",
                    "hdl:1902.1/17608",
                    "hdl:1902.1/17408",
                    "hdl:1902.1/17357",
                    "hdl:1902.1/17531",
                    "hdl:1902.1/19058",
                    "hdl:1902.1/17606",
                    "hdl:1902.1/17082",
                    "hdl:1902.1/17045",
                    "hdl:1902.1/15580",
                    "hdl:1902.1/15640",
                    "hdl:1902.1/17079",
                    "hdl:1902.1/15646",
                    "hdl:1902.1/17988&version=6.1",
                    "hdl:1902.1/19160",
                    "hdl:1902.1/19236",
                    "hdl:1902.1/19237",
                    "hdl:1902.1/21266",
                    "doi:10.7910/DVN/27857",
                    "doi:10.7910/DVN/27704",
                    "doi:10.7910/DVN/27883",
                    "doi:10.7910/DVN/26930",
                    "doi:10.7910/DVN/28558",
                    "doi:10.7910/DVN/MUOX19",
                    "doi:10.7910/DVN/29015",
                    "doi:10.7910/DVN/DH1O3J",
                    "doi:10.7910/DVN/YW4WIT",
                    "doi:10.7910/DVN/AXGCHT",
                    "doi:10.7910/DVN/T9GGYA",
                    "doi:10.7910/DVN/RN40SP",
                    "doi:10.7910/DVN/0R5WTU",
                    "doi:10.7910/DVN/KUSXJR",
                    "doi:10.7910/DVN/BXSYEL",
                    "doi:10.7910/DVN/5CXCLX",
                    "doi:10.7910/DVN/ODARXH",
                    "doi:10.7910/DVN/DKURGR",
                    "doi:10.7910/DVN/LT631P",
                    "doi:10.7910/DVN/FO8WDU",
                    "doi:10.7910/DVN/PUK1P7",
                    "doi:10.7910/DVN/JJJBQ0",
                    "doi:10.7910/DVN/UP7WQ2",
                    "doi:10.7910/DVN/FSMCTQ",
                    "doi:10.7910/DVN/JWMCXY",
                    "doi:10.7910/DVN/LEP9KF",
                    "doi:10.7910/DVN/K5NSAF",
                    "doi:10.7910/DVN/GI0TEC",
                    "doi:10.7910/DVN/FOYZBL",
                    "doi:10.7910/DVN/AORZAU",
                    "doi:10.7910/DVN/XNAHHB",
                    "doi:10.7910/DVN/OWOETW",
                    "doi:10.7910/DVN/MP1KRD",
                    "doi:10.7910/DVN/DXMARV",
                    "doi:10.7910/DVN/BP23OB",
                    "doi:10.7910/DVN/VA2MER",
                    "doi:10.7910/DVN/JU7QP6",
                    "doi:10.7910/DVN/CBVLK5",
                    "doi:10.7910/DVN/RBW801"),
                  stringsAsFactors = FALSE
)

colnames(ifpri)<-"id"

## Search:

# retrieve
df1<-dataverse_search("gender", type = "dataset", subtree = "IFPRI", per_page = 100)
a1<-df1[c("name","global_id")]
a1$keywords<-""
for (i in 1:nrow(a1)) {
  print(a1$name[i])
  a1$keywords[i]<-keywords(a1$global_id[i])
}

#export
WriteXLS(a1, "temp1.xlsx", Encoding = "latin1")

# retrieve
df2<-dataverse_search("women", type = "dataset", subtree = "IFPRI", per_page = 100)
a2<-df2[c("name","global_id")]
a2$keywords<-""
for (i in 1:nrow(a2)) {
  print(a2$name[i])
  a2$keywords[i]<-keywords(a2$global_id[i])
}


#export
WriteXLS(a2, "temp2.xlsx", Encoding = "latin1")

# retrieve
df3<-dataverse_search("female", type = "dataset", subtree = "IFPRI", per_page = 100)
a3<-df3[c("name","global_id")]
a3$keywords<-""
for (i in 1:nrow(a3)) {
  print(a3$name[i])
  a3$keywords[i]<-keywords(a3$global_id[i])
}

#export
WriteXLS(a3, "temp3.xlsx", Encoding = "latin1")


###
ifpri$keywords<-""
for (i in 1:nrow(ifpri)) {
  print(ifpri$id[i])

#============================   End Of File   ================================