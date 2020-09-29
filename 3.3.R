load("data_varis/dfvaris_litter.Rdata")

# Distribution de l'âge des mères (voir onglet A du chapitre 3.2)

# Chargement de la librairie ggplot2
library(ggplot2)

# Création d'un data.frame contenant les coordonnées de la courbe de densité de l'âge des mères
df_dens_agedam <- as.data.frame(cbind(x = dens_agedam$x, y = dens_agedam$y))

# Création et affichage de l'histogramme de l'âge des mères
gg_hist_agedam <- ggplot(data = dfvaris_litter, aes(x = agedam)) + 
	ggtitle("Distribution de l'âge des mères") + 
	xlab("Age de la mère en années") + ylab("Densité") +
	geom_histogram(alpha = 0.4, breaks = h_agedam$breaks, aes(y = ..density..), colour = "black") +
	geom_vline(xintercept = mean(dfvaris_litter$agedam), colour = "red") +
	geom_density(alpha = 0.2) +
	geom_ribbon(data = subset(df_dens_agedam, x <= qrtle1), aes(x = x, ymax = y), ymin = 0, fill = "red", alpha = 0.3) +
	geom_ribbon(data = subset(df_dens_agedam, x >= qrtle3), aes(x = x, ymax = y), ymin = 0, fill = "red", alpha = 0.3)


# Distribution de l’âge des mères et des pères en fonction de l'espèce (voir onglet B du chapitre 3.2)

# Chargement des librairies ggplot2 et gridExtra
library(ggplot2)
library(gridExtra)

# Préparation d'une liste qui contiendra les graphiques à afficher
gg_hist_age_spe <- list()

# Création de l'histogramme de l'âge des mères pour les deux espèces
gg_hist_age_spe[[1]] <- ggplot(data = dfvaris_litter, aes(x = agedam)) + 
	ggtitle("") + xlab("Age de la mère en années") + ylab("Densité") +
	geom_histogram(alpha = 0.4, aes(y = ..density.., fill = species), bins = 15, color = "grey30") +
	geom_density(alpha = 0.2) +
	scale_fill_manual(values = c("#69b3a2", "#404080")) +
	facet_wrap(~ species) +
	theme(legend.position = "none")

# Création de l'histogramme de l'âge des pères pour les deux espèces
gg_hist_age_spe[[2]] <- ggplot(data = dfvaris_litter, aes(x = agesire)) + 
	ggtitle("") + xlab("Age du père en années") + ylab("Densité") +
	geom_histogram(alpha = 0.4, aes(y = ..density.., fill = species), bins = 10, color = "grey30") +
	geom_density(alpha = 0.2) +
	scale_fill_manual(values = c("#69b3a2", "#404080")) +
	facet_wrap(~ species) +
	theme(legend.position = "none")

# Organisation et affichage des quatre graphiques
do.call(grid.arrange, c(gg_hist_age_spe, nrow = 2))


# Distribution de l'âge des mères en fonction de l'espèce (voir onglet C du chapitre 3.2)

# Chargement des librairies ggplot2 et gridExtra
library(ggplot2)
library(gridExtra)

# Préparation d'une liste qui contiendra les graphiques à afficher
gg_bxplt_age_spe <- list()

# Création du boxplot de l'âge des mères en fonction de l'espèce
gg_bxplt_age_spe[[1]] <- ggplot(data = dfvaris_litter, aes(x = species, y = agedam)) +
	geom_boxplot(aes(fill = factor(species)), fill = c("#69b3a2", "#404080")) + guides(fill=FALSE) +
	xlab("") + ylab("Age de la mère")

# Création du boxplot de l'âge des pères en fonction de l'espèce
gg_bxplt_age_spe[[2]] <- ggplot(data=dfvaris_litter, aes(x = species, y = agesire)) + 
	geom_boxplot(aes(fill = factor(species)), fill = c("#69b3a2", "#404080")) + guides(fill=FALSE) +
	xlab("") + ylab("Age du père")

# Organisation et affichage des quatre graphiques
do.call(grid.arrange, c(gg_bxplt_age_spe, ncol = 2))


# Distribution de la taille des portées en fonction de l'espèce (voir onglet D du chapitre 3.2)

# Chargement des librairies ggplot2 et gridExtra
library(ggplot2)

# Création du boxplot de la taille des portées en fonction de l'espèce
(gg_bxplt_ls_spe <- ggplot(dfvaris_litter, aes(x = species, y = littersizebirth)) + 
	xlab("") + ylab("Taille de la portée") +
	geom_boxplot(fill = c("#69b3a2", "#404080")))

# Création du 'violin plot' de la taille des portées en fonction de l'espèce
(gg_violin_ls_spe <- ggplot(dfvaris_litter, aes(x = species, y = littersizebirth, fill = species)) + 
	xlab("") + ylab("Taille de la portée") +
	geom_violin(alpha = 0.2) +
	scale_fill_manual(values = c("#69b3a2", "#404080")))

# A
library(ggplot2)
library(dplyr)

load("data_varis/dfvaris_litter.Rdata")

z <- dfvaris_litter %>%
	group_by(agedam, species) %>%
	summarize(meansire=mean(agesire))
levels(z$species) <- c(17, 16)
z$species <- as.numeric(levels(z$species))[z$species]
eq <- lm(dfvaris_litter$agesire ~ dfvaris_litter$agedam)$coefficients %>%
	round(2)
# https://stackoverflow.com/questions/7549694/add-regression-line-equation-and-r2-on-graph
dfvaris_litter %>%
	ggplot(aes(agedam, agesire, shape=species)) +
	geom_point(size=1.5, alpha=0.7) +
	scale_shape_manual(values=c(2, 1)) +
	geom_point(data=z, aes(agedam, meansire, shape=species),
		inherit.aes=FALSE, shape=z$species, color="black", size=3) +
	geom_smooth(aes(agedam, agesire),
		method="lm", se=FALSE,
		inherit.aes=FALSE, color="darkgreen", size=0.75) +
	geom_text(x=max(dfvaris_litter$agesire)/1.5, y=max(dfvaris_litter$agedam) / 2, label=paste("Y = ", eq[1], "+ X *", eq[2]),
		inherit.aes=FALSE, color="darkgreen", size=5) +
	geom_line(aes(agedam, agedam),
		inherit.aes=FALSE, linetype="dotted", alpha=0.8, size=0.75) +
	xlab("Age de la mère (années)") +
	ylab("Age du père (années)") +
	ggtitle(label="Relation entre l'âge du père et l'âge de la mère chez les varis.",
		subtitle="Les femelles ont favorisé les accouplements avec des mâles plus jeunes qu'elles") +
	theme(legend.title=element_blank(), legend.position=c(.93, .955),
		legend.justification="top")
