load("data_varis/dfvaris_litter.Rdata")

# A
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
polygon(c(
		0,
		dens_agedam$x[dens_agedam$x <= qrtle1]
	), c(
		dens_agedam$y[dens_agedam$x <= qrtle1],
		0
	), col = rgb(1, 0, 0, alpha = 0.3))
polygon(c(
		dens_agedam$x[dens_agedam$x > quantile(dfvaris_litter$agedam, 0.75)],
		0
	), c(
		0,
		dens_agedam$y[dens_agedam$x > quantile(dfvaris_litter$agedam, 0.75)]
	), col = rgb(0,0,1,alpha=0.2))


# B
# Préparation d'une zone graphique à deux lignes et deux colonnes
par(mfrow = c(2, 2))

# Création d'un vecteur contenant l'âge des mères de l'espèce V. Rubra
dfagedam_vr <- dfvaris_litter$agedam[dfvaris_litter$species == "Vrubra"]
# Création de l'histogramme de l'âge des mères de l'espèce V. Rubra
hist(dfagedam_vr, freq = FALSE, main = "Distribution de l'âge des mères\nde l'espèce V. Rubra", 
	xlab = "Age de la mère", ylab = "Densité", col = "#69b3a2")
# Ajout de la courbe de densité de l'âge des mères de l'espèce V. Rubra
lines(density(dfagedam_vr))

# Création d'un vecteur contenant l'âge des mères de l'espèce V. Variegata
dfagedam_vv <- dfvaris_litter$agedam[dfvaris_litter$species == "Vvariegata"]
# Création de l'histogramme de l'âge des mères de l'espèce V. Variegata
hist(dfagedam_vv, freq = FALSE, main = "Distribution de l'âge des mères\nde l'espèce V. Variegata", 
	xlab = "Age de la mère", ylab = "", col = "#404080")
# Ajout de la courbe de densité de l'âge des mères de l'espèce V. Variegata
lines(density(dfagedam_vv))

# Création d'un vecteur contenant l'âge des pères de l'espèce V. Rubra
dfagesire_vr <- dfvaris_litter$agesire[dfvaris_litter$species == "Vrubra"]
# Création de l'histogramme de l'âge des pères de l'espèce V. Rubra
hist(dfagesire_vr, freq = FALSE, main = "Distribution de l'âge des pères\nde l'espèce V. Rubra",
	xlab = "Age du père", ylab = "Densité", col = "#69b3a2")
# Ajout de la courbe de densité de l'âge des pères de l'espèce V. Rubra
lines(density(dfagesire_vr))

# Création d'un vecteur contenant l'âge des mères de l'espèce V. Variegata
dfagesire_vv <- dfvaris_litter$agesire[dfvaris_litter$species == "Vvariegata"]
# Création de l'histogramme de l'âge des mères de l'espèce V. Variegata
hist(dfagesire_vv, freq = FALSE, main = "Distribution de l'âge des mères\nde l'espèce V. Variegata", 
	xlab = "Age de la mère", ylab = "", col = "#404080")
# Ajout de la courbe de densité de l'âge des mères de l'espèce V. Variegata
lines(density(dfagesire_vv))


# C
par(mfrow=c(2,1))

# Création du boxplot de l'âge des mères en fonction de l'espèce et affichage des statistiques de calcul
bxpt_agedam <- boxplot(dfvaris_litter$agedam ~ dfvaris_litter$species, 
	xlab = "", ylab = "Age de la mère", col = c("#69b3a2", "#404080"))

bxpt_agesire <- boxplot(dfvaris_litter$agesire ~ dfvaris_litter$species, 
	xlab = "", ylab = "Age de la mère", col = c("#69b3a2", "#404080"))
