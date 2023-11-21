library(data.table)
library(mirt)
library(mirtCAT)
# CALCULATING THE SCORES
responses <- fread(input = "EXTRA.csv", header = T)
pars <- fread(input = "param.csv", header = T)
pars <- data.frame(a1=pars$a1, d1=pars$d1, d2=pars$d2, d3=pars$d3, d4=pars$d4)
modelo <- generate.mirt_object(parameters = pars, itemtype = "graded", min_category=1)
# In the original code, respones[,-c(1,3,4,5,9,10,11,12,13,14)] was used as response.pattern
# But we already cleaned this
used_responses <- responses[, -c(1)]
escore <- fscores(object = modelo, method = "EAP", response.pattern = used_responses)
# SHOWING THE RESULTS ON CONSCOLE
escore
# SCORE_TRI = F1
SCORE_TRI <- escore[ , 1] 
mean(SCORE_TRI)
# Theta is interpreted 0.6055371
final_theta <- SCORE_TRI * 0.15 + 0.5
mean(final_theta)
