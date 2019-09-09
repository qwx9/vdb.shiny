*Visualisation de données biologiques* 2019-2020
-------------

### Liste des packages R utiles pour ce cours :

- ade4
- ggplot2
- microbenchmark
- gridExtra
- plotly
- shiny

-------------------


### 1 Introduction


- **1.4.A** - Quel est votre répertoire courant de travail ?
- **1.4.B** - Dans combien de répertoires les packages R de votre machine sont localisés ?
- **1.4.C** - Quelle est la version de R utilisée par votre session ?

-------------------


### 2 Les bases du langage R

- **2.1.A** - Chargez le jeu de données `dfvaris_litter.Rdata` dans votre session R.
- **2.1.B** - Quelle est la structure de ce jeu de données (dimension, nombre de portées, nom des variables, type de variables, données manquantes, ...) ?
- **2.1.C** - Combien d'espèces sont présentes dans ce jeu de données ? Et combien y a-t-il de portées suivies par espèce ?
- **2.1.D** - Créez un nouveau jeu de données `sub_dfvaris_litter` contenant 100 portées (prises au hasard) de chaque espèce.
- **2.1.E** - Ajoutez une nouvelle variable `PAD` (Parental Age Difference) dans `dfvaris_litter`, égale à l'âge du père moins l'âge de la mère.

<br>

Supposez une fonction `info_vect` qui prend en entrée un vecteur et qui renvoie une liste contenant la classe de ce vecteur, sa longueur, le résultat de la fonction `summary` appliquée à ce vecteur et le nombre de valeurs manquantes contenues dans ce vecteur.

- **2.2.A** - Avant même de créer cette fonction, pouvez-vous dire quelle est la taille de l'objet qu'elle retourne ?
- **2.2.B** - Créez cette fonction.
- **2.2.C** - Appliquez cette fonction à la variable `survlitter48h` du jeu de données `dfvaris_litter`.
- **2.2.D** - Faire une boucle pour appliquer cette fonction à chaque variable du jeu de données `dfvaris_litter`.
- **2.2.E** - Remplacez la boucle développée dans la question **2.2.E** par une fonction `lapply` pour obtenir le même résultat.
- **2.2.F** - Laquelle des deux méthodes (**2.2.E** vs **2.2.F**) est la plus rapide à l'exécution ?

```r
library(microbenchmark)
```


-------------------

### 3 Les graphiques dans R


- **3.1.A** - A l'aide du package `graphics`, inspirez-vous de la Figure S1 (en annexe de l'article de Tidière et al. (2018)) pour créer un graphique contenant :
  - l'âge de la mère en fonction de l'âge du père de chaque portée, en différenciant les deux espèces
  - la droite de régression du modèle linéaire expliquant l'âge du père par l'âge de la mère
  - l'équation de cette droite de régression
  - la droite représentant un modèle d'accouplement des varis où l'âge du père est égal à l'âge de la mère
  - des points supplémentaires représentant l'âge moyen du père pour chaque âge de la mère, en différenciant les deux espèces
- **3.1.B** - Pour quelles raisons le graphique produit à la question **3.1.A** est légèrement différent de celui publié dans Tidière et al. (2018) ?
- **3.1.C** - Proposez des améliorations au graphique qui a été publié.

<br>

- **3.2.A** - Complétez le graphique créé avec le code ci-dessous en colorant l'aire sous la courbe de densité pour les valeurs supérieures au 3ème quartile.

```r
(h_agedam <- hist(dfvaris_litter$agedam, freq = FALSE, 
               main = "Distribution de l'âge de la mère des portées de varis",
               xlab = "Age de la mère en années", ylab = "Densité"))

# Ajout d'une courbe de densité
dens_agedam <- density(dfvaris_litter$agedam)
lines(dens_agedam)

# Ajout d'une ligne verticale : moyenne des âges
abline(v = mean(dfvaris_litter$agedam), col = "red")

# Coloration de la densité pour les valeurs inférieures au 1er quartile
qrtle1 <- summary(dfvaris_litter$agedam)["1st Qu."]
polygon(c(0, dens_agedam$x[dens_agedam$x <= qrtle1]), 
        c(dens_agedam$y[dens_agedam$x <= qrtle1], 0), 
        col = rgb(1, 0, 0, alpha = 0.3))
```
- **3.2.B** - Sur le modèle des 3 sous-graphiques créés avec le code ci-dessous, complétez le graphique en construisant un 4ème sous-graphique représentant la distribution de l'âge des pères des portées de l'espèce V. Variegata.

```r
par(mfrow = c(2, 2))

dfagedam_vr <- dfvaris_litter$agedam[dfvaris_litter$species == "Vrubra"]
hist(dfagedam_vr, freq = FALSE, main = "Distribution de l'âge de la\nmère des portées de V. Rubra", xlab = "Age de la mère", ylab = "Densité", col = "#69b3a2")
lines(density(dfagedam_vr))

dfagedam_vv <- dfvaris_litter$agedam[dfvaris_litter$species == "Vvariegata"]
hist(dfagedam_vv, freq = FALSE, main = "Distribution de l'âge de la\nmère des portées de V. Variegata", xlab = "Age de la mère", ylab = "", col = "#404080")
lines(density(dfagedam_vv))

dfagesire_vr <- dfvaris_litter$agesire[dfvaris_litter$species == "Vrubra"]
hist(dfagesire_vr, freq = FALSE, main = "Distribution de l'âge du\npère des portées de V. Rubra", xlab = "Age du père", ylab = "Densité", col = "#69b3a2")
lines(density(dfagesire_vr))
```
- **3.2.C** - Sur le modèle du graphique créé avec le code ci-dessous, construisez un boxplot représentant la distribution de l'âge des pères des portées de chacune des deux espèces.

```r
bxpt_agedam <- boxplot(dfvaris_litter$agedam ~ dfvaris_litter$species, xlab = "", ylab = "Age de la mère", col = c("#69b3a2", "#404080"))
```

<br>

- **3.3.A** - A l'aide du package `ggplot2`, reproduisez la figure que vous avez construite à la question **3.1.A**, inspirée de la Figure S1 en annexe de l'article de Tidière et al. (2018). 


-------------------


### 4 Des applications web avec `shiny`

- **4.2.A** - Créez une application (qui s'affiche et réagit comme attendu) à partir des codes ci-dessous.
Cette première application s'appuie sur le jeu de données `doubs` d'`ade4` vu dans la section 2.1.
Ici, founissez simplement une capture d'écran de deux états différents de l'application produite.

```r
# ui.R
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

# server.R
library(shiny)
library(ade4)

shinyServer(function(input, output) {

    output$abondancePlot <- renderPlot({

        data(doubs)
        df_espece <- doubs$fish[[input$espece]]
        plot(doubs$xy$x, doubs$xy$y, 
             cex = ifelse(df_espece == 0, 1, df_espece),
             pch = ifelse(df_espece == 0, 4, 19))
    })
})
```


- **4.2.B** - Dans le but de rendre disponibles vos analyses sur le jeu de données `dfvaris_litter`, créez une application qui permettra d'afficher la distribution (histogramme et courbe de densité) de l'âge des parents pour les espèces de varis (voir les graphiques dans les deuxièmes onglets des sections 3.2 et 3.3). 
Ici, fournissez le code R et une capture d'écran de votre application.
Cette application contiendra :
  - un titre
  - un paragraphe explicatif sur le jeu de données
  - un objet interactif qui permet de sélectionner une des deux espèces ou les deux
  - un objet interactif qui permet de sélectionner le père, la mère ou les deux
  - une zone graphique contenant le ou les graphiques (selon les valeurs des deux objets interactifs précédents) de la distribution de l'âge des parents des portées de varis.


- **4.2.C** - Dans le but de rendre disponibles vos analyses sur le jeu de données `dfvaris_litter`, créez une application qui affiche un même graphique (par exemple, le boxplot représentant la distribution de la taille des portées de varis dans les 2 espèces, voir le dernier onglet des sections 3.2 et 3.3) sous 3 formes différentes : le 1er généré à partir du package `graphics`, le 2ème généré à partir du package `ggplot2` et le 3ème généré à partir des packages `ggplot2` et `plotly`. 
Ici, fournissez le code R et une capture d'écran de votre application.

- **4.2.D** - Dans le but de rendre disponibles vos analyses sur le jeu de données `dfvaris_litter`, créez une application qui permet d'explorer la Figure S1 en annexe de l'article de @tidiere2018. 
Ici, fournissez le code R et une ou plusieurs captures d'écran de votre application.
Vous pourrez vous appuyer soit sur le package `graphics` soit sur le package `ggplot2`.
Vous pourrez par exemple proposer des outils pour :
  - afficher ou pas une légende
  - faire varier la grosseur des points
  - attribuer une couleur à chaque espèce
  - sélectionner la ou les variable.s représentée.s
  - télécharger le graphique
  