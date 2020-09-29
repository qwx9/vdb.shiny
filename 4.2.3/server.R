library(ggplot2)
library(dplyr)
library(tidyr)
load("../data_varis/dfvaris_litter.Rdata")
options(dplyr.summarise.inform=FALSE)

# FIXME:
# - title, description
# - 1 or 2 species at a time
# - 1 or 2 sexes at a time

shinyServer(function(input, output){
	output$hist <- renderPlot({
		df <- dfvaris_litter %>%
			filter(species == input$species) %>%
			select(species, agedam, agesire) %>%
			pivot_longer(c("agedam", "agesire"), "sex", values_to="age") %>%
			mutate(sex=recode(sex, agesire="male", agedam="female"))
		stats <- df %>%
			group_by(sex) %>%
			summarize(mean=mean(age))
		d <- lapply(unique(df$sex), function(s)
			df[df$sex==s,"age"] %>%
				pull %>%
				density %>%
				"["(c("x", "y")) %>%
				as.data.frame %>%
				mutate(sex=s)
		) %>%
			do.call(what="rbind")
		# do you feel it? DO YOU FEEL IT??
		d <- d %>%
			group_by(sex) %>%
			#do(.[.$x <= quantile(.$x, 0.25) | .$x > quantile(.$x, 0.75),]) %>%
			mutate(q1=x <= quantile(.$x, 0.25), q3=x > quantile(.$x, 0.75)) %>%
			ungroup %>%
			filter(q1 | q3)
		df %>%
			ggplot(aes(age)) +
			facet_wrap(~sex) +
			geom_density(alpha=0.2) +
			geom_histogram(aes(y=..density..),
				bins=30, color="black", alpha=0.4) +
			geom_vline(data=stats, aes(xintercept=mean), color="red") +
			geom_area(data=d[d$q1,], aes(x, y),
				fill="red", alpha=0.3) +
			geom_area(data=d[d$q3,], aes(x, y),
				fill="red", alpha=0.3) +
			ggtitle("Distribution de l'âge") + 
			xlab("Age en années") +
			ylab("Densité")
	})
})
