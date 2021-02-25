library(shiny)
library(DT)
library(tidyverse)
library(shinydashboard)


# # loading own functions for repeating graphs, using eval to use encoding https://stackoverflow.com/questions/5031630/how-to-source-r-file-saved-using-utf-8-encoding
# eval(parse("scripts/graph_functions.R", encoding="UTF-8"))


# read in data ----


#* Data for municipalities ----
df_gv <- read_csv2("processed-data/Gemeindeportrae_ch_2020_update.csv", locale = locale(encoding = "ISO-8859-2")) 

#** description  text -----
description_text <-  read_file("processed-data/total_text.html", locale = locale(encoding = 'utf-8')) # text description for tab with all school levels
# 
# kp_text <-  read_file("processed-data/kinder_primar_text.html", locale = locale(encoding = 'utf-8')) # text description for tab with all school levels
# 
# sek_text <-  read_file("processed-data/sek_text.html", locale = locale(encoding = 'utf-8')) # text description for tab with all school levels
# 



#* Info text
# 
info_text <-  read_file("processed-data/info_text.html", locale = locale(encoding = 'utf-8')) # text description for tab with all school levels
# 






# Ui side -----
ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "Gemeindevergleich", titleWidth = 320 # extend width because of the longer title
                    ),
                    
                    # sidebare ---------
                    dashboardSidebar( 
                        width = 320,
                        sidebarMenu(
                            menuItem("Info", tabName = "info_text", icon = icon("info")),
                            menuItem("Gemeinde Vergleich", tabName = "vergleich", icon = icon("school")),    
                            menuItem("Daten", tabName = "daten", icon = icon("data"))),
                        
                        tagList(                       # Aligne the checkboxes left; code from https://stackoverflow.com/questions/29738975/how-to-align-a-group-of-checkboxgroupinput-in-r-shiny
                            tags$head(
                                tags$style(
                                    HTML(                   # Change position of different elements 
                                        ".checkbox-inline {    
                    margin-left: 10px;
                    margin-right: 10px;
                    }",
                                        ".shiny-input-container{ 
                    margin-left: 0px;
                    margin-bottom: 20px;
                    }",
                                        
                                        
                                        ".shiny-input-radiogroup{ 
                    margin-top: -200px;
                    margin-bottom: 20px;
                    }",
                                        ".action-button{ 
                    margin-left: 10px;
                    }",      
                                        ".shiny-options-group{ 
                    margin-left: 0px;
                    }",
                                        
                                        ".control-label{ 
                    margin-left: 0px;
                    }",
                                        
                                        ".shiny-output-error { visibility: hidden; }",         # not displaying errors on the dashboard
                                        
                                        ".shiny-output-error:before { visibility: hidden; }",  # not displaying errors on the dashboard
                                        "text {
                      font-family: helvetica,arial,sans-serf;
                    }"
                                    ))))         
                    ),
                    
                    
                    #body ----
                    dashboardBody(
                        tabItems(
                            #* infotext ----
                            #* 
                            tabItem(tabName = "info_text",
                                    fluidPage(
                                        htmlOutput("info_text"))),
                            
                            #* Gemeindevergleich ----
                            tabItem(tabName = "vergleich",
                                    
                                    fluidPage(
                                        # info text
                                        htmlOutput("description_text"),
                                        br(),
                                        # Gemeindeauswahl
                                        selectInput("gemeinde", "Gemeinde:",
                                                   df_gv$Gemeinde),
                                        
                                        # Kantonauswahl
                                        checkboxGroupInput(inputId = "kantone", label = "Mit Gemeinden folgender Kantone vergeleichen:", df_gv$Kanton, inline = T),
                                        actionButton("un_selectall_kantone","Un/Select All"),  # action Links to select and unselect all (reactiv function in server, idea from https://stackoverflow.com/questions/28829682/r-shiny-checkboxgroupinput-select-all-checkboxes-by-click)
                                        
                                        tags$h3("Bevölkerung"),
                                        fluidRow(
                                        column(2, sliderInput(inputId="stae_wb_2019_g", label = 'Gewichtung ständige Wohnbevölkerung (2019):',
                                                     min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="ent_wb_2010_2019_g", label = 'Gewichtung Entwicklung ständige Wohnbevölkerung (2010 bis 2019):',
                                                    min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="bev_dichte_2019_g", label = 'Gewichtung Bevölkerungsdichte (2019):',
                                                              min=0, max=10, value=1, step = 1, ticks = F))),
                                    
                                        tags$h3("Flächen"),
                                        fluidRow(
                                        column(2, sliderInput(inputId="gf_km2_2004_09_g", label = 'Gewichtung Gesamtfläche (2004/09):',
                                                              min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="ant_sf_0409_g", label = 'Gewichtung Anteil Siedlungsfläche (2004/09):',
                                                              min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="ant_lf_0409_g", label = 'Gewichtung Anteil Landwirtschaftsfläche (2004/09):',
                                                              min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="ant_wg_0409_g", label = 'Gewichtung Anteil Wald und Gehölze (2004/09):',
                                                          min=0, max=10, value=1, step = 1, ticks = F)),
                                        column(2, sliderInput(inputId="ant_upf_0409_g", label = 'Gewichtung Anteil unproduktive Fläche (2004/09):',
                                                              min=0, max=10, value=1, step = 1, ticks = F))),
                                        
                                        tags$h3("Bauzonen"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="ant_Wohnzonen_2017_g", label = 'Gewichtung Wohnzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_Mischzonen_2017_g", label = 'Gewichtung Anteil Mischzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_Zentrumszonen_2017_g", label = 'Gewichtung Anteil Zentrumszonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_öffentliche_Nutzungszonen_2017_g", label = 'Gewichtung Anteil öffentliche Nutzungszonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_eingeschränkte_Bauzonen_2017_g", label = 'Gewichtung Anteil eingeschränkte Bauzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_Tourismus_Freizeitzonen_2017_g", label = 'Gewichtung Anteil Tourismus und Freizeitzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_Verkehrszone_Bauzonen_2017_g", label = 'Gewichtung Anteil Verkehrszonen innerhalb der Bauzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_weitere_Bauzonen_2017_g", label = 'Gewichtung Anteil weitere Bauzonen (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                                        tags$h3("ÖV"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="ant_ÖV_Güteklasse_A_2017_g", label = 'Gewichtung Bauzonenfläche in ÖV-Güteklasse A (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ÖV_Güteklasse_B_2017_g", label = 'Gewichtung Bauzonenfläche in ÖV-Güteklasse B (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ÖV_Güteklasse_C_2017_g", label = 'Gewichtung Bauzonenfläche in ÖV-Güteklasse C (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ÖV_Güteklasse_D_2017_g", label = 'Gewichtung Bauzonenfläche in ÖV-Güteklasse D (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ÖV_Güteklasse_keine_2017_g", label = 'Gewichtung Bauzonenfläche in keiner ÖV-Güteklasse (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                                        tags$h3("Wohnen"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="anteil_lw_2020_g", label = 'Gewichtung Anteil Leerwohnungen (2020):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="prok_ngw_2017_g", label = 'Gewichtung Neu gebaute Wohnungen pro 1000 Einwohner (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="dhhg_2018_g", label = 'Gewichtung Durchschnittliche Haushaltsgrösse (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                                        tags$h3("Demografie"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="ant_aus_2019_g", label = 'Gewichtung Anteil Anteil Ausländer (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_sozhi_2019_g", label = 'Gewichtung Sozialhilfequote (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_u20_2019_g", label = 'Gewichtung Anteil unter 20 Jährigen (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_20bis39_2019_g", label = 'Gewichtung Anteil unter 20 bis 39 Jährigen (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_40bis64_2019_g", label = 'Gewichtung Anteil unter 40 bis 64 Jährigen (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ab65_2019_g", label = 'Gewichtung Anteil ab 65 Jährigen (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="prok_geb_2019_g", label = 'Gewichtung Geburten pro 1000 Einwohner (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="prok_hei_2019_g", label = 'Gewichtung Heiraten pro 1000 Einwohner (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="prok_scheid_2019_g", label = 'Gewichtung Scheidungen pro 1000 Einwohner (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="prok_tod_2019_g", label = 'Gewichtung Tote pro 1000 Einwohner (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                                        tags$h3("Wirtschaft"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="dre_17_g", label = 'Gewichtung Reineinkommen pro Einwohner/-in, in Franken (2017):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_bes1_2018_g", label = 'Gewichtung Anteil Beschäftigte im 1. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_bes2_2018_g", label = 'Gewichtung Anteil Beschäftigte im 2. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_bes3_2018_g", label = 'Gewichtung Anteil Beschäftigte im 3. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ast1_2018_g", label = 'Gewichtung Anteil Arbeitsstätten im 1. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ast2_2018_g", label = 'Gewichtung Anteil Arbeitsstätten im 2. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="ant_ast3_2018_g", label = 'Gewichtung Anteil Arbeitsstätten im 3. Sektor (2018):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                                        tags$h3("Politik"),
                                        fluidRow(
                                            column(2, sliderInput(inputId="k_l_P_2019_g", label = 'Gewichtung Wähleranteil kleine linke Parteien (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="GPS_2019_g", label = 'Gewichtung Wähleranteil GPS (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="SP_2019_g", label = 'Gewichtung Wähleranteil SP (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="k_m_P_2019_g", label = 'Gewichtung Wähleranteil kleine Mitteparteien (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="CVP_2019_g", label = 'Gewichtung Wähleranteil CVP (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="BDP_2019_g", label = 'Gewichtung Wähleranteil BDP (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="FDP_2019_g", label = 'Gewichtung Wähleranteil FDP (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="k_r_P_2019_g", label = 'Gewichtung Wähleranteil kleine rechte Parteien (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F)),
                                            column(2, sliderInput(inputId="SVP_2019_g", label = 'Gewichtung Wähleranteil SVP (2019):',
                                                                  min=0, max=10, value=1, step = 1, ticks = F))),
                             ),
                            actionButton("d_berechnen", "Distanz berechnen", style="color: #fff; background-color: #d73925; border-color: #c34113;
                                border-radius: 10px; 
                             border-width: 2px"),
                            
                            fluidRow(
                              br(),
                              dataTableOutput("wei_stand_dis_table"),
                              br(),
                              dataTableOutput("wei_rank_dis_table")
                            ),
                            )),
                    ))



server <- function(input, output, session) {
    
    
    # Info ----  
    #**************************************************************************************************************************************************************************************************************  
    
    #*  Text ----
    # Introduction text 
    output$info_text <- renderUI({HTML(info_text)})
    
    # Gemeindevergleich ----  
    #**************************************************************************************************************************************************************************************************************  
    #*  Text ----
    # Introduction text 
    output$total_text <- renderUI({HTML(total_text)})
    # # Choosing districts text
    # output$choosing_t <- renderUI({HTML("<h4>Wähle auf den Karten die Schulkreise aus, die Sie interessieren. Das Laden der Daten braucht etwas Zeit.</h4>")})
    # 

    # un/select all cantons ------
    observe({
        if (input$un_selectall_kantone%%2== 0)
        {
            updateCheckboxGroupInput(session, "kantone","Mit Gemeinden folgender Kantone vergeleichen:",choices=sort(unique(df_gv$Kanton)), selected = sort(unique(df_gv$Kanton)) , inline=T)
        }
        else if(input$un_selectall_kantone == 0) return(NULL)
        else
        {
            updateCheckboxGroupInput(session,"kantone","Mit Gemeinden folgender Kantone vergeleichen:",choices=sort(unique(df_gv$Kanton)), inline=T) #use sort and unique that every country is only once shown
        }
    })
    
    #create a matrix with the chosen weights (have to use the same order as below in the calculation)-----
    gewichtung <- reactive({c(input$ent_wb_2010_2019_g, input$ant_sf_0409_g, input$ant_lf_0409_g, input$ant_wg_0409_g, input$ant_upf_0409_g, 
                              input$anteil_lw_2020_g, input$prok_ngw_2017_g, input$ant_Wohnzonen_2017_g, input$ant_Mischzonen_2017_g, 
                              input$ant_Zentrumszonen_2017_g, input$ant_öffentliche_Nutzungszonen_2017_g, input$ant_eingeschränkte_Bauzonen_2017_g,
                              input$ant_Tourismus_Freizeitzonen_2017_g, input$ant_Verkehrszone_Bauzonen_2017_g, input$ant_weitere_Bauzonen_2017_g,
                              input$ant_ÖV_Güteklasse_A_2017_g, input$ant_ÖV_Güteklasse_B_2017_g, input$ant_ÖV_Güteklasse_C_2017_g, input$ant_ÖV_Güteklasse_D_2017_g, input$ant_ÖV_Güteklasse_keine_2017_g,
                              input$ant_aus_2019_g, input$ant_sozhi_2019_g, input$ant_u20_2019_g, input$ant_20bis39_2019_g, input$ant_40bis64_2019_g, 
                              input$ant_ab65_2019_g, input$prok_geb_2019_g, input$prok_hei_2019_g, input$prok_scheid_2019_g, input$prok_tod_2019_g,
                              input$ant_bes1_2018_g, input$ant_bes2_2018_g, input$ant_bes3_2018_g, input$ant_ast1_2018_g, input$ant_ast2_2018_g, input$ant_ast3_2018_g,
                              input$k_l_P_2019_g, input$GPS_2019_g, input$SP_2019_g, input$k_m_P_2019_g, input$CVP_2019_g, input$BDP_2019_g, input$FDP_2019_g, input$k_r_P_2019_g, input$SVP_2019_g,
                              input$stae_wb_2019_g, input$bev_dichte_2019_g, input$gf_km2_2004_09_g, input$dhhg_2018_g, input$dre_17_g)})
    
    observe(print(gewichtung()))

    # code executed after hitting the action button ----
    
#   I propably use only the rank based values this is maybe to complicated
#     #* calculate distance with standardized values-----
#     df_distance <- eventReactive(input$d_berechnen, {
#     
#     # select name and number of municipalities for later  
#     namen_nummer <- df_gv %>% 
#         filter(Gemeinde != input$gemeinde) %>% 
#         filter (Kanton %in% input$kantone) %>% 
#         select(c("Gemeinde", "BfS_id", "Kanton"))  
#       
#     
#     # filtering out the chosen municipality and creating two seperate dataframes 
# 
#     # select percentage and per 1000 inhabitants values               
#     df_gp <- dplyr::filter(df_gv, Gemeinde %in% input$gemeinde) %>% 
#      select(c(ent_wb_2010_2019, ant_sf_0409, ant_lf_0409, ant_wg_0409, ant_upf_0409, 
#                      anteil_lw_2020, prok_ngw_2017, 
#                      ant_Wohnzonen_2017, ant_Mischzonen_2017, ant_Zentrumszonen_2017, ant_öffentliche_Nutzungszonen_2017, ant_eingeschränkte_Bauzonen_2017, ant_Tourismus_Freizeitzonen_2017, ant_Verkehrszone_Bauzonen_2017, ant_weitere_Bauzonen_2017,
#                      ant_ÖV_Güteklasse_A_2017, ant_ÖV_Güteklasse_B_2017, ant_ÖV_Güteklasse_C_2017, ant_ÖV_Güteklasse_D_2017, ant_ÖV_Güteklasse_keine_2017,
#                      ant_aus_2019, ant_sozhi_2019, ant_u20_2019, ant_20bis39_2019, ant_40bis64_2019, ant_ab65_2019,
#                      prok_geb_2019, prok_hei_2019, prok_scheid_2019, prok_tod_2019,
#                      ant_bes1_2018, ant_bes2_2018, ant_bes3_2018, ant_ast1_2018, ant_ast2_2018, ant_ast3_2018,
#                      k_l_P_2019, GPS_2019, SP_2019, k_m_P_2019, CVP_2019, BDP_2019, FDP_2019, k_r_P_2019, SVP_2019))
# 
#     # select chosen municipality and absolut values and people per km2
#     df_gnp <-     dplyr::filter(df_gv, Gemeinde %in% input$gemeinde) %>% 
#         select(c(stae_wb_2019, bev_dichte_2019, gf_km2_2004_09, dhhg_2018, dre_17))
#     
#     # select all other municipality and  percentage and per 1000 inhabitants values
#     df_agp <-  df_gv %>% dplyr::filter(!Gemeinde %in% input$gemeinde) %>% 
#       filter (Kanton %in% input$kantone) %>% 
#             select(c(ent_wb_2010_2019, ant_sf_0409, ant_lf_0409, ant_wg_0409, ant_upf_0409, 
#                      anteil_lw_2020, prok_ngw_2017, 
#                      ant_Wohnzonen_2017, ant_Mischzonen_2017, ant_Zentrumszonen_2017, ant_öffentliche_Nutzungszonen_2017, ant_eingeschränkte_Bauzonen_2017, ant_Tourismus_Freizeitzonen_2017, ant_Verkehrszone_Bauzonen_2017, ant_weitere_Bauzonen_2017,
#                      ant_ÖV_Güteklasse_A_2017, ant_ÖV_Güteklasse_B_2017, ant_ÖV_Güteklasse_C_2017, ant_ÖV_Güteklasse_D_2017, ant_ÖV_Güteklasse_keine_2017,
#                      ant_aus_2019, ant_sozhi_2019, ant_u20_2019, ant_20bis39_2019, ant_40bis64_2019, ant_ab65_2019,
#                      prok_geb_2019, prok_hei_2019, prok_scheid_2019, prok_tod_2019,
#                      ant_bes1_2018, ant_bes2_2018, ant_bes3_2018, ant_ast1_2018, ant_ast2_2018, ant_ast3_2018,
#                      k_l_P_2019, GPS_2019, SP_2019, k_m_P_2019, CVP_2019, BDP_2019, FDP_2019, k_r_P_2019, SVP_2019))
#     
#     # select all other municipality and absolute values and people per km2
#     df_agnp <- df_gv %>% dplyr::filter (!Gemeinde %in% input$gemeinde) %>% 
#       filter(Kanton %in% input$kantone) %>% 
#             select(c(stae_wb_2019, bev_dichte_2019, gf_km2_2004_09, dhhg_2018, dre_17))
#         
# 
#     #distance formula for percentage and per 1000 inhabitants
#     distance_p <-    mapply(function(x, y) if_else(x>=y, x-y, y-x), df_gp, df_agp)
#     
#     #distance formula for absolute values and people per km2
#     distance_np <- mapply(function(x, y) if_else(x == y, 0, if_else(x>=y, x/y, y/x)), df_gnp, df_agnp)
#     
#     # merge the two sets
#     distance <- as.data.frame(cbind(distance_p, distance_np)) 
#     
#     # weight it with the values choosen 
#     weighted_distance <- mapply(function(x, y) x*y, distance, gewichtung())
#     
#     # standardize it and than take the absolute value
#     #* https://www.statology.org/standardize-data-in-r/
#     weighted_stand_distance <- as.data.frame(weighted_distance) %>% 
#       mutate_all(~(scale(.))) %>% 
#       mutate_all(~(abs(.))) %>% 
#       mutate_if(is.numeric, ~replace(., is.na(.), 0))
#     
#     # calculate the total weighted standardized distance
#     weighted_stand_distance <- weighted_stand_distance %>% 
#         rowwise() %>% 
#         mutate(across(c("ent_wb_2010_2019":"dre_17"), .names = "g_s_d_{col}")) %>% 
#         mutate(g_s_dist = sum(c_across(g_s_d_ent_wb_2010_2019:g_s_d_dre_17))) %>% 
#         select(-c(ent_wb_2010_2019:dre_17))
# 
#     
#     weighted_distance_names <- cbind(namen_nummer, weighted_stand_distance) %>% 
#       arrange(by = g_s_dist)
#     
#     
#     
#     }) 
#     
#         
#    output$wei_stand_dis_table <- renderDataTable({DT::datatable(df_distance(), filter = "top", extensions = c('Buttons', 'Scroller'), 
#                                   options = list(scrollY = 650,
#                                                  scrollX = 500,
#                                                  deferRender = TRUE,
#                                                  scroller = TRUE))})
#    observe(print(df_distance()))
#    
   #* calculate distance with ranks-----
   df_rank_dis <- eventReactive(input$d_berechnen, {
     
     # select name and number of municipalities for later  
     namen_nummer <- df_gv %>% 
       filter(Gemeinde != input$gemeinde) %>% 
       filter (Kanton %in% input$kantone) %>% 
       select(c("Gemeinde", "BfS_id", "Kanton"))  
     
     # calculate ranks over all municipalities
     df_gv_rank <- df_gv  %>%
       filter (Kanton %in% input$kantone) %>% 
       mutate_if(is.numeric, ~(rank(.,  ties.method = c("min"))))
     
     # choose selected municipality, and unselect municipality name, bfs id and canton
     df_gr <- df_gv_rank %>%  
       filter(Gemeinde %in% input$gemeinde) %>% 
       select(-c("Gemeinde", "BfS_id", "Kanton")) 
      
     # choose all other municipalities, and unselect municipality name, bfs id and canton
     df_agr <- df_gv_rank %>%  
       filter(!Gemeinde %in% input$gemeinde) %>% 
       select(-c("Gemeinde", "BfS_id", "Kanton")) 
     
     # calculate absolute rank distance 
     rank_dist <- mapply(function(x, y) abs(x-y), df_gr, df_agr)
     
     df_rank_dist <- as.data.frame(rank_dist)
     
     # weight it with the values choosen 
     weighted_rank_dist <- mapply(function(x, y) x*y, df_rank_dist, gewichtung())
     
     # calculate the total weighted rank distance
     df_weighted_rank_dist <- as.data.frame(weighted_rank_dist) %>% 
       rowwise() %>% 
       mutate(across(c(1:ncol(rank_dist)), .names = "g_r_d_{col}")) %>% 
       select(-c(1:ncol(rank_dist))) 
       
     df_weighted_rank_dist <-  df_weighted_rank_dist %>% 
       mutate(g_r_dist = sum(c_across(1:ncol(df_weighted_rank_dist))))
       
     
     df_weighted_distance_names <- cbind(namen_nummer, df_weighted_rank_dist)%>% 
       arrange(by = g_r_dist)
     
     
   }) 
   
   output$wei_rank_dis_table <- renderDataTable({DT::datatable(df_rank_dis(), filter = "top", extensions = c('Buttons', 'Scroller'), 
                                                               options = list(scrollY = 650,
                                                                              scrollX = 500,
                                                                              deferRender = TRUE,
                                                                              scroller = TRUE))})
   
    observe(print(df_rank_dis()))
    
    
}


ui <-  shinyApp(ui = ui, server = server)