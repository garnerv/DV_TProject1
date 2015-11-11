
df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from MEDICALDATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gv4353', PASS='orcl_gv4353', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
df

summary(df)
head(df)

df %>% mutate(AVG_DIFFERENCE = cume_dist(mean(AVERAGETOTALPAYMENTS - AVERAGEMEDICAREPAYMENTS))) %>% ggplot(aes(x = AVG_DIFFERENCE, y = TOTALDISCHARGES)) + labs(title="Medical Data \n Percentiles vs Total Discharges" + labs(x="Percentile of Average Differences", y=paste("Total Discharges")))
