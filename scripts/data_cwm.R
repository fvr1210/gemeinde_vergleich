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

# creat data set for economic value with same col names - this is not needed because new data is loaded however I keep it for the case that the portrait is updatet
# df_port_eco <- xlsx_cells("raw-data/Gemeindeportrae_ch_2020.xlsx", sheet = "T21.3.1") %>% 
#   filter(!is_blank) %>% 
#   filter(row>5) %>%
#   behead("NNW", col_name) %>% 
#   behead("N", col_name_2) %>% 
#   behead("left", BfS_id) %>% 
#   behead("left", Gemeinde) %>% 
#   select(BfS_id, Gemeinde, numeric, col_name, col_name_2) %>% 
#   filter(col_name %in% c("Beschäftigte total", "im 1. Sektor", "im 2. Sektor", "im 3. Sektor", "Arbeitsstätten total"))

# creat df for people working in a specific sector 
# df_port_besch <- df_port_eco %>% 
#   group_by(Gemeinde) %>% slice(2:4) %>% 
#   filter(!is.na(Gemeinde)) %>% 
#   #some municipalty have NAs for certain sectors, thei are replaced with 0
#   mutate(numeric = if_else(is.na(numeric), 0, numeric)) %>% 
#   mutate(per_besch = round(numeric/sum(numeric)*100, 1)) %>% 
#   ungroup() %>% 
#   select(c(Gemeinde, BfS_id, per_besch, col_name, col_name_2)) %>% 
#   pivot_wider(names_from = c(col_name, col_name_2), values_from = per_besch) %>% 
#   rename(c("besch_per_1_2017p" = "im 1. Sektor_2017p", "besch_per_2_2017p" = "im 2. Sektor_2017p", "besch_per_3_2017p" = "im 3. Sektor_2017p"))
# 
# 
# # creat df for workplaces in a specific sector
# df_port_bet <- df_port_eco %>% 
#   group_by(Gemeinde) %>% slice(6:8) %>% 
#   filter(!is.na(Gemeinde)) %>% 
#   #some municipalty have NAs for certain sectors, thei are replaced with 0
#   mutate(numeric = if_else(is.na(numeric), 0, numeric)) %>% 
#   mutate(per_bet = round(numeric/sum(numeric)*100, 1)) %>% 
#   ungroup() %>% 
#   select(c(Gemeinde, per_bet, col_name, col_name_2)) %>% 
#   pivot_wider(names_from = c(col_name, col_name_2), values_from = per_bet) %>% 
#   rename(c("bet_per_1_2017p" = "im 1. Sektor_2017p", "bet_per_2_2017p" = "im 2. Sektor_2017p", "bet_per_3_2017p" = "im 3. Sektor_2017p"))
#  
# 
# # add the two datasets to the portrait dataset
# df_port_2 <- df_port %>% 
#   left_join(df_port_besch) %>% 
#   left_join(df_port_bet) %>% 
#   mutate(across(where(is.numeric), round, 1))


# I noticed that most data is from 2018 and there is already a lot of data for 2019 available on https://www.atlas.bfs.admin.ch/maps/13/de/15846_14372_14368_3114/24793.html
# I will use this newer data and replace the older when available. The problem is that the data for 2019 has 2212 municipalities (as switzerland had in 2019)
# so adjustments had to be done to get the numbers for the 2202 municipalities which existed in 2020

# create functions for these datsets
new_data_sets <- function(.file_path,  .var, .original){
  xlsx_cells(.file_path, sheet = "Worksheet") %>% 
    filter(!is_blank) %>% 
    filter(row>2) %>%
    behead("up", .var) %>% 
    behead("left", BfS_id) %>% 
    behead("left", Gemeinde) %>% 
    select(c(Gemeinde, BfS_id, .var, numeric)) %>% 
    pivot_wider(names_from = c(.var), values_from = numeric) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen")) %>% 
    rename(Anzahl = .original) %>% 
    filter(Gemeinde!="Schweiz") %>% 
    group_by(Gemeinde)
}

# inhabitants 2019 for the 2212 municipalities in the year 2019
df_bev_v19 <- new_data_sets("raw-data/Staendige_Wohnbevoelkerung_2019.xlsx", stae_wb_2019,  "Anzahl Einwohner/innen am Jahresende") %>% 
  rename("Einwohner" = "Anzahl")

# inhabitants 2019 for the 2202 municipalities in the year 2020 (summed for the merged municipalities)
df_bev <- new_data_sets("raw-data/Staendige_Wohnbevoelkerung_2019.xlsx", stae_wb_2019,  "Anzahl Einwohner/innen am Jahresende") %>% 
  summarise(stae_wb_2019 = sum(Anzahl)) 

# changing of inhabitants from 2010 till 2019
df_ent_bev <- new_data_sets("raw-data/entwicklung_wohnbevoelkerung_10_19.xlsx", ent_wb_2019,  "Veränderung der ständigen Wohnbevölkerung, in %") %>% 
  left_join(df_bev_v19) %>% 
  summarise(ent_wb_p_2019 = sum(Einwohner/sum(Einwohner)*Anzahl)) #weighting merged municipalities by their inhabitants

# amount of foreigner, will than be used to calculate foreigner ratio
df_aus <- new_data_sets("raw-data/anteil_auslaend_19.xlsx", aus_2019,  "Anzahl Ausländer/innen") %>% 
  summarise(aus_2019 = sum(Anzahl))

# inhabitants of a certain age boundary 
df_u20 <- new_data_sets("raw-data/wohnbev_unter20_19.xlsx", ein_u20_2019,  "Anzahl der Personen im Alter von 0 bis 19 Jahren") %>% 
  summarise(ein = sum(Anzahl))

df_2039 <- new_data_sets("raw-data/wohnbev_20bis39_19.xlsx", ein_2039_2019,  "Anzahl der Personen im Alter von 20 bis 39 Jahren") %>% 
  summarise(ein_2039_2019 = sum(Anzahl))

df_4064 <- new_data_sets("raw-data/wohnbev_40bis64_19.xlsx", ein_4064_2019,  "Anzahl der Personen im Alter von 40 bis 64 Jahren") %>% 
  summarise(ein_4064_2019 = sum(Anzahl))

df_ab65 <- new_data_sets("raw-data/wohnbev_ab65_19.xlsx", ein_ab65_2019,  "Anzahl der Personen im Alter von 65 und mehr Jahren") %>% 
  summarise(ein_ab65_2019 = sum(Anzahl))

# marriages
df_hei <- new_data_sets("raw-data/heiraten_19.xlsx", hei_2019,  "Anzahl Heiraten") %>% 
  summarise(hei_2019 = sum(Anzahl))

# births
df_geb <- new_data_sets("raw-data/geburten_19.xlsx", geb_2019,  "Anzahl Lebendgeborene") %>% 
  summarise(geb_2019 = sum(Anzahl))

# deaths
df_tod <- new_data_sets("raw-data/todesfaelle_19.xlsx", tod_2019,  "Anzahl Todesfälle") %>% 
  summarise(tod_2019 = sum(Anzahl))

# empty flats
df_lw <- new_data_sets("raw-data/leerwohnung_20.xlsx", lw_2020,  "Anteil leer stehender Wohnungen am Gesamtwohnungsbestand, in %") %>% 
  summarise(anteil_lw_2020 = sum(Anzahl))

#social welfare
df_sozhi_19<- new_data_sets("raw-data/sozialhilfe_19.xlsx", sozhi_19,  "Unterstützte Personen") %>% 
  summarise(sozhi_2020 = sum(Anzahl))

#average income per capita
df_avin_17<- new_data_sets("raw-data/mean_reineinkommen_17.xlsx", avin_17,  "Reineinkommen pro Einwohner/-in, in Franken") %>% 
  summarise(avin_17 = sum(Anzahl))


# employees
df_em1_18<- new_data_sets("raw-data/beschaeft_1sektor_18.xlsx", em1_18,  "Zahl der Beschäftigten im 1. Wirtschaftssektor") %>% 
  summarise(em1_18 = sum(Anzahl))

df_em2_18<- new_data_sets("raw-data/beschaeft_2sektor_18.xlsx", em2_18,  "Zahl der Beschäftigten im 2. Wirtschaftssektor") %>% 
  summarise(em2_18 = sum(Anzahl))

df_em3_18<- new_data_sets("raw-data/beschaeft_3sektor_18.xlsx", em3_18,  "Zahl der Beschäftigten im 3. Wirtschaftssektor") %>% 
  summarise(em3_18 = sum(Anzahl))

# workplaces
df_wp1_18<- new_data_sets("raw-data/arbeitsst_1sektor_18.xlsx", wp1_18,  "Zahl der Arbeitsstätten im 1. Wirtschaftssektor") %>% 
  summarise(wp1_18 = sum(Anzahl))

df_wp2_18<- new_data_sets("raw-data/arbeitsst_2sektor_18.xlsx", wp2_18,  "Zahl der Arbeitsstätten im 2. Wirtschaftssektor") %>% 
  summarise(wp2_18 = sum(Anzahl))

df_wp3_18<- new_data_sets("raw-data/arbeitsst_3sektor_18.xlsx", wp3_18,  "Zahl der Arbeitsstätten im 3. Wirtschaftssektor") %>% 
  summarise(wp3_18 = sum(Anzahl))





#add df_bev to df_port and remove Einwohner 2018
df_port_3 <- df_port_2 %>% 
  left_join(df_bev) %>% 
  select(-c(Einwohner_2018))

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
  
df_steu_all <- rbind(df_steu, steuern_prez) %>% 
  rename_all(paste0, "_2020") %>% 
  rename("BfS_id" = "BfS_id_2020") %>% 
  mutate(BfS_id = as.character(BfS_id))

# save
write.csv(df_steu_all, "processed-data/steuersaetze_2020_ch_gemeinden.csv")


#add tax data to portrait df
df_port_3 <- df_port_2 %>% left_join(df_steu_all) 
  





