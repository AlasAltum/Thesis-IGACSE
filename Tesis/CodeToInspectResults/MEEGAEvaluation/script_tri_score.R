library(data.table)
library(mirt)
library(mirtCAT)
# CALCULATING THE SCORES
responses <- fread(input = "EXTRA.csv", header = T)
pars <- fread(input = "param.csv", header = T)
pars<- data.frame(a1=pars$a1,d1=pars$d1,d2=pars$d2,d3=pars$d3,d4=pars$d4)
modelo<-generate.mirt_object(parameters = pars, itemtype = "graded",min_category=1)
escore<-fscores(object = modelo,method = "EAP",response.pattern = responses[,-c(1,3,4,5,9,10,11,12,13,14)])

#SHOWING THE RESULTS ON CONSCOLE
escore
#SCORE_TRI = F1