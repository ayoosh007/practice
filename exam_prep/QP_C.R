# =========================================================
# QP C
# =========================================================


# =========================================================
# QUESTION 1
# Social Media Hours vs Exam Score
# =========================================================

# Load data
X <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

Y <- c(
  96, 89, 82, 76, 70,
  64, 57, 52, 46, 40
)

data <- data.frame(X, Y)

print(data)


# (a) Fit linear regression model
model <- lm(Y ~ X, data = data)

print(model)

summary(model)


# (b) Calculate correlation coefficient
correlation <- cor(X, Y)

print(correlation)


# (c) Predict exam score for 4.5 hours
new_data <- data.frame(
  X = 4.5
)

prediction <- predict(
  model,
  newdata = new_data
)

print(prediction)


# (d) Scatter plot with fitted regression line
plot(
  X,
  Y,
  main = "Social Media Hours vs Exam Score",
  xlab = "Hours Spent on Social Media",
  ylab = "Exam Score",
  pch = 19
)

abline(
  model,
  col = "red",
  lwd = 2
)



# =========================================================
# QUESTION 2
# Binomial Distribution and Poisson Approximation
# =========================================================

n <- 200
p <- 0.03


# =========================================================
# BINOMIAL DISTRIBUTION
# =========================================================


# (a) Probability of at least 5 rejected transactions
# P(X >= 5)

binomial_at_least_5 <- 1 - pbinom(
  4,
  size = n,
  prob = p
)

print(binomial_at_least_5)


# (b) Probability of exactly 5 rejected transactions
binomial_exactly_5 <- dbinom(
  5,
  size = n,
  prob = p
)

print(binomial_exactly_5)


# (c) Probability of at most 5 rejected transactions
binomial_at_most_5 <- pbinom(
  5,
  size = n,
  prob = p
)

print(binomial_at_most_5)



# =========================================================
# POISSON APPROXIMATION
# =========================================================

# lambda = n * p
lambda <- n * p

print(lambda)


# At least 5
poisson_at_least_5 <- 1 - ppois(
  4,
  lambda = lambda
)

print(poisson_at_least_5)


# Exactly 5
poisson_exactly_5 <- dpois(
  5,
  lambda = lambda
)

print(poisson_exactly_5)


# At most 5
poisson_at_most_5 <- ppois(
  5,
  lambda = lambda
)

print(poisson_at_most_5)



# =========================================================
# Comparison Table
# =========================================================

comparison <- data.frame(
  Case = c(
    "At least 5",
    "Exactly 5",
    "At most 5"
  ),

  Binomial = c(
    binomial_at_least_5,
    binomial_exactly_5,
    binomial_at_most_5
  ),

  Poisson = c(
    poisson_at_least_5,
    poisson_exactly_5,
    poisson_at_most_5
  )
)

print(comparison)
