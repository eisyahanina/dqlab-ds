# preparation

library(httr)

set_config(config(ssl_verifypeer = 0L))
resp <- 
  GET("https://storage.googleapis.com/dqlab-dataset/update.json")

status_code(resp)

headers(resp)

# extraction

cov_id_raw <- 
  content(resp, as = "parsed", simplifyVector = TRUE)

length(cov_id_raw)
names(cov_id_raw)

cov_id_update <- cov_id_raw$update

# analysis

lapply(cov_id_update, names)

## When is the latest update for the COVID-19 case data?
cov_id_update$penambahan$tanggal

## How many COVID-19 recovery cases from the latest update?
cov_id_update$penambahan$jumlah_sembuh

## How many COVID-19 death cases from the latest update?
cov_id_update$penambahan$jumlah_meninggal

## How many COVID-19 positive cases in total as of the latest update?
cov_id_update$total$jumlah_positif

## How many COVID-19 death cases in total as of the latest update?
cov_id_update$total$jumlah_meninggal
 