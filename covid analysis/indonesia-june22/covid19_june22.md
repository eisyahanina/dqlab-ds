# COVID-19 Data Analysis in Indonesia (June 2022)
Author: Eisya Hanina Hidayati  
Published on: 15-11-2022  
Course: Data Science for Beginner  
Organizer: DQLab

## Overview
In this project, we will execute data exploration and analysis of COVID-19 in Indonesia. Data will be directly obtained from API (Application Programming Interface) that has been provided in covid19.go.id. Skills used in this project are extracting data from API, preparing data, and analyzing data.

## Preparation
First thing first, we need an API access to get the COVID-19 data recap publicly provided by the Indonesian government in DQLab database by using `httr` package.
```{r httr}
library(httr)
```

After activating the package, we need to run the `GET()` function using the API and store it to an object called `resp`.  
```{r config}
set_config(config(ssl_verifypeer = 0L))
resp <- GET("https://storage.googleapis.com/dqlab-dataset/update.json")
```

Then we need to run `status_code()` function to evaluate the response from the server.
```{r resp}
status_code(resp)
```
```
## [1] 200
``` 
Status code `[1] 200` means our request is granted.  

To know what kind of metadata contained in API, we can use the function `headers()` as seen below.
```{r headers}
headers(resp)
```
```
## $`x-guploader-uploadid`
## [1] "ADPycdsEXks4gHfHgd1TcPd-Dg1s6-1HFlA8LoRXwNtTGNcQuRdyx7pgrZ1yVFdKB0fDGW5XExdlS_GptGb6Ixs-dW_FQFwmsmRa"
## 
## $`x-goog-generation`
## [1] "1654513959565478"
## 
## $`x-goog-metageneration`
## [1] "1"
## 
## $`x-goog-stored-content-encoding`
## [1] "identity"
## 
## $`x-goog-stored-content-length`
## [1] "311897"
## 
## $`x-goog-hash`
## [1] "crc32c=GMMqEA=="
## 
## $`x-goog-hash`
## [1] "md5=8aR/820+lfYyWNlv5bLUOQ=="
## 
## $`x-goog-storage-class`
## [1] "STANDARD"
## 
## $`accept-ranges`
## [1] "bytes"
## 
## $`content-length`
## [1] "311897"
## 
## $server
## [1] "UploadServer"
## 
## $date
## [1] "Mon, 14 Nov 2022 17:02:25 GMT"
## 
## $expires
## [1] "Mon, 14 Nov 2022 18:02:25 GMT"
## 
## $`cache-control`
## [1] "public, max-age=3600"
## 
## $age
## [1] "1794"
## 
## $`last-modified`
## [1] "Mon, 06 Jun 2022 11:12:39 GMT"
## 
## $etag
## [1] "\"f1a47ff36d3e95f63258d96fe5b2d439\""
## 
## $`content-type`
## [1] "application/json"
## 
## $`alt-svc`
## [1] "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
## 
## attr(,"class")
## [1] "insensitive" "list"
```
From this function, we know that the type of content is JSON form `content-type` and it was last modified on June 2022 from `last-modified`.


## Extraction
We use `content()` function to extract the data from JSON file and store it as `cov_id_raw`.
```{r covid_id_raw}
cov_id_raw <- content(resp, as = "parsed", simplifyVector = TRUE)
```

To know how many components exist and what the components are in our data, we can use `length()`and `names()` as seen below.
```{r length}
length(cov_id_raw)
```
```
## [1] 2
```
```{r names}
names(cov_id_raw)
```
```
## [1] "data"   "update"
```
Since we need the update of COVID-19 data, we will need to extract `update` and store it in a new data called `cov_id_update`.  
```{r cov_id_update}
cov_id_update <- cov_id_raw$update
```


## Analysis
In this analysis, we will try to answer some questions:
1. When is the latest update for the COVID-19 case data?
2. How many COVID-19 recovery cases from the latest update?
3. How many COVID-19 death cases from the latest update?
4. How many COVID-19 positive cases in total as of the latest update?
5. How many COVID-19 death cases in total as of the latest update?


To apply a function over a list or vector, we will use `lapply` as seen below.
```{r lapply}
lapply(cov_id_update, names)
```
```
## $penambahan
## [1] "jumlah_positif"   "jumlah_meninggal" "jumlah_sembuh"    "jumlah_dirawat"  
## [5] "tanggal"          "created"         
## 
## $harian
##  [1] "key_as_string"        "key"                  "doc_count"           
##  [4] "jumlah_meninggal"     "jumlah_sembuh"        "jumlah_positif"      
##  [7] "jumlah_dirawat"       "jumlah_positif_kum"   "jumlah_sembuh_kum"   
## [10] "jumlah_meninggal_kum" "jumlah_dirawat_kum"  
## 
## $total
## [1] "jumlah_positif"   "jumlah_dirawat"   "jumlah_sembuh"    "jumlah_meninggal"
```
`lapply` returns a list of the same length as `cov_id_update` where each element is the result of applying `names` to the the corresponding data. After that, we can proceed to the next step using those names to conduct our analysis.



#### When is the latest update for the COVID-19 case data?
```{r update}
cov_id_update$penambahan$tanggal
```
```
## [1] "2022-05-14"
```
According to the data, the latest update for the COVID-19 cases is May 14th, 2022.


#### How many COVID-19 recovery cases from the latest update?
```{r negative}
cov_id_update$penambahan$jumlah_sembuh
```
```
## [1] 416
```
According to the data, the amount of COVID-19 recovery cases from the latest update is 416 cases.


#### How many COVID-19 death cases from the latest update?

```{r death}
cov_id_update$penambahan$jumlah_meninggal
```
```
## [1] 5
```
According to the data, the amount of COVID-19 death cases from the latest update is 5 cases.


#### How many COVID-19 positive cases in total as of the latest update?
```{r total_positive}
cov_id_update$total$jumlah_positif
```
```
## [1] 6050519
```
According to the data, the total amount of COVID-19 positive cases up until the latest update is 6.050.519 cases.


#### How many COVID-19 death cases in total as of the latest update?

```{r total_death}
cov_id_update$total$jumlah_meninggal
```
```
## [1] 156453
```
According to the data, the total amount of COVID-19 death cases up until the latest update is 156.453 cases.


****
*Special thanks to DQLab for organizing this!*
