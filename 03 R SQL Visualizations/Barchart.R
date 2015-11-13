
df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from MEDICALDATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gv4353', PASS='orcl_gv4353', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
#df

#summary(df)
#head(df)

df2 <- df %>% mutate(AVG_DIFFERENCE = (AVERAGETOTALPAYMENTS - AVERAGEMEDICAREPAYMENTS), AVG_DIFF = mean(AVG_DIFFERENCE)) %>% group_by(DRGDEFINITION, AVERAGETOTALPAYMENTS, AVERAGEMEDICAREPAYMENTS, AVG_DIFFERENCE) %>% summarize(AVG_DIFFER = mean(AVG_DIFFERENCE)) 

df3 <- df2 %>% ungroup %>% group_by(DRGDEFINITION) %>% summarise(AVG_DIFF = mean(AVG_DIFFER))

df4 <- inner_join(df2, df3, by="DRGDEFINITION")

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_wrap(~DRGDEFINITION, ncol=1) +
  labs(title='Medical Data \n Procedure Cost Comparison ') +
  labs(x=paste("Measure Names"), y=paste("AVG_PRICE")) +
  layer(data=df4, 
        mapping=aes(x=AVERAGETOTALPAYMENTS, y=AVG_DIFFERENCE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) + 
  layer(data=df4, 
        mapping=aes(x=AVERAGEMEDICAREPAYMENTS, y=AVG_DIFFERENCE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) +
  layer(data=df4, 
        mapping=aes(x=AVG_DIFF, y=AVG_DIFFERENCE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  )
