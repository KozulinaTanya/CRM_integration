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


deliv <- left_join(orders,
                   tbl(con, "NAME_OF_TABLE3") %>%
                     filter(ORDERID %in% order_numbers)%>%
                     select(CSKUNAME255, MERSUBTMNAME, ORDERID, SIZENAME, INVENTSIZEID)%>%
                     collect(), by = "ORDERID")


