# Load necessary libraries
library(ggplot2)

# Define the state values data as a data frame
state_values <- data.frame(
  State = c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", 
            "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", 
            "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", 
            "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", 
            "WI", "WV", "WY"),
  Value = c(0.691069, 0.630696, 0.573385, 0.734274, 1.616430, 1.019437, 0.829511, 
            1.457015, 0.756996, 1.031060, 0.886445, 1.788955, 0.622854, 0.735670, 
            0.974057, 0.666749, 0.602349, 0.649861, 0.671738, 1.437158, 1.076854, 
            0.819907, 0.785315, 0.910817, 0.687290, 0.573001, 0.731436, 0.755685, 
            0.620274, 0.611799, 0.953126, 1.335770, 0.553260, 0.769179, 1.659419, 
            0.728085, 0.667427, 0.967080, 0.851524, 1.333743, 0.749471, 0.581845, 
            0.771376, 0.798868, 0.852562, 0.973839, 0.927569, 1.197644, 0.807256, 
            0.571435, 0.518983)
)

# Set seed for reproducibility
set.seed(123)

# Define the Monte Carlo simulation function
monte_carlo_simulation <- function(state_values, num_simulations) {
  # Generate random samples
  random_samples <- sample(state_values$Value, size = num_simulations, replace = TRUE)
  
  # Define mean and standard deviation for the normal distribution
  mean_rent <- 955.96
  sd_rent <- 365
  
  # Simulate rent prices
  simulated_rent_prices <- rnorm(num_simulations, mean = mean_rent, sd = sd_rent) * random_samples
  
  return(simulated_rent_prices)
}

# Run the Monte Carlo simulation
num_simulations <- 10000
simulated_rent_prices <- monte_carlo_simulation(state_values, num_simulations)

# Run Execution Times
num_runs = 100
execution_times <- numeric(num_runs)
for (i in 1:num_runs){
  start_time <- Sys.time()
  simulated_rent_prices <- monte_carlo_simulation(state_values, num_simulations)
  end_time <- Sys.time()
  execution_time <- end_time - start_time
  execution_times[i] <- as.numeric(difftime(end_time, start_time, units="secs"))
}

# Print first simulated rent price
if (length(simulated_rent_prices) > 0) {
  print(paste("First simulated rent price:", round(simulated_rent_prices[1], 2)))
}

# Create a histogram of the simulated rent prices
ggplot(data.frame(Price = simulated_rent_prices), aes(x = Price)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Simulated Rent Prices", x = "Rent Price", y = "Frequency") +
  theme_minimal()

# Save the plot to a file
ggsave("histogram.png", width = 10, height = 5)

mean_time <- mean(execution_times)
std_time <- sd(execution_times)
max_time <- max(execution_times)

cat("Mean Execution Time:", mean_time, "seconds\n")
cat("Standard Deviation of Execution Time:", std_time, "seconds\n")
cat("Maximum Execution Time:", max_time, "seconds\n")
