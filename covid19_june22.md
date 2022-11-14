---
title: "COVID-19 Data Analysis in Indonesia (June 2022)"
author: "eisyahanina"
date: "`r Sys.Date()`"
output:
  pdf_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Preparation
____
First thing first, we need an API access to get the COVID-19 data recap publicly provided by the Indonesian government in DQLab database by using `httr` package.
```{r httr}
library(httr)
```
\
After activating the package, we need to run the `GET()` function using the API and store it to an object called `resp`.  
```{r config}
set_config(config(ssl_verifypeer = 0L))
resp <- GET("https://storage.googleapis.com/dqlab-dataset/update.json")
```
\
Then we need to run `status_code()` function to evaluate the response from the server.
```{r resp}
status_code(resp)
```
Status code `[1] 200` means our request is granted.  
\
To know what kind of metadata contained in API, we can use the function `headers()` as seen below.
```{r headers}
headers(resp)
```
From this function, we know that the type of content is JSON form `content-type` and it was last modified on June 2022 from `last-modified`.
\

## Extraction
____
We use `content()` function to extract the data from JSON file and store it as `cov_id_raw`.
```{r covid_id_raw}
cov_id_raw <- content(resp, as = "parsed", simplifyVector = TRUE)
```

To know how many components exist and what the components are in our data, we can use `length()`and `names()` as seen below.
```{r components}
length(cov_id_raw)
names(cov_id_raw)
```
Since we need the update of COVID-19 data, we will need to extract `update` and store it in a new data called `cov_id_update`.  
```{r cov_id_update}
cov_id_update <- cov_id_raw$update
```


## Data Analysis
____
In this analysis, we will try to answer some questions:\
1. When is the latest update for the COVID-19 case data?\
2. How many COVID-19 recovery cases from the latest update?\
3. How many COVID-19 death cases from the latest update?\
4. How many COVID-19 positive cases in total as of the latest update?\
5. How many COVID-19 death cases in total as of the latest update?\
\

To apply a function over a list or vector, we will use `lapply` as seen below.
```{r lapply}
lapply(cov_id_update, names)
```
`lapply` returns a list of the same length as `cov_id_update` where each element is the result of applying `names` to the the corresponding data. After that, we can proceed to the next step using those names to conduct our analysis.
\


#### When is the latest update for the COVID-19 case data?
```{r update}
cov_id_update$penambahan$tanggal
```
According to the data, the latest update for the COVID-19 cases is May 14th, 2022.
\

####	How many COVID-19 recovery cases from the latest update?
```{r negative}
cov_id_update$penambahan$jumlah_sembuh
```
According to the data, the amount of COVID-19 recovery cases from the latest update is 416 cases.
\

####	How many COVID-19 death cases from the latest update?

```{r death}
cov_id_update$penambahan$jumlah_meninggal
```
According to the data, the amount of COVID-19 death cases from the latest update is 5 cases.
\

####	How many COVID-19 positive cases in total as of the latest update?
```{r total_positive}
cov_id_update$total$jumlah_positif
```
According to the data, the total amount of COVID-19 positive cases up until the latest update is 6.050.519 cases.
\

####	How many COVID-19 death cases in total as of the latest update?

```{r total_death}
cov_id_update$total$jumlah_meninggal
```  
According to the data, the total amount of COVID-19 death cases up until the latest update is 156.453 cases.
\

****
*Special thanks to DQLab for organizing this!*