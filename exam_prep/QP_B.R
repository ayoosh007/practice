# =========================================================
# QP B
# =========================================================


# =========================================================
# QUESTION 1
# Multiple Linear Regression
# =========================================================

# Load data
Y <- c(
  10.5, 15.0, 18.7, 30.2, 44.8,
  48.9, 51.5, 61.5, 100.4
)

X1 <- c(
  2.0, 3.5, 4.0, 5.5, 7.0,
  8.5, 9.0, 10.0, 12.0
)

X2 <- c(
  1.5, 2.0, 2.5, 3.0, 3.5,
  4.0, 4.2, 4.5, 5.0
)

data <- data.frame(Y, X1, X2)

print(data)


# (a) Fit multiple linear regression model
model <- lm(Y ~ X1 + X2, data = data)

summary(model)


# (b) Find regression coefficients
coefficients <- coef(model)

print(coefficients)


# (c) Three-dimensional scatter plot and regression plane

# Run this once if scatterplot3d is not installed:
# install.packages("scatterplot3d")

library(scatterplot3d)

graph <- scatterplot3d(
  X1,
  X2,
  Y,
  pch = 19,
  main = "CPU Execution Time Regression",
  xlab = "Cache Size (MB)",
  ylab = "Clock Speed (GHz)",
  zlab = "Execution Time (ms)"
)

# Add fitted regression plane
graph$plane3d(
  model,
  draw_polygon = TRUE,
  draw_lines = TRUE
)


# (d) Predict execution time
# Cache Size = 6 MB
# Clock Speed = 3.2 GHz

new_data <- data.frame(
  X1 = 6,
  X2 = 3.2
)

prediction <- predict(
  model,
  newdata = new_data
)

print(prediction)



# =========================================================
# QUESTION 2
# Poisson Distribution
# Average requests = 8 per minute
# =========================================================

lambda <- 8


# (a) Probability of exactly 5 requests
p_exactly_5 <- dpois(
  5,
  lambda = lambda
)

print(p_exactly_5)


# (b) Probability of at most 6 requests
p_at_most_6 <- ppois(
  6,
  lambda = lambda
)

print(p_at_most_6)


# (c) Probability of more than 10 requests
p_more_10 <- 1 - ppois(
  10,
  lambda = lambda
)

print(p_more_10)


# (d) Generate 1000 simulated values
set.seed(123)

simulated_requests <- rpois(
  1000,
  lambda = lambda
)

# Display first few simulated values
head(simulated_requests)


# Simulated distribution
simulated_prob <- prop.table(
  table(simulated_requests)
)

print(simulated_prob)


# Theoretical Poisson probabilities
x <- 0:20

theoretical_prob <- dpois(
  x,
  lambda = lambda
)

print(theoretical_prob)


# Plot theoretical Poisson distribution
barplot(
  theoretical_prob,
  names.arg = x,
  main = "Poisson Distribution",
  xlab = "Number of Requests",
  ylab = "Probability"
)


# Compare simulated and theoretical probabilities

simulated_values <- sapply(
  x,
  function(k) {
    mean(simulated_requests == k)
  }
)

comparison <- data.frame(
  Requests = x,
  Theoretical = theoretical_prob,
  Simulated = simulated_values
)

print(comparison)


# Plot comparison
matplot(
  x,
  cbind(theoretical_prob, simulated_values),
  type = "b",
  pch = c(19, 17),
  lty = 1,
  xlab = "Number of Requests",
  ylab = "Probability",
  main = "Theoretical vs Simulated Poisson Distribution"
)

legend(
  "topright",
  legend = c("Theoretical", "Simulated"),
  pch = c(19, 17),
  lty = 1
)
