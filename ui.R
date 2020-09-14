#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
    tabsetPanel(
    # Application title
        tabPanel("Main",
            titlePanel("Affichage de notre courbe"), 
            sidebarLayout(
                sidebarPanel(
                    sliderInput("freq",
                                "Frequence en Hz:",
                                min = 1,
                                max = 30,
                                value = 3) ,
                    sliderInput("echant",
                                "Nombre d'echantillon",
                                min = 5,
                                max = 100,
                                value = 30) , 
                    sliderInput("harmo",
                                "Nombre d'harmonique",
                                min = 0,
                                max = 5,
                                value = 0) ,
                    
                    checkboxGroupInput("varia", "A afficher : ",
                                  c("Signal total" = "tot",
                                    "Echantillon" = "echant") , 
                                  selected = c("tot", "echant")),
                    conditionalPanel(
                        condition = "input.varia.indexOf('echant') > -1 ",
                        checkboxInput("echant_ligne",
                                      "Ligne pour les echantillons ? ",
                                      value = FALSE )) , 
                    checkboxInput("bruh",
                                "Ajouter du bruit ?",
                                value = FALSE) ,
                    conditionalPanel(
                        condition = "input.bruh" , 
                        sliderInput("pourcbruit",
                                    "Pourcentage de bruit: ",
                                    min = 0,
                                    max = 100,
                                    value = 10)
                        
                    )
        
                ),

                # Show a plot of the generated distribution
                mainPanel(
                    plotOutput("sin_plot")
                )
            )
        )
         ,
        tabPanel("Fourier",
                 titlePanel("Reconstitution et Amplitiude/freq"), 
                 sidebarLayout(
                     sidebarPanel(
                         checkboxInput("fouriertot",
                                       "Selectionner tout les coefficient de Fourier ?",
                                       value = TRUE) ,
                         conditionalPanel(
                            condition = "!input.fouriertot" , 
                            sliderInput("pourc",
                                        "Pourcentage minimum de selection par rapport au max : ",
                                        min = 0,
                                        max = 100,
                                        value = 10)
                            )  ,
                         checkboxInput("add_point",
                                       "Ajouter des echantillons artificiellement (zero-padding) ?",
                                       value = FALSE),
                         conditionalPanel(
                             condition = "input.add_point" , 
                             sliderInput("add_point_nb",
                                         "Nombre d'echantillons a ajouter: ",
                                         min = 0,
                                         max = 100,
                                         value = 10)
                         )  ,
                     ) ,
                     mainPanel(
                         plotOutput("inv_fourier"),
                         plotOutput("fourier")
                     )
                 )
        ) ,
        tabPanel("Decomposition Harmoniques",
                 titlePanel("Toutes les harmoniques originales du signal"), 
                 sidebarLayout(
                     sidebarPanel(
                     conditionalPanel( condition = "input.bruh", 
                                     checkboxInput("bruit_affichage",
                                                    "Afficher le bruit",
                                                   value = FALSE) 
                     ) ,
                     conditionalPanel( condition = "input.harmo > 0", 
                                      checkboxInput("harmo_1",
                                                    "Afficher la premiere harmonique",
                                                    value = FALSE) ,                                          
                     ) ,
                     conditionalPanel( condition = "input.harmo > 1", 
                                       checkboxInput("harmo_2",
                                                     "Afficher la deuxiÃ¨me harmonique",
                                                     value = FALSE) ,                                          
                     ) ,
                     conditionalPanel( condition = "input.harmo > 2", 
                                       checkboxInput("harmo_3",
                                                     "Afficher la troisieme harmonique",
                                                     value = FALSE) ,                                          
                     ) ,
                     conditionalPanel( condition = "input.harmo > 3", 
                                       checkboxInput("harmo_4",
                                                     "Afficher la quatrieme harmonique",
                                                     value = FALSE) ,                                          
                     ) 
                     ) ,
                     mainPanel(
                         plotOutput("harmonique")
                     )
                 )
        ) ,
        tabPanel("S'amuser avec deux sinus",
                 titlePanel("S'amuser avec deux sinus (indépendant du reste)"),
                 sidebarLayout(
                     sidebarPanel(
                         numericInput(inputId = "freq_sin1",
                                     label =  "Frequence du premier sinus entre 0 et 30 Hz",
                                     min = 0,
                                     max = 30, 
                                     value = 10),
                         numericInput(inputId = "ampli_sin1",
                                      label = "Amplitude du premier sinus entre 0 et 1",
                                      min = 0,
                                      max = 1,
                                     value = 1,
                                     step = 0.05),
                         numericInput(inputId = "freq_sin2",
                                      label =  "Frequence du deuxième sinus entre 0 et 30 Hz",
                                      min = 0,
                                      max = 30, 
                                      value = 20),
                         numericInput("ampli_sin2",
                                      "Amplitude du deuxième sinus entre 0 et 1",
                                      min = 0,
                                      max = 1,
                                      value = 0.8,
                                      step = 0.05),
                         sliderInput("nb_p",
                                     "Nombre de points à échantilloner pour Fourier:",
                                     min = 65,
                                     max = 200,
                                     value = 100)
                     ) , 
                     mainPanel(
                         plotOutput("sin_mult_plot"),
                         plotOutput("four_2")
                     )
                 )
        )
    )
    
))
