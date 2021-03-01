# Data cleaning, wrangling and merging -----
library(tidyverse)
library(tidyxl)
library(unpivotr)


# Gemeindenportrait 2020 (date for data from different years)
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
# so adjustments had to be done to get the numbers for the 2172 municipalities which existed in 2021

# create functions for these datsets
# for data from 2020
new_data_sets_20 <- function(.file_path,  .var, .original){
  xlsx_cells(.file_path, sheet = "Worksheet") %>% 
    filter(!is_blank) %>% 
    filter(row>2) %>%
    behead("up", .var) %>% 
    behead("left", BfS_id) %>% 
    behead("left", Gemeinde) %>% 
    select(c(Gemeinde, BfS_id, .var, numeric)) %>% 
    pivot_wider(names_from = c(.var), values_from = numeric) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
    mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters")) %>%      
    rename(Anzahl = .original) %>%    
    filter(Gemeinde!="Schweiz") %>% 
    group_by(Gemeinde)
}


#only mergers of 2020
mergers_2020 <- function(.df){
    .df %>% 
    mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
    mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters"))     
}



# for data from 2019
new_data_sets_19 <- function(.file_path,  .var, .original){
  xlsx_cells(.file_path, sheet = "Worksheet") %>% 
    filter(!is_blank) %>% 
    filter(row>2) %>%
    behead("up", .var) %>% 
    behead("left", BfS_id) %>% 
    behead("left", Gemeinde) %>% 
    select(c(Gemeinde, BfS_id, .var, numeric)) %>% 
    pivot_wider(names_from = c(.var), values_from = numeric) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
    mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters")) %>%   
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



#for data from 2018
new_data_sets_18 <- function(.file_path,  .var, .original){
  xlsx_cells(.file_path, sheet = "Worksheet") %>% 
    filter(!is_blank) %>% 
    filter(row>2) %>%
    behead("up", .var) %>% 
    behead("left", BfS_id) %>% 
    behead("left", Gemeinde) %>% 
    select(c(Gemeinde, BfS_id, .var, numeric)) %>% 
    pivot_wider(names_from = c(.var), values_from = numeric)  %>% 
    mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
    mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Attelwil" = "Reitnau")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Golaten" = "Kallnach")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hinterrhein" = "Rheinwald", "Nufenen" = "Rheinwald", "Splügen" = "Rheinwald" )) %>%    
    mutate(Gemeinde = recode(Gemeinde, "Rebeuvelier" = "Courrendlin", "Vellerat" = "Courrendlin")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Hütten" = "Wädenswil", "Schönenberg (ZH)" = "Wädenswil")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Oberstammheim" = "Stammheim", "Unterstammheim" = "Rheinwald", "Waltalingen" = "Rheinwald")) %>% 
    rename(Anzahl = .original) %>% 
    filter(Gemeinde!="Schweiz") %>% 
    group_by(Gemeinde)
}


#for data from 2017
new_data_sets_17 <- function(.file_path,  .var, .original){
  xlsx_cells(.file_path, sheet = "Worksheet") %>% 
    filter(!is_blank) %>% 
    filter(row>2) %>%
    behead("up", .var) %>% 
    behead("left", BfS_id) %>% 
    behead("left", Gemeinde) %>% 
    select(c(Gemeinde, BfS_id, .var, numeric)) %>% 
    pivot_wider(names_from = c(.var), values_from = numeric)  %>% 
    mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
    mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
    mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Attelwil" = "Reitnau")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Golaten" = "Kallnach")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hinterrhein" = "Rheinwald", "Nufenen" = "Rheinwald", "Splügen" = "Rheinwald" )) %>%    
    mutate(Gemeinde = recode(Gemeinde, "Rebeuvelier" = "Courrendlin", "Vellerat" = "Courrendlin")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Hütten" = "Wädenswil", "Schönenberg (ZH)" = "Wädenswil")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Oberstammheim" = "Stammheim", "Unterstammheim" = "Rheinwald", "Waltalingen" = "Rheinwald")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Scherz" = "Lupfig")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gelterfingen" = "Kirchdorf (BE)", "Mühledorf (BE)" = "Kirchdorf (BE)", "Noflen" = "Kirchdorf (BE)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schlosswil" = "Grosshöchstetten")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mutten" = "Thusis")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bergün/Bravuogn" = "Bergün Filisur",  "Filisur" =  "Bergün Filisur")) %>%    
    mutate(Gemeinde = recode(Gemeinde, "Andiast" = "Breil/Brigels", "Waltensburg/Vuorz" = "Breil/Brigels")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Corban" = "Val Terbi")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rocourt" = "Haute-Ajoie")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bevaix" = "La Grande Béroche", "Fresens" = "La Grande Béroche", "Gorgier" = "La Grande Béroche", "Montalchez" = "La Grande Béroche", "Saint-Aubin-Sauges" = "La Grande Béroche", "Vaumarcus" = "La Grande Béroche")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hirzel" = "Horgen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hofstetten (ZH)" = "Elgg")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Camorino" = "Bellinzona", "Claro" = "Bellinzona", "Giubiasco" = "Bellinzona", "Gnosca" = "Bellinzona", "Gorduno" = "Bellinzona", "Gudo" = "Bellinzona", "Moleno" = "Bellinzona", "Monte Carasso" = "Bellinzona", "Pianezzo" = "Bellinzona", "Preonzo" = "Bellinzona", "Sant'Antonio" = "Bellinzona", "Sementina" = "Bellinzona")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cresciano" = "Riviera", "Iragna" = "Riviera", "Lodrino" = "Riviera", "Osogna" = "Riviera")) %>% 
    rename(Anzahl = .original) %>% 
    filter(Gemeinde!="Schweiz") %>% 
    group_by(Gemeinde)
}


# area in km2 -----
df_km2_0409 <- mergers_2020(df_port) %>%
  group_by(Gemeinde) %>% 
  summarise(gf_km2_0409 = sum(`Gesamtfläche in km²_2004/09`))

# for the new merged areas this is calculated with using the portion of the old municipalities in the new municipalities
# ratio of settelment area ----
df_sf_0409 <- mergers_2020(df_port) %>% 
  group_by(Gemeinde) %>% 
  mutate(ratio = `Gesamtfläche in km²_2004/09`/sum(`Gesamtfläche in km²_2004/09`)) %>% 
  summarise(ant_sf_0409 = sum(ratio*`Siedlungsfläche in %_2004/09`))

# ratio of agriculture area ----
df_lw_0409 <- mergers_2020(df_port) %>% 
  group_by(Gemeinde) %>% 
  mutate(ratio = `Gesamtfläche in km²_2004/09`/sum(`Gesamtfläche in km²_2004/09`)) %>% 
  summarise(ant_lf_0409 = sum(ratio*`Landwirtschafts-fläche in %_2004/09`))

# ratio of forest area ----
df_wg_0409 <- mergers_2020(df_port) %>% 
  group_by(Gemeinde) %>% 
  mutate(ratio = `Gesamtfläche in km²_2004/09`/sum(`Gesamtfläche in km²_2004/09`)) %>% 
  summarise(ant_wg_0409 = sum(ratio*`Wald und Gehölze in %_2004/09`))

# ratio of forest area ----
df_wg_0409 <- mergers_2020(df_port) %>% 
  group_by(Gemeinde) %>% 
  mutate(ratio = `Gesamtfläche in km²_2004/09`/sum(`Gesamtfläche in km²_2004/09`)) %>% 
  summarise(ant_wg_0409 = sum(ratio*`Wald und Gehölze in %_2004/09`))

# ratio of unproductive area ----
df_upf_0409 <- mergers_2020(df_port) %>% 
  group_by(Gemeinde) %>% 
  mutate(ratio = `Gesamtfläche in km²_2004/09`/sum(`Gesamtfläche in km²_2004/09`)) %>% 
  summarise(ant_upf_0409 = sum(ratio*`Unproduktive Fläche in %_2004/09`))


# inhabitants 2019 for the 2212 municipalities in the year 2019 ----
df_bev_19_old <- new_data_sets_19("raw-data/Staendige_Wohnbevoelkerung_2019.xlsx", stae_wb_2019,  "Anzahl Einwohner/innen am Jahresende") %>% 
  rename("Einwohner" = "Anzahl")

# inhabitants 2019 for the 2172 municipalities in the year 2021 (summed for the merged municipalities) ----
df_bev_19 <- new_data_sets_19("raw-data/Staendige_Wohnbevoelkerung_2019.xlsx", stae_wb_2019,  "Anzahl Einwohner/innen am Jahresende") %>% 
  summarise(stae_wb_2019 = sum(Anzahl))

# inhabitants 2018 for the 2172 municipalities in the year 2021 (summed for the merged municipalities) ----
df_bev_18 <- new_data_sets_18("raw-data/Staendige_Wohnbevoelkerung_2018.xlsx", stae_wb_2018,  "Anzahl Einwohner/innen am Jahresende") %>% 
  summarise(stae_wb_2018 = sum(Anzahl)) 

# changing of inhabitants from 2010 till 2019 ----
df_ent_bev_1019 <- new_data_sets_19("raw-data/entwicklung_wohnbevoelkerung_10_19.xlsx", ent_wb_2019,  "Veränderung der ständigen Wohnbevölkerung, in %") %>% 
  left_join(df_bev_19_old) %>% 
  summarise(ent_wb_2010_2019 = sum(Einwohner/sum(Einwohner)*Anzahl)) #weighting merged municipalities by their inhabitants

# amount of foreigner, will than be used to calculate foreigner ratio ----
df_aus_19 <- new_data_sets_19("raw-data/anteil_auslaend_19.xlsx", aus_2019,  "Anzahl Ausländer/innen") %>% 
  summarise(aus_2019 = sum(Anzahl))

# inhabitants of a certain age boundary ----
df_u20_19 <- new_data_sets_19("raw-data/wohnbev_unter20_19.xlsx", ein_u20_2019,  "Anzahl der Personen im Alter von 0 bis 19 Jahren") %>% 
  summarise(ein_u20_2019 = sum(Anzahl))

df_2039_19 <- new_data_sets_19("raw-data/wohnbev_20bis39_19.xlsx", ein_2039_2019,  "Anzahl der Personen im Alter von 20 bis 39 Jahren") %>% 
  summarise(ein_2039_2019 = sum(Anzahl))

df_4064_19 <- new_data_sets_19("raw-data/wohnbev_40bis64_19.xlsx", ein_4064_2019,  "Anzahl der Personen im Alter von 40 bis 64 Jahren") %>% 
  summarise(ein_4064_2019 = sum(Anzahl))

df_ab65_19 <- new_data_sets_19("raw-data/wohnbev_ab65_19.xlsx", ein_ab65_2019,  "Anzahl der Personen im Alter von 65 und mehr Jahren") %>% 
  summarise(ein_ab65_2019 = sum(Anzahl))

# marriages ----
df_hei_19 <- new_data_sets_19("raw-data/heiraten_19.xlsx", hei_2019,  "Anzahl Heiraten") %>% 
  summarise(hei_2019 = sum(Anzahl))

# divorces ----
df_scheid_19 <- new_data_sets_19("raw-data/scheidung_19.xlsx", scheid_2019,  "Anzahl Scheidungen") %>% 
  summarise(scheid_2019 = sum(Anzahl))

# births ----
df_geb_19 <- new_data_sets_19("raw-data/geburten_19.xlsx", geb_2019,  "Anzahl Lebendgeborene") %>% 
  summarise(geb_2019 = sum(Anzahl))

# deaths ----
df_tod_19 <- new_data_sets_19("raw-data/todesfaelle_19.xlsx", tod_2019,  "Anzahl Todesfälle") %>% 
  summarise(tod_2019 = sum(Anzahl))

# empty flats ----
df_lw_20 <- new_data_sets_20("raw-data/leerwohnung_20.xlsx", lw_2020,  "Anteil leer stehender Wohnungen am Gesamtwohnungsbestand, in %") %>% 
  summarise(anteil_lw_2020 = sum(Anzahl))

#social welfare ----
df_sozhi_19<- new_data_sets_19("raw-data/sozialhilfe_19.xlsx", sozhi_19,  "Unterstützte Personen") %>% 
  summarise(sozhi_2019 = sum(Anzahl))

# new build flats ---
df_ngw_18<- new_data_sets_18("raw-data/neu_erstellte_wohnungen_2018.xlsx", ngw_18,  "Im Gesamtjahr neu erstellte Wohnungen") %>% 
  summarise(ngw_18 = sum(Anzahl))

#average income per capita ----
#seems like the data is for the municipalties from 2016
df_dre_17<- new_data_sets_17("raw-data/mean_reineinkommen_17.xlsx", dre_17,  "Reineinkommen pro Einwohner/-in, in Franken") %>% 
  summarise(dre_17 = mean(Anzahl))

# average household size ----
# for merged municipalicities weighted by their amount of inhabitant bevor merging
#load data for average houshold size
df_dhhg_2019_old<- new_data_sets_19("raw-data/durch_haushaltsgroesse_19.xlsx", dhhg_19,  "Durchschnittliche Haushaltsgrösse*, in Personen")

# ratio for the merged municipalities
df_m_ratio <- df_bev_19_old %>% 
  mutate(ratio = Einwohner/sum(Einwohner))

df_dhhg_2019 <- df_dhhg_2019_old %>% 
  left_join(df_m_ratio) %>% 
  mutate(dhhg = Anzahl*ratio) %>% 
  group_by(Gemeinde) %>% 
  select(-c("BfS_id")) %>% 
  summarise(dhhg_2019 = sum(dhhg))
  



# employees ----
df_bes1_18<- new_data_sets_18("raw-data/beschaeft_1sektor_18.xlsx", bes1_18,  "Zahl der Beschäftigten im 1. Wirtschaftssektor") %>% 
  summarise(bes1_18 = sum(Anzahl))

df_bes2_18<- new_data_sets_18("raw-data/beschaeft_2sektor_18.xlsx", bes2_18,  "Zahl der Beschäftigten im 2. Wirtschaftssektor") %>% 
  summarise(bes2_18 = sum(Anzahl))

df_bes3_18<- new_data_sets_18("raw-data/beschaeft_3sektor_18.xlsx", bes3_18,  "Zahl der Beschäftigten im 3. Wirtschaftssektor") %>% 
  summarise(bes3_18 = sum(Anzahl))

# workplaces ----  there are a lot of municipalites with zero workplaces 
df_ast1_18<- new_data_sets_18("raw-data/arbeitsst_1sektor_18.xlsx", ast1_18,  "Zahl der Arbeitsstätten im 1. Wirtschaftssektor") %>% 
  summarise(ast1_18 = sum(Anzahl))

df_ast2_18<- new_data_sets_18("raw-data/arbeitsst_2sektor_18.xlsx", ast2_18,  "Zahl der Arbeitsstätten im 2. Wirtschaftssektor") %>% 
  summarise(ast2_18 = sum(Anzahl))

df_ast3_18<- new_data_sets_18("raw-data/arbeitsst_3sektor_18.xlsx", ast3_18,  "Zahl der Arbeitsstätten im 3. Wirtschaftssektor") %>% 
  summarise(ast3_18 = sum(Anzahl))

# political parties----
# not all parties are included in the orginal portrait loading them from https://www.pxweb.bfs.admin.ch/pxweb/de/px-x-1702020000_105/-/px-x-1702020000_105.px/table/tableViewLayout2/
# I weigth the votes by the total inhabitants, it is not 100 percent right but the numbers are quite similar to the one in the portrait

# 2019 municipalities id without mergers
df_name_id <- # for data where mergers are not wanted 
    df_port %>% 
      select(c(Gemeinde, BfS_id))

# ratio for the merged municipalities
df_m_ratio <- df_bev_19_old %>% 
  mutate(ratio = Einwohner/sum(Einwohner)) %>% 
  left_join(df_name_id)



df_wahlen_19 <- read.csv2("raw-data/wahlen_2019.csv") %>% 
  rename("Gemeinde"=`Bezirk........Gemeinde.........`) %>% 
  rename("Parteistärke"='Parteistärke.in..') %>% 
  mutate(Parteistärke = if_else(Parteistärke == "...", 0, as.numeric(Parteistärke))) %>% 
  filter(Gemeinde!="#NAME?") %>% 
  filter(!grepl(">>", Gemeinde)) %>% 
  mutate("Gemeinde"= substring(Gemeinde, 7)) %>% 
  left_join(df_name_id) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Obersteckholz" = "Langenthal")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Mötschwil" = "Hindelbank")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Rümligen" = "Riggisberg")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "St. Antoni" = "Tafers", "Alterswil" = "Tafers")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Arconciel" = "Bois-d’Amont", "Ependes (FR)" = "Bois-d’Amont", "Senèdes" = "Bois-d’Amont")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Cheiry" = "Surpierre")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Haldenstein" = "Chur")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Casti-Wergenstein" = "Muntogna da Schons", "Donat" = "Muntogna da Schons", "Lohn (GR)" = "Muntogna da Schons", "Mathon" = "Muntogna da Schons")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Altwis" = "Hitzkirch")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Gettnau" = "Willisau")) %>%        
  mutate(Gemeinde = recode(Gemeinde, "Corcelles-Cormondrèche" = "Neuchâtel", "Peseux" = "Neuchâtel", "Valangin" = "Neuchâtel")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Gänsbrunnen" = "Welschenrohr-Gänsbrunnen", "Welschenrohr" = "Welschenrohr-Gänsbrunnen")) %>%      
  mutate(Gemeinde = recode(Gemeinde, "Rohr (SO)" = "Stüsslingen")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Brione (Verzasca)" = "Verzasca", "Corippo" = "Verzasca", "Frasco" = "Verzasca", "Sonogno" = "Verzasca", "Vogorno" = "Verzasca")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Bauen" = "Seedorf (UR)")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Montherod" = "Aubonne")) %>%  
  mutate(Gemeinde = recode(Gemeinde, "Bagnes" = "Val de Bagnes", "Vollèges" = "Val de Bagnes")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Charrat" = "Martigny")) %>%      
  mutate(Gemeinde = recode(Gemeinde, "Miège" = "Noble-Contrée", "Venthône" = "Noble-Contrée", "Veyras" = "Noble-Contrée")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Crans-près-Céligny" = "Crans (VD)")) %>%  
  mutate(Gemeinde = recode(Gemeinde, "Les Brenets" = "Le Locle")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Klosters-Serneus" = "Klosters")) %>%  
  mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
  mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen")) %>% 
  left_join(df_m_ratio)  %>% 
  mutate(Parteinsärke_2 = ratio*Parteistärke) %>% 
  group_by(Gemeinde, Partei) %>% 
  summarise(sum = sum(Parteinsärke_2)) %>% 
  pivot_wider(names_from = c(Partei), values_from = sum) %>% 
  ungroup() %>% 
  na.omit() %>% 
  # merging parties together after this list http://www.politik-stat.ch/2015pa_de.html
  mutate(FDP = FDP + LPS) %>% 
  mutate("k_m_P" = LdU + EVP + CSP) %>% 
  mutate("k_l_P" = PdA + Sol. + PSA + POCH + FGA) %>% 
  mutate("k_r_P" = SD + EDU + FPS + Lega + MCR) %>% 
  select(-c(LPS, EVP, CSP, PdA, Sol., FGA, SD, EDU, FPS, Lega, MCR, LdU, POCH, Rep., Sep., PSA)) %>%   #these parties do not existing anymore
  mutate(
    across(c("BDP":"k_r_P"), .names = "{col}_2019")
  ) %>% 
  select(-c("BDP":"k_r_P"))
  
  
# there are some municipalities where we have no results for the elections 2019 https://www.bfs.admin.ch/bfs/de/home/statistiken/regionalstatistik/regionale-portraets-kennzahlen/gemeinden/daten-erlaeuterungen.html
df_wahlen_19$total_votes <- df_wahlen_19 %>% 
  select(c(BDP_2019:Übrige_2019)) %>% 
  rowSums()


missing_votes <- df_wahlen_19 %>% filter(total_votes == 0)

df_wahlen_19 <- df_wahlen_19 %>% 
  select(-c(total_votes))

# Meienried is recorded together with Büren an der Aare
df_wahlen_19[df_wahlen_19$Gemeinde=="Meienried", 2:12] <- df_wahlen_19%>% filter(Gemeinde=="Büren an der Aare") %>% 
  select(c(2:12))

# Hellsau is recorded together with Höchstetten BE so we use the same values
df_wahlen_19[df_wahlen_19$Gemeinde=="Hellsau", 2:12] <- df_wahlen_19%>% filter(Gemeinde=="Höchstetten") %>% 
  select(c(2:12))

# Rüti bei Lyssach is recorded together with Mötschwil, however Mötschwil merged with Hindelbank so we have to get this value
df_wahlen_moetsch <- read.csv2("raw-data/wahlen_2019.csv") %>% 
  rename("Gemeinde"=`Bezirk........Gemeinde.........`) %>% 
  rename("Parteistärke"='Parteistärke.in..') %>% 
  mutate(Parteistärke = if_else(Parteistärke == "...", 0, as.numeric(Parteistärke))) %>% 
  filter(Gemeinde!="#NAME?") %>% 
  filter(!grepl(">>", Gemeinde)) %>% 
  mutate("Gemeinde"= substring(Gemeinde, 7)) %>% 
  pivot_wider(names_from = c(Partei), values_from = Parteistärke) %>% 
  ungroup() %>% 
  na.omit() %>% 
  mutate(FDP = FDP + LPS) %>% 
  mutate("k_m_P" = LdU + EVP + CSP) %>% 
  mutate("k_l_P" = PdA + Sol. + PSA + POCH + FGA) %>% 
  mutate("k_r_P" = SD + EDU + FPS + Lega + MCR) %>% 
  select(-c(LPS, EVP, CSP, PdA, Sol., FGA, SD, EDU, FPS, Lega, MCR, LdU, POCH, Rep., Sep., PSA)) %>%   #these parties do not existing anymore
  mutate(
    across(c("BDP":"k_r_P"), .names = "{col}_2019")
  ) %>% 
  select(-c("BDP":"k_r_P")) %>% 
  filter(Gemeinde=="Mötschwil")
  

df_wahlen_19[df_wahlen_19$Gemeinde=="Rüti bei Lyssach", 2:12] <- df_wahlen_moetsch %>% 
  select(c(2:12))

# Deisswil bei Münchenbuchsee is recorded together with Wiggiswil 
df_wahlen_19[df_wahlen_19$Gemeinde=="Deisswil bei Münchenbuchsee", 2:12] <- df_wahlen_19%>% filter(Gemeinde=="Wiggiswil") %>% 
  select(c(2:12))

# Clavaleyres is recorded together with Münchenwiler so we use the same values
df_wahlen_19[df_wahlen_19$Gemeinde=="Clavaleyres", 2:12] <- df_wahlen_19%>% filter(Gemeinde=="Münchenwiler") %>% 
  select(c(2:12))

# Niedermuhlern is recorded together with Wald (BE) so we use the same values
df_wahlen_19[df_wahlen_19$Gemeinde=="Niedermuhlern", 2:12] <- df_wahlen_19%>% filter(Gemeinde=="Wald (BE)") %>% 
  select(c(2:12))

# removing the values from the portrait otherwise the join is very complicated
df_port <- df_port %>% 
  select(-c(`FDP 4)_2019`:`Kleine Rechtsparteien_2019`))


# # construction zones ----
# # data from https://www.are.admin.ch/are/de/home/raumentwicklung-und-raumplanung/grundlagen-und-daten/bauzonenstatistik-schweiz.html for 2017

# function for municipalities mergers  
zonen_17 <- function(.file_path,  .sheet){
  readxl::read_xlsx(.file_path, sheet = .sheet) %>% 
    rename("Gemeinde" = "Name") %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schinznach-Bad" = "Brugg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Kirchenthurnen" = "Thurnen", "Lohnstorf" = "Thurnen", "Mühlethurnen" = "Thurnen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Wolfisberg" = "Niederbipp")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schwendibach" = "Steffisburg")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "La Folliaz" = "Villaz", "Villaz-Saint-Pierre" = "Villaz")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Corserey" = "Prez", "Noréaz" = "Prez", "Prez-vers-Noréaz" = "Prez")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Maladers" = "Chur")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Ebersecken" = "Altishofen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Attelwil" = "Reitnau")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Golaten" = "Kallnach")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hinterrhein" = "Rheinwald", "Nufenen" = "Rheinwald", "Splügen" = "Rheinwald" )) %>%    
    mutate(Gemeinde = recode(Gemeinde, "Rebeuvelier" = "Courrendlin", "Vellerat" = "Courrendlin")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Hütten" = "Wädenswil", "Schönenberg (ZH)" = "Wädenswil")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Oberstammheim" = "Stammheim", "Unterstammheim" = "Rheinwald", "Waltalingen" = "Rheinwald")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Scherz" = "Lupfig")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Gelterfingen" = "Kirchdorf (BE)", "Mühledorf (BE)" = "Kirchdorf (BE)", "Noflen" = "Kirchdorf (BE)")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Schlosswil" = "Grosshöchstetten")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Mutten" = "Thusis")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Bergün/Bravuogn" = "Bergün Filisur",  "Filisur" =  "Bergün Filisur")) %>%    
    mutate(Gemeinde = recode(Gemeinde, "Andiast" = "Breil/Brigels", "Waltensburg/Vuorz" = "Breil/Brigels")) %>%   
    mutate(Gemeinde = recode(Gemeinde, "Corban" = "Val Terbi")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Rocourt" = "Haute-Ajoie")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Bevaix" = "La Grande Béroche", "Fresens" = "La Grande Béroche", "Gorgier" = "La Grande Béroche", "Montalchez" = "La Grande Béroche", "Saint-Aubin-Sauges" = "La Grande Béroche", "Vaumarcus" = "La Grande Béroche")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hirzel" = "Horgen")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Hofstetten (ZH)" = "Elgg")) %>%  
    mutate(Gemeinde = recode(Gemeinde, "Camorino" = "Bellinzona", "Claro" = "Bellinzona", "Giubiasco" = "Bellinzona", "Gnosca" = "Bellinzona", "Gorduno" = "Bellinzona", "Gudo" = "Bellinzona", "Moleno" = "Bellinzona", "Monte Carasso" = "Bellinzona", "Pianezzo" = "Bellinzona", "Preonzo" = "Bellinzona", "Sant'Antonio" = "Bellinzona", "Sementina" = "Bellinzona")) %>% 
    mutate(Gemeinde = recode(Gemeinde, "Cresciano" = "Riviera", "Iragna" = "Riviera", "Lodrino" = "Riviera", "Osogna" = "Riviera")) %>% 
    mutate_if(is.numeric, ~replace(., is.na(.), 0))
}



df_bz_17 <- zonen_17("raw-data/Bauzonenstatistik_17.xlsx", "Statistik Hauptnutzung") %>%
  rename(c("Wohnzonen" = "HN_11", "Arbeitszonen" = "HN_12", "Mischzonen" = "HN_13", "Zentrumszonen" = "HN_14", 
           "öff_Nutzungszonen" = "HN_15", "einge_Bauzonen" = "HN_16", "Tourismus_Freizeitzonen" = "HN_17",
           "Verkehrszone_in" = "HN_18", "weitere_Bauzonen" = "HN_19")) %>%  # replace code with name from legend in the same file 
  group_by(Gemeinde) %>% 
  summarise_at(vars("Wohnzonen":"Total"), sum) %>% 
  ungroup() %>% 
  mutate(
    across(c("Wohnzonen":"weitere_Bauzonen"), ~ . / Total*100, .names = "ant_{col}_2017")
  ) # https://stackoverflow.com/questions/48898121/mutate-multiple-variable-to-create-multiple-new-variables


# public transport conection                                                           
df_ov_17 <- zonen_17("raw-data/Bauzonenstatistik_17.xlsx", "Analyse Erschliessung ÖV") %>% 
  rename(c("ÖV_GK_A" = "A", "ÖV_GK_B" = "B", "ÖV_GK_C" = "C", "ÖV_GK_D" = "D", 
           "ÖV_GK_keine" = "keine")) %>%
  group_by(Gemeinde) %>% 
  summarise_at(vars("ÖV_GK_A":"Total"), sum) %>% 
  ungroup() %>% 
  mutate(
    across(c("ÖV_GK_A":"ÖV_GK_keine"), ~ . / Total*100, .names = "ant_{col}_2017")
  ) 




# 
# 


# Tax data from 2020 ----  at the moment to complex to compare because of the different rates for singels and families and incomes levels
# # https://swisstaxcalculator.estv.admin.ch/#/home
# 
# # using tidyxl and upivotr to read in formated excel files
# # youtube tutorial https://www.youtube.com/watch?v=1sinC7wsS5U
# # tutorial https://nacnudus.github.io/spreadsheet-munging-strategies/tidy-clean.html
# steuern_xlsx <- function(.file_path){
#   xlsx_cells(.file_path, sheet = "Export") %>% 
#   filter(!is_blank) %>% 
#   filter(row>2) %>% 
#   filter(col>2) %>% 
#   behead("NNW", Steuerart) %>%
#   behead("up", Steuerinstanz) %>% 
#   behead("left", BfS_id) %>% 
#   behead("left", Gemeinde) %>% 
#   rename("Steuersatz" = "numeric") %>% 
#   select(BfS_id, Gemeinde, Steuerart, Steuerinstanz, Steuersatz) %>% 
#   pivot_wider(names_from = c(Steuerart, Steuerinstanz), values_from = Steuersatz)
# }
# 
# # create dataframe for path (the datasets have the same name but with numbers, expect the first one which had no number)
# df_path <- data.frame(n = 1:25, path_1="raw-data/estv_income_rates(", path_2=").xlsx")
# df_path$path <-  paste0(df_path$path_1, df_path$n, df_path$path_2, sep="") 
# df_path[26,] <- c(26, "-", "-", "raw-data/estv_income_rates.xlsx")
# 
# list_steuern <- purrr::map(df_path$path, steuern_xlsx)
# 
# #function for merging elements of list (from https://www.r-bloggers.com/2016/07/merge-a-list-of-datasets-together/)
# multi_join <- function(list_of_loaded_data, join_func, ...){
#   require("dplyr")
#   output <- Reduce(function(x, y) {join_func(x, y, ...)}, list_of_loaded_data)
#   return(output)
# }
# 
# df_steu <- multi_join(list_steuern, full_join)
# 
# df_steu <-  df_steu %>% 
#   filter(!Gemeinde %in% c("Schinznach-Bad", # Schinznach Bad is now in Brugg keeping only Brugg
#                           "Kirchenthurnen", "Lohnstorf", #Kirchenthurenen, Lohnstorf and Mühlenthurnen are Thurnen
#                           "Schwendibach",
#                            "Wolfisberg")) %>%  
#   mutate(Gemeinde = recode(Gemeinde, "Mühlethurnen" = "Thurnen")) 
# # there is no data for the municipality "Prez" which is the result of a merge of the three munciipalities Prez-vers-Noréaz, Noréaz and Corserey
# # I will use the tax data from 2019 from this three muncipalities and use the average
# steuern_prez <- steuern_xlsx("raw-data/estv_income_rates_fr_19.xlsx") %>% 
#   filter(Gemeinde %in% c("Prez-vers-Noréaz", "Noréaz", "Corserey")) %>% 
#   summarise_at(vars(-Gemeinde), mean) %>% 
#   mutate(across(where(is.numeric), round, 0)) %>% 
#   mutate(Gemeinde = "Prez") %>% 
#   mutate(BfS_id = 2273) 
#   
# df_steu_all <- rbind(df_steu, steuern_prez) %>% 
#   rename_all(paste0, "_steu_2020") %>% 
#   rename("BfS_id" = "BfS_id_steu_2020") %>% 
#   mutate(BfS_id = as.character(BfS_id))


#add Kantone ----
df_kantone_20 <- xlsx_cells("raw-data/gemeinde_kantone_20.xlsx", sheet = "Worksheet") %>% 
  filter(!is_blank) %>% 
  filter(row>2) %>%
  behead("up", .var) %>% 
  behead("left", BfS_id) %>% 
  behead("left", Gemeinde) %>%  
  select(c(Gemeinde, BfS_id, character)) %>% 
  rename("Kanton" = "character") %>% 
  mutate(Kanton = str_replace(Kanton, " \\s*\\([^\\)]+\\)", ""))


# add new data to portrait ----
df_port_new <- df_bev_19 %>%
  left_join(df_km2_0409) %>%
  left_join(df_sf_0409) %>%
  left_join(df_lw_0409) %>%
  left_join(df_wg_0409) %>%
  left_join(df_upf_0409) %>%
  left_join(df_bev_18) %>% 
  left_join(df_ent_bev_1019) %>% 
  left_join(df_ngw_18) %>% 
  left_join(df_aus_19) %>% 
  left_join(df_u20_19) %>% 
  left_join(df_2039_19) %>% 
  left_join(df_4064_19) %>% 
  left_join(df_ab65_19) %>% 
  left_join(df_geb_19) %>% 
  left_join(df_hei_19)  %>% 
  left_join(df_scheid_19) %>% 
  left_join(df_tod_19)  %>%
  left_join(df_dhhg_2019)  %>%
  left_join(df_lw_20) %>% 
  left_join(df_sozhi_19) %>% 
  left_join(df_dre_17) %>% 
  left_join(df_bes1_18) %>% 
  left_join(df_bes2_18) %>% 
  left_join(df_bes3_18) %>% 
  left_join(df_ast1_18) %>% 
  left_join(df_ast2_18) %>% 
  left_join(df_ast3_18) %>% 
  left_join(df_wahlen_19) %>% 
  left_join(df_bz_17) %>% 
  left_join(df_ov_17, by="Gemeinde") %>% 
  left_join(df_kantone_20) %>% 
  mutate_if(is.numeric, ~replace(., is.na(.), 0))

# calculate some relative values ----
df_port_new <- df_port_new %>% 
  mutate(bev_dichte_2019 = stae_wb_2019/gf_km2_0409) %>% 
  mutate(ant_aus_2019 = aus_2019/stae_wb_2019*100) %>% 
  mutate(ant_u20_2019 = ein_u20_2019/stae_wb_2019*100)  %>% 
  mutate(ant_20bis39_2019 = ein_2039_2019/stae_wb_2019*100) %>% 
  mutate(ant_40bis64_2019 = ein_4064_2019/stae_wb_2019*100) %>% 
  mutate(ant_ab65_2019 = ein_ab65_2019/stae_wb_2019*100) %>% 
  mutate(prok_ngw_2018 = ngw_18/stae_wb_2018*1000) %>% 
  mutate(prok_geb_2019 = geb_2019/stae_wb_2019*1000) %>% 
  mutate(prok_hei_2019 = hei_2019/stae_wb_2019*1000) %>% 
  mutate(prok_scheid_2019 = scheid_2019/stae_wb_2019*1000) %>% 
  mutate(prok_tod_2019 = tod_2019/stae_wb_2019*1000) %>% 
  mutate(ant_sozhi_2019 = sozhi_2019/stae_wb_2019*100) %>% 
  mutate(ant_bes1_2018 = bes1_18/(bes1_18+bes2_18+bes3_18)*100) %>% 
  mutate(ant_bes2_2018 = bes2_18/(bes1_18+bes2_18+bes3_18)*100) %>% 
  mutate(ant_bes3_2018 = bes3_18/(bes1_18+bes2_18+bes3_18)*100) %>% 
  mutate(ant_ast1_2018 = ast1_18/(ast1_18+ast2_18+ast3_18)*100) %>% 
  mutate(ant_ast2_2018 = ast2_18/(ast1_18+ast2_18+ast3_18)*100) %>% 
  mutate(ant_ast3_2018 = ast3_18/(ast1_18+ast2_18+ast3_18)*100)  

#select only needed values ----
df_port_new  <- df_port_new %>% 
  mutate_if(is.numeric, ~replace(., is.na(.), 0)) %>% 
  select(c(Gemeinde, Kanton, BfS_id, stae_wb_2019, ent_wb_2010_2019, bev_dichte_2019, 
  gf_km2_0409, ant_sf_0409, ant_lf_0409, ant_wg_0409, ant_upf_0409,
  ant_Wohnzonen_2017, ant_Mischzonen_2017, ant_Zentrumszonen_2017, ant_öff_Nutzungszonen_2017, ant_einge_Bauzonen_2017, ant_Tourismus_Freizeitzonen_2017, ant_Verkehrszone_in_2017, ant_weitere_Bauzonen_2017,
  ant_ÖV_GK_A_2017, ant_ÖV_GK_B_2017, ant_ÖV_GK_C_2017, ant_ÖV_GK_D_2017, ant_ÖV_GK_keine_2017,
  anteil_lw_2020, prok_ngw_2018, dhhg_2019, 
  ant_aus_2019, ant_sozhi_2019, ant_u20_2019, ant_20bis39_2019, ant_40bis64_2019, ant_ab65_2019, prok_geb_2019, prok_hei_2019, prok_scheid_2019, prok_tod_2019,
  dre_17, ant_bes1_2018, ant_bes2_2018, ant_bes3_2018, ant_ast1_2018, ant_ast2_2018, ant_ast3_2018,
  k_l_P_2019, GPS_2019, SP_2019, k_m_P_2019, CVP_2019, BDP_2019, FDP_2019, k_r_P_2019, SVP_2019, Übrige_2019)) %>% 
  mutate_if(is.numeric, round, 2)



  




 
write.csv2(df_port_new, "processed-data/Gemeindeportrae_ch_2020_update.csv", row.names = F)


