#package installation
library(DBI)
library(dplyr)
library(lubridate)

#connection
con <- dbConnect(odbc::odbc(), 
                 .connection_string = 'driver={SQL Server};server=sql3-tsum;database=tsumCRM;trusted_connection=true')

#collecting information fragment
orders <- tbl(con, "NAME_OF_TABLE") %>% 
  select(ORDERDATETIME, MODIFIEDDATETIME, DELIVERYAMOUNT, AGENTCODE, AMOUNTGROSS, AMOUNTNET, ORDERID, COMMENTCALLCENTER, ORDERSTATUS, DISCCARDHOLDERID, PHONE, DISCCARDTYPEID, CITY, CUSTFIRSTNAME, CUSTLASTNAME, EMAIL, ORDERSOURCE, ORDERSTATUS, COMMENTCALLCENTER, FIRSTTIMEORDER, EMAIL, PAYMENTTYPEID)%>%
  filter(ORDERDATETIME >= "2016-09-22" & ORDERDATETIME <= "2019-11-25", EMAIL =="EMAIL@EMAIL.COM") %>%
  collect()

holder <- tbl(con, "NAME_OF_TABLE2") %>% 
  filter(EMAIL=="EMAIL@EMAIL.COM")%>% 
  collect()

#ltv_by_email
ltv <- left_join(EMAILS,
                   tbl(con, "NAME_OF_TABLE") %>% 
                     select(ORDERDATETIME, AMOUNTNET, EMAIL, CITY)%>%
                     filter(ORDERDATETIME >= "2016-09-22" & ORDERDATETIME <= "2019-11-25") %>%
                     group_by(EMAIL, CITY) %>%
                     summarise(SUM = sum(AMOUNTNET)) %>%
                     collect(), by = "EMAIL")

#function grade byltv
grade_by_ltv <- function(x){
  for (i in x){
if (i<= 57000) {print("small")} else if (i >= 57000 & i <=23000) {print("central")} else {print("big")}
  }
}

#connect emails with grade
ltv %>% 
  mutate(new = grade(SUM))


