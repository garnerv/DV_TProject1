
df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from MEDICALDATA"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gv4353', PASS='orcl_gv4353', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
df

KPI_Low_Max_value = .2     
KPI_Medium_Max_value = .4
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select Drgdefinition, Providerstate, Averagetotalpayments, Averagecoveredcharges, kpi as ratio, 
case
when kpi < "p1" then \\\'03 Low\\\'
when kpi < "p2" then \\\'02 Medium\\\'
else \\\'01 High\\\'
end kpi
from (select Drgdefinition, Providerstate, 
   sum(Averagetotalpayments) / sum(Averagecoveredcharges) as kpi
   from MEDICALDATA
   group by Providerstate)
order by Providerstate;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gv4353', PASS='orcl_gv4353', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Low_Max_value, p2=KPI_Medium_Max_value), verbose = TRUE))); View(df)

df2 <- df %>% group_by(PROVIDERSTATE) %>% summarize(sum_payments = sum(AVERAGETOTALPAYMENTS), sum_charges = sum(AVERAGECOVEREDCHARGES)) %>% mutate(ratio = sum_payments / sum_charges ) %>% mutate(kpi = ifelse(ratio <= KPI_Low_Max_value, '03 Low', ifelse(ratio <= KPI_Medium_Max_value, '02 Medium', '01 High')))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Medical Data Crosstab: By State in R) +
  labs(x=paste("DRG Medical Disorder"), y=paste("Provider State")) +
  layer(data=df2, 
        mapping=aes(x=DRGDefinition, y=ProviderState, label=SUM_PRICE), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=DRGDEFINITION, y=PROVIDERSTATE, label=SUM_CHARGES), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=2), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=DRGDEFINITION, y=PROVIDERSTATE, label=round(RATIO, 2)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=4), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=DRGDEFINITION, y=PROVIDERSTATE, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )
)
)
)
