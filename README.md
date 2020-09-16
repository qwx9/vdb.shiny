*Visualisation de données biologiques* 2020-2021
-------------

### Liste des packages R qui peuvent vous être utiles pour ce cours :

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
- **2.1.C** - Combien d’espèces sont présentes dans ce jeu de données ? Et combien de portées sont suivies par espèce ?
- **2.1.D** - Créez un nouveau jeu de données `sub_dfvaris_litter` contenant 100 portées (prises au hasard) de chaque espèce.
- **2.1.E** - Ajoutez une nouvelle variable `PAD` (Parental Age Difference) dans `dfvaris_litter`, égale à l'âge du père moins l'âge de la mère.


<br>

Supposez une fonction `info_vect` qui prend en entrée un vecteur et qui renvoie une liste contenant la classe de ce vecteur, sa longueur, le résultat de la fonction `summary` appliquée à ce vecteur et le nombre de valeurs manquantes contenues dans ce vecteur.

- **2.2.A** - Avant même de créer cette fonction, pouvez-vous dire quelle est la taille de l'objet qu'elle retourne ?
- **2.2.B** - Créez cette fonction.
- **2.2.C** - Appliquez cette fonction à la variable `survlitter48h` du jeu de données `dfvaris_litter`.
- **2.2.D** - Faire une boucle pour appliquer cette fonction à chaque variable (colonne) du jeu de données `dfvaris_litter`.

Pour aller plus loin :

- **2.2.E** - Remplacez la boucle développée dans la question **2.2.D** par une fonction `lapply` qui vous donnera le même résultat.
- **2.2.F** - Entre ces deux méthodes (**2.2.D** vs **2.2.E**), quelle la plus rapide ?


-------------------

### 3 Les graphiques dans R


- **3.1.A** - A l'aide du package `graphics`, inspirez-vous de la Figure S1 (en annexe de l'article de Tidière et al. (2018)) pour créer un graphique contenant :
  - l'âge de la mère en fonction de l'âge du père de chaque portée, en différenciant les deux espèces
  - des titres aux axes
  - la droite de régression du modèle linéaire expliquant l'âge du père par l'âge de la mère
  - l'équation de cette droite de régression
  - la droite représentant un modèle d'accouplement des varis où l'âge du père est égal à l'âge de la mère (*i.e.* 1ère bissectrice)
  - des points supplémentaires représentant l'âge moyen du père pour chaque âge de la mère, en différenciant les deux espèces
- **3.1.B** - Pour quelles raisons le graphique produit à la question **3.1.A** est légèrement différent de celui publié dans Tidière et al. (2018) ?
- **3.1.C** - Proposez des améliorations au graphique qui a été publié.

<br>

- **3.2.A** - Complétez ce graphique en colorant l'aire sous la courbe de densité pour les valeurs supérieures au 3ème quartile.

```r
# Distribution de l'âge des mères

# Création de l'histogramme de l'âge des mères
h_agedam <- hist(dfvaris_litter$agedam, freq = FALSE, 
                 main = "Distribution de l'âge des mères",
                 xlab = "Age de la mère en années", ylab = "Densité")

# Ajout d'une courbe de densité
dens_agedam <- density(dfvaris_litter$agedam)
lines(dens_agedam)

# Ajout d'une ligne verticale ayant pour abscisse l'âge moyen des mères
abline(v = mean(dfvaris_litter$agedam), col = "red")

# Coloration de l'aire sous la courbe de densité pour les valeurs inférieures au 1er quartile
qrtle1 <- summary(dfvaris_litter$agedam)["1st Qu."]
polygon(c(0, dens_agedam$x[dens_agedam$x <= qrtle1]), 
        c(dens_agedam$y[dens_agedam$x <= qrtle1], 0), 
        col = rgb(1, 0, 0, alpha = 0.3))



# Ajout d'une ligne verticale : moyenne des âges
abline(v = mean(dfvaris_litter$agedam), col = "red")

# Coloration de la densité pour les valeurs inférieures au 1er quartile
qrtle1 <- summary(dfvaris_litter$agedam)["1st Qu."]
polygon(c(0, dens_agedam$x[dens_agedam$x <= qrtle1]), 
        c(dens_agedam$y[dens_agedam$x <= qrtle1], 0), 
        col = rgb(1, 0, 0, alpha = 0.3))
```

<br>

- **3.2.B** - Sur le modèle des 3 sous-graphiques créés avec le code ci-dessous, complétez le graphique en construisant un 4ème sous-graphique représentant la distribution de l'âge des pères de l'espèce V. Variegata.

```r
# Distribution de l'âge des mères et des pères en fonction de l'espèce

# Préparation d'une zone graphique à deux lignes et deux colonnes
par(mfrow = c(2, 2))

# Création d'un vecteur contenant l'âge des mères de l'espèce V. Rubra
dfagedam_vr <- dfvaris_litter$agedam[dfvaris_litter$species == "Vrubra"]
# Création de l'histogramme de l'âge des mères de l'espèce V. Rubra
hist(dfagedam_vr, freq = FALSE, main = "Distribution de l'âge des mères\nde l'espèce V. Rubra", xlab = "Age de la mère", ylab = "Densité", col = "#69b3a2")
# Ajout de la courbe de densité de l'âge des mères de l'espèce V. Rubra
lines(density(dfagedam_vr))

# Création d'un vecteur contenant l'âge des mères de l'espèce V. Variegata
dfagedam_vv <- dfvaris_litter$agedam[dfvaris_litter$species == "Vvariegata"]
# Création de l'histogramme de l'âge des mères de l'espèce V. Variegata
hist(dfagedam_vv, freq = FALSE, main = "Distribution de l'âge des mères\nde l'espèce V. Variegata", xlab = "Age de la mère", ylab = "", col = "#404080")
# Ajout de la courbe de densité de l'âge des mères de l'espèce V. Variegata
lines(density(dfagedam_vv))

# Création d'un vecteur contenant l'âge des pères de l'espèce V. Rubra
dfagesire_vr <- dfvaris_litter$agesire[dfvaris_litter$species == "Vrubra"]
# Création de l'histogramme de l'âge des pères de l'espèce V. Rubra
hist(dfagesire_vr, freq = FALSE, main = "Distribution de l'âge des pères\nde l'espèce V. Rubra", xlab = "Age du père", ylab = "Densité", col = "#69b3a2")
# Ajout de la courbe de densité de l'âge des pères de l'espèce V. Rubra
lines(density(dfagesire_vr))

```

<br>

- **3.2.C** - Sur le modèle du graphique créé avec le code ci-dessous, construisez un boxplot représentant la distribution de l'âge des pères en fonction de l'espèce.

```r
# Distribution de l'âge des mères en fonction de l'espèce

# Création du boxplot de l'âge des mères en fonction de l'espèce et affichage des statistiques de calcul
(bxpt_agedam <- boxplot(dfvaris_litter$agedam ~ dfvaris_litter$species, 
                        xlab = "", ylab = "Age de la mère", col = c("#69b3a2", "#404080")))
```

<br>

- **3.3.A** - A l'aide du package `ggplot2`, reproduisez la figure que vous avez construite à la question **3.1.A**, inspirée de la Figure S1 en annexe de l'article de Tidière et al. (2018). 

-------------------


### 4 Des applications web avec `shiny`

- **4.2.A** - Créez et lancez une nouvelle application à partir des codes ci-dessous.
Cette application s'appuie sur le jeu de données `doubs` d'`ade4` vu dans la section 2.1.
Elle permet de visualiser l'abondance des différentes espèces de poissons prélevés au niveau de 30 sites localisés le long de la rivière Doubs.
Ici, vous pourrez simplement fournir une capture d'écran de deux états différents de l'application produite.

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

<br>

- **4.2.B** - Dans le but de proposer un outil qui explore vos analyses sur les données `dfvaris_litter`, créez une application qui permettra d'afficher la distribution (histogramme et courbe de densité) de l'âge des parents chez les varis (voir les graphiques dans les onglets B des sections 3.2 et 3.3). Cette application contiendra :
  - un titre
  - un paragraphe explicatif sur le jeu de données
  - un objet interactif qui permet à l'utilisateur.trice d'afficher les résultats pour une des deux espèces ou les deux
  - un objet interactif qui permet à l'utilisateur.trice d'afficher les résultats pour le père, la mère ou les deux
  - une zone graphique contenant le ou les graphiques (selon les valeurs des deux objets interactifs précédents) de la distribution de l'âge des parents des portées de varis.

Ici, vous pourrez fournir le code R et une ou plusieurs captures d'écran de votre application.

<br>

- **4.2.C** - Dans le but de proposer un outil qui explore vos analyses sur les données `dfvaris_litter`, créez une application qui affiche un même graphique sous 3 formes différentes : 
  - le 1er graphique sera généré par les fonctions du package `graphics`, 
  - le 2ème graphique sera généré par les fonctions du package `ggplot2` 
  - et le 3ème graphique sera un graphique intéractif généré par les fonctions des packages `ggplot2` et `plotly`.

Vous pouvez, par exemple, choisir le boxplot de l'onglet D des sections 3.2 et 3.3 (représentant la distribution de la taille des portées en fonction de l'espèce) comme objet d'étude.
Ici, vous pourrez fournir le code R et une ou plusieurs captures d'écran de votre application.

<br>

- **4.2.D** - Dans le but de proposer un outil qui explore vos analyses sur les données `dfvaris_litter`, créez une application qui permet d'explorer la Figure S1 en annexe de l'article de Tidière et al. (2018). 
Vous pourrez choisir d'utiliser les fonctions du package `graphics` ou celles du package `ggplot2`.
Vous pourrez, par exemple, proposer des objets réactifs pour :
  - afficher ou pas la légende
  - faire varier la taille des points
  - attribuer une couleur à chaque espèce
  - modifier les titres des axes
  - télécharger le graphique
  
Ici, vous pourrez fournir le code R et une ou plusieurs captures d'écran de votre application.

<br>
<br>