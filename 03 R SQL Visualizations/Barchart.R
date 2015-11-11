
df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from MEDICALDATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gv4353', PASS='orcl_gv4353', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
df

summary(df)
head(df)

df2 <- df %>% mutate(AVG_DIFFERENCE = (AVERAGETOTALPAYMENTS - AVERAGEMEDICAREPAYMENTS)) %>% group_by(DRGDEFINITION, AVERAGETOTALPAYMENTS, AVERAGEMEDICAREPAYMENTS, AVERAGECOVEREDCHARGES) %>% summarize(AVG_DIFF = mean(AVG_DIFFERENCE)) %>% View() 

#rename(COLOR=color, CLARITY=clarity)
# df1 <- df %>% ungroup %>% group_by(CLARITY) %>% summarize(WINDOW_AVG_PRICE=mean(AVG_PRICE))
# df <- inner_join(df, df1, by="CLARITY")

