
library(arules)
data(Groceries)
summary(Groceries)
rules <- apriori(Groceries, parameter=list(supp=0.01, conf=0.3))
inspect(rules[1:5])

