# Install and load library
library(arules)

# Sample transaction data
data("Groceries")

# Inspect data
summary(Groceries)

# Apply Apriori
rules <- apriori(Groceries,
                 parameter = list(support = 0.01,
                                  confidence = 0.5))

# Display rules
inspect(rules[1:10])

# Sort by confidence
rules_sorted <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules_sorted[1:5])