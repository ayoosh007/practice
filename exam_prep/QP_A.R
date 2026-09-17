# =========================================================
# QP A
# =========================================================


# =========================================================
# QUESTION 1
# Linear Regression: Training Hours vs Productivity
# =========================================================

# Load data
X <- c(2, 4, 5, 6, 8, 9, 11, 12, 14, 15)
Y <- c(52, 58, 61, 65, 70, 73, 78, 81, 87, 91)

data <- data.frame(X, Y)

# View data
print(data)


# (a) Fit linear regression model
model <- lm(Y ~ X, data = data)

# Display regression model
print(model)

# Detailed summary
summary(model)

# Regression coefficients
coef(model)


# (b) Correlation coefficient
correlation <- cor(X, Y)

print(correlation)


# (c) Predict productivity score for 10 hours of training
new_data <- data.frame(X = 10)

prediction <- predict(model, newdata = new_data)

print(prediction)


# (d) Scatter plot with regression line
plot(
  X, Y,
  main = "Training Hours vs Productivity Score",
  xlab = "Hours of Training",
  ylab = "Productivity Score",
  pch = 19
)

abline(model, col = "red", lwd = 2)



# =========================================================
# QUESTION 2
# Normal Distribution
# Mean = 42
# Standard Deviation = 7
# =========================================================

mean_time <- 42
sd_time <- 7


# (a) Probability resolution time < 35 minutes
p_less_35 <- pnorm(
  35,
  mean = mean_time,
  sd = sd_time
)

print(p_less_35)


# (b) Probability resolution time > 50 minutes
p_more_50 <- 1 - pnorm(
  50,
  mean = mean_time,
  sd = sd_time
)

print(p_more_50)


# (c) Probability between 35 and 50 minutes
p_between <- pnorm(
  50,
  mean = mean_time,
  sd = sd_time
) - pnorm(
  35,
  mean = mean_time,
  sd = sd_time
)

print(p_between)


# (d) 90th percentile
p90 <- qnorm(
  0.90,
  mean = mean_time,
  sd = sd_time
)

print(p90)


# Plot Normal Distribution
x <- seq(
  mean_time - 4 * sd_time,
  mean_time + 4 * sd_time,
  length = 1000
)

y <- dnorm(
  x,
  mean = mean_time,
  sd = sd_time
)

plot(
  x, y,
  type = "l",
  lwd = 2,
  main = "Normal Distribution of Resolution Time",
  xlab = "Resolution Time (minutes)",
  ylab = "Density"
)

# Mark important values
abline(v = 35, col = "blue", lty = 2)
abline(v = 50, col = "green", lty = 2)
abline(v = p90, col = "red", lty = 2)

legend(
  "topright",
  legend = c("35 min", "50 min", "90th percentile"),
  col = c("blue", "green", "red"),
  lty = 2
)
