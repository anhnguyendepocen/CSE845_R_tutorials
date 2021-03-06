
# When considering some of the assumptions of the general linear model, one common confusion is with respect to non-normality of the observed data (for the response variable). There is a common notion that the observed data needs to be normally distributed. That is, if the observed values of the response variable (our y) is not normally distributed, then we are violating one of the assumptions of this modelling technique, and our estimates or inferences may be biased. However this is actually not the issue. Instead the assumption is with regards to the residuals of the response variable, after the model fit. Mathematically this can be stated as:
# For each value of x, there exists in the population a normal distribution of y values.
# Or  resids ~ N(0, RSE).

# This has a very different meaning, and most often we DO NOT expect our distribution of Y to be normal.

# Here is one simple example of this. Let us say we are examining size measures between males and females from a certain species to determine the extent of sexual size dimorphism (SSD). We measure the length of 1000 males and 1000 females in the population.

males <- rnorm(1000, mean=165, sd=5)
females <- rnorm(1000, mean=180, sd=5)
complete_sample <- c(males, females)


# If there is in fact substantial sexual size dimorphism (relative to variation within the population), and we plot the distributions of size measures, we may see something like this:

par(mfrow=c(2,2))
hist(males,  breaks=20,  col="#ff00003c", xlab = "size")
hist(females,  breaks=20, col="#0000ff3c", xlab = "size")
hist(complete_sample, breaks=20, freq=T, col="#bebebe5c", xlab = "size")
# On one figure
hist(complete_sample, breaks=20, freq=T, col="#bebebe5c", xlab = "size", main="combined")
hist(males, add=T, breaks=20,  col="#ff00003c")
hist(females, add=T, breaks=20, col="#0000ff3c")

# While the distributions for males and females are each normally distributed, the distribution for the whole sample is not. This is not a problem for the general linear model as it easily accounts for these differences in "location" effects. That is, as long as we measured the appropriate explanatory variable (in this case that would simply be the sex of the organism), and included it in the model, we would be fine.



#  If we did not include it as an explanatory variable, and we fit a linear model without it, we would have an issue. For this example it means only estimating the population mean (intercept), and we would probably see some funky residuals...

lm_1 <- lm(complete_sample ~ 1)
par(mfrow=c(1,2))
plot(lm_1, which=2)
hist(resid(lm_1), breaks=20)


# But as soon as we fit the model with the explanatory variable

sex <- gl(n = 2, k = 1000, labels = c("males", "females")) # Generates 2 levels with 1000 observations each

lm_2 <- lm(complete_sample ~ sex)
par(mfrow=c(1,2))
plot(lm_2, which=2)
hist(resid(lm_2), breaks=20)



# This can often be the case even for observed response variables which relate quantitatively to the explanatory variable. Say for instance our response was cellular growth and our predictor was a nutrient (like glucose). Over the range of glucose we added the relationship could be nice and linear, and in this case we measure growth in five independent cultures for each concentration of glucose

glucose <- rep(seq(0,50, by=10), 5)
growth <- rnorm(length(glucose), mean = 0 + 0.4*glucose, sd =  3)
par(mfrow=c(1,2))
plot(growth ~ glucose)
hist(growth)

# But once we fit the model....
lm_growth <- lm(growth ~ glucose)
par(mfrow=c(1,2))
plot(lm_growth, which=2)
hist(resid(lm_growth))

# This issue extends to so-called "polynomial expansions" ( i.e. y ~ x + x^2). 
growth_2 <- rnorm(length(glucose), mean = 0 + 0.6*glucose - 0.013*I(glucose^2), sd =  2)
par(mfrow=c(1,2))
plot(growth_2 ~ glucose)
hist(growth_2)

# If we just fit the linear term of the model
lm_growth_linear <- lm(growth_2 ~ glucose)
par(mfrow=c(1,3))
plot(lm_growth_linear, which=c(1,2))
hist(resid(lm_growth_linear), main= "resid(growth_2), linear fit", breaks=5)

# Which may make us worry about the assumptions of normality. Of course the first panel from the figure above (residuals VS fitted) should give us a hint (if we somehow missed it with the plot of growth_2 VS glucose) that there may be a non-linear relationship between our response and explanatory variables, that perhaps can be approximated by fitting a quadratic term.

glucose_centered <- scale(glucose, center=T, scale=F)

lm_growth_quadratic <- lm(growth_2 ~ glucose_centered + I(glucose_centered^2))
par(mfrow=c(1,3))
plot(lm_growth_quadratic, which=c(1,2))
hist(resid(lm_growth_quadratic), main= "resid(growth_2), quadratic", breaks=5)

# Which is perhaps only a bit better with this set of simulations...


# However, when there are true (and complicated) non-linearities that can not be approximated by some transformations of the data, then there is a whole wide world of non-linear modeling, that is actually pretty straightforward to model (and we will discuss at length in ZOL851).