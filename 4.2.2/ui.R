library(ade4)
data(doubs)

shinyUI(fluidPage(
  # Titre de l'application
  titlePanel("Exploration du jeu de données doubs d'ade4"),
  
  # Menu déroulant pour choisir une espèce
  # La liste des espèces est définie par les colonnes de doubs$fish
  selectInput("espece", "Sélectionnez une espèce:",
              choices = colnames(doubs$fish)),
  
  # Graphique représentant l'abondance de l'espèce sélectionné à chaque position géographique (doubs$xy)
  plotOutput("abondancePlot")
))
