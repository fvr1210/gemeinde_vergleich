# Data cleaning, wrangling and merging -----
library(tidyverse)
library(tidyxl)
library(unpivotr)


# Gemeindenportrai 2020 (date for data from different years)
# data from https://www.bfs.admin.ch/bfs/de/home/statistiken/regionalstatistik/regionale-portraets-kennzahlen/gemeinden/daten-erlaeuterungen.assetdetail.11587763.html
# df_port <- read_delim("raw-data/Gemeindeporträis_CH_2020.csv", delim = ";", locale = locale(encoding = 'ISO-8859-1')) %>% 
#   rename("Gemeinde"="Gemeindename")

df_port <- xlsx_cells("raw-data/Gemeindeportrae_ch_2020.xlsx", sheet = "T21.3.1") %>% 
  filter(!is_blank) %>% 
  filter(row>5) %>%
  behead("NNW", col_name) %>% 
  behead("N", col_name_2) %>% 
  behead("left", BfS_id) %>% 
  behead("left", Gemeinde) %>% 
  select(BfS_id, Gemeinde, numeric, col_name, col_name_2) %>% 
  na.omit() %>% 
  filter(!col_name %in% c("Beschäftigte total", "im 1. Sektor", "im 2. Sektor", "im 3. Sektor", "Arbeitsstätten total", "Veränderung in ha")) %>%  #this col names are used twice for different values 
  pivot_wider(names_from = c(col_name, col_name_2), values_from = numeric) 

# creat data set for economic value with same col names 
df_port_eco <- xlsx_cells("raw-data/Gemeindeportrae_ch_2020.xlsx", sheet = "T21.3.1") %>% 
  filter(!is_blank) %>% 
  filter(row>5) %>%
  behead("NNW", col_name) %>% 
  behead("N", col_name_2) %>% 
  behead("left", BfS_id) %>% 
  behead("left", Gemeinde) %>% 
  select(BfS_id, Gemeinde, numeric, col_name, col_name_2) %>% 
  filter(col_name %in% c("Beschäftigte total", "im 1. Sektor", "im 2. Sektor", "im 3. Sektor", "Arbeitsstätten total"))

# creat df for people working in a specific sector
df_port_besch <- df_port_eco %>% 
  group_by(Gemeinde) %>% slice(2:4) %>% 
  filter(!is.na(Gemeinde)) %>% 
  #some municipalty have NAs for certain sectors, thei are replaced with 0
  mutate(numeric = if_else(is.na(numeric), 0, numeric)) %>% 
  mutate(per_besch = round(numeric/sum(numeric)*100, 1)) %>% 
  ungroup() %>% 
  select(c(Gemeinde, BfS_id, per_besch, col_name, col_name_2)) %>% 
  pivot_wider(names_from = c(col_name, col_name_2), values_from = per_besch) %>% 
  rename(c("besch_per_1_2017p" = "im 1. Sektor_2017p", "besch_per_2_2017p" = "im 2. Sektor_2017p", "besch_per_3_2017p" = "im 3. Sektor_2017p"))


# creat df for workplaces in a specific sector
df_port_bet <- df_port_eco %>% 
  group_by(Gemeinde) %>% slice(6:8) %>% 
  filter(!is.na(Gemeinde)) %>% 
  #some municipalty have NAs for certain sectors, thei are replaced with 0
  mutate(numeric = if_else(is.na(numeric), 0, numeric)) %>% 
  mutate(per_bet = round(numeric/sum(numeric)*100, 1)) %>% 
  ungroup() %>% 
  select(c(Gemeinde, per_bet, col_name)) %>% 
  pivot_wider(names_from = col_name, values_from = per_bet) %>% 
  rename(c("bet_per_1_2017p" = "im 1. Sektor_2017p", "bet_per_2_2017p" = "im 2. Sektor_2017p", "bet_per_3_2017p" = "im 3. Sektor_2017p"))
 

# add the two datasets to the portrait dataset
df_port_2 <- df_port %>% 
  left_join(df_port_besch) %>% 
  left_join(df_port_bet) %>% 
  mutate(across(where(is.numeric), round, 1))





# Tax data from 2020 ----
# https://swisstaxcalculator.estv.admin.ch/#/home

# using tidyxl and upivotr to read in formated excel files
# youtube tutorial https://www.youtube.com/watch?v=1sinC7wsS5U
# tutorial https://nacnudus.github.io/spreadsheet-munging-strategies/tidy-clean.html
steuern_xlsx <- function(.file_path){
  xlsx_cells(.file_path, sheet = "Export") %>% 
  filter(!is_blank) %>% 
  filter(row>2) %>% 
  filter(col>2) %>% 
  behead("NNW", Steuerart) %>%
  behead("up", Steuerinstanz) %>% 
  behead("left", BfS_id) %>% 
  behead("left", Gemeinde) %>% 
  rename("Steuersatz" = "numeric") %>% 
  select(BfS_id, Gemeinde, Steuerart, Steuerinstanz, Steuersatz) %>% 
  pivot_wider(names_from = c(Steuerart, Steuerinstanz), values_from = Steuersatz)
}

# create dataframe for path (the datasets have the same name but with numbers, expect the first one which had no number)
df_path <- data.frame(n = 1:25, path_1="raw-data/estv_income_rates(", path_2=").xlsx")
df_path$path <-  paste0(df_path$path_1, df_path$n, df_path$path_2, sep="") 
df_path[26,] <- c(26, "-", "-", "raw-data/estv_income_rates.xlsx")

list_steuern <- purrr::map(df_path$path, steuern_xlsx)

#function for merging elements of list (from https://www.r-bloggers.com/2016/07/merge-a-list-of-datasets-together/)
multi_join <- function(list_of_loaded_data, join_func, ...){
  require("dplyr")
  output <- Reduce(function(x, y) {join_func(x, y, ...)}, list_of_loaded_data)
  return(output)
}

df_steu <- multi_join(list_steuern, full_join)

df_steu <-  df_steu %>% 
  filter(!Gemeinde %in% c("Schinznach-Bad", # Schinznach Bad is now in Brugg keeping only Brugg
                          "Kirchenthurnen", "Lohnstorf", #Kirchenthurenen, Lohnstorf and Mühlenthurnen are Thurnen
                          "Schwendibach",
                           "Wolfisberg")) %>%  
  mutate(Gemeinde = recode(Gemeinde, "Mühlethurnen" = "Thurnen")) 
# there is no data for the municipality "Prez" which is the result of a merge of the three munciipalities Prez-vers-Noréaz, Noréaz and Corserey
# I will use the tax data from 2019 from this three muncipalities and use the average
steuern_prez <- steuern_xlsx("raw-data/estv_income_rates_fr_19.xlsx") %>% 
  filter(Gemeinde %in% c("Prez-vers-Noréaz", "Noréaz", "Corserey")) %>% 
  summarise_at(vars(-Gemeinde), mean) %>% 
  mutate(across(where(is.numeric), round, 0)) %>% 
  mutate(Gemeinde = "Prez") %>% 
  mutate(BfS_id = 2273)
  
df_steu <- rbind(df_steu, steuern_prez)  

# save
write.csv(df_steu, "processed-data/steuersaetze_2020_ch_gemeinden.csv")

# marriage data from 2019 -----
# data from https://www.pxweb.bfs.admin.ch/pxweb/de/px-x-0102020202_102/-/px-x-0102020202_102.px/

# wrangling 
df_heirat <- read_delim("raw-data/heiraten_ch_gemeinden_2019.csv", delim = ";", locale = locale(encoding = 'ISO-8859-2'))%>% 
  dplyr::select(-c(`Staatsangehörigkeit (Kategorie) des Ehemannes`)) %>% 
  rename("Gemeinde"='Kanton (-) / Bezirk (>>) / Gemeinde (......)') %>% 
  rename("Ehen"=`Staatsangehörigkeit der Ehefrau - Total`) %>% 
  filter(Gemeinde!="#NAME?") %>% 
  filter(!grepl(">>", Gemeinde)) %>% 
  mutate("Gemeinde"= substring(Gemeinde, 12) )

# there were some municipality mergers from 2019 to 2020, I will add the values together 
df_heirat <- df_heirat %>% 
  filter(Gemeinde != "") %>% 
  mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen"))
  
df_heirat <- df_heirat %>% 
  group_by(Gemeinde, Jahr) %>% 
  summarise(sum(Ehen))




