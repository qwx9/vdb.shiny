load("../data_varis/dfvaris_litter.Rdata")

shinyUI(fluidPage(
	titlePanel("Exploration du jeu de données dfvaris_litter"),
	selectInput("species", "Espèce:", levels(dfvaris_litter$species)),
	plotOutput("hist")
))
