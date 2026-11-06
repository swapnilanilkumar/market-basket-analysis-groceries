# Market Basket Analysis – Grocery Sales Data

**College Project | MCA – Data Mining Using R Lab | Tool: R (`arules` package)**

---

## 1. What is this project about?

When people shop at a grocery store, they buy several items together in one basket. This project looks at thousands of shopping baskets and finds **which items are often bought together**.

For example, if many customers who buy *curd and yogurt* also buy *whole milk*, a store can place these items near each other, or sell them as a bundle offer.

This type of study is called **Market Basket Analysis**. The method used here is called the **Apriori algorithm**, which finds item combinations that appear together again and again in the data.

**Business question answered:**
> Which grocery items are commonly bought together, and how strong is that connection?

---

## 2. About the data

| Detail | Value |
|---|---|
| Dataset name | `Groceries` |
| Source | Built-in sample dataset of the R package `arules` (no download needed) |
| What one row means | One customer's shopping basket |
| Number of baskets | **9,835** |
| Number of different items | **169** (such as milk, yogurt, bread, vegetables) |
| Average items per basket | about **4.4** items |
| Largest basket | **32** items |
| Most common basket size | **1 item** (2,159 baskets) |

### Most frequently bought items

These are the five most popular items in the data, taken from the output of the program:

| Rank | Item | Number of baskets it appears in |
|---|---|---|
| 1 | Whole milk | 2,513 |
| 2 | Other vegetables | 1,903 |
| 3 | Rolls / buns | 1,809 |
| 4 | Soda | 1,715 |
| 5 | Yogurt | 1,372 |

### Dataset summary output

![Dataset summary part 1](images/01_dataset_summary_part1.png)
![Dataset summary part 2](images/02_dataset_summary_part2.png)

**What this shows:** The data is stored as a table of baskets against items. Most baskets are small (the middle value is 3 items), so only a small part of the table is filled in. The program also lists the most popular items and how many baskets contain 1 item, 2 items and so on.

---

## 3. Steps followed

1. Install and load the `arules` package, which has the tools for this kind of analysis.
2. Load the `Groceries` dataset.
3. Look at the summary of the data (size, popular items, basket sizes).
4. Run the Apriori algorithm to generate rules of the form *"if a customer buys A, they also buy B"*.
5. View the first few rules.
6. Repeat with a stricter setting, then **sort the rules** so the strongest ones come first.

---

## 4. Understanding the terms (in simple words)

| Term | Meaning in simple words |
|---|---|
| **Rule** | A pattern like `{curd, yogurt} => {whole milk}`, meaning customers who buy curd and yogurt also tend to buy whole milk |
| **Support** | How often the items appear together out of all baskets. A support of 0.01 means about 1 in every 100 baskets |
| **Confidence** | When a customer buys the left side, how often they also buy the right side. 0.58 means about 58% of the time |
| **Lift** | Whether the items are bought together more than normal. A value **above 1** means the connection is real and stronger than coincidence |
| **Count** | The actual number of baskets that follow the rule |

---

## 5. Code and explanation

### Run 1 – Lower confidence (0.3) to see more rules
File: [`code/01_apriori_support0.01_confidence0.3.R`](code/01_apriori_support0.01_confidence0.3.R)

```r
library(arules)
data(Groceries)
summary(Groceries)
rules <- apriori(Groceries, parameter=list(supp=0.01, conf=0.3))
inspect(rules[1:5])
```

**Explanation:**
- `library(arules)` loads the package that contains the Apriori method.
- `data(Groceries)` loads the grocery baskets dataset.
- `summary(Groceries)` prints the dataset size, popular items and basket sizes.
- `apriori(...)` finds the rules. `supp=0.01` keeps only item combinations that appear in at least 1% of baskets (about 98 baskets). `conf=0.3` keeps only rules that hold true at least 30% of the time.
- `inspect(rules[1:5])` displays the first five rules.

### Run 2 – Higher confidence (0.5) and sorting the strongest rules
File: [`code/02_apriori_support0.01_confidence0.5_sorted.R`](code/02_apriori_support0.01_confidence0.5_sorted.R)

```r
library(arules)
data("Groceries")
summary(Groceries)

rules <- apriori(Groceries,
                 parameter = list(support = 0.01,
                                  confidence = 0.5))

inspect(rules[1:10])

rules_sorted <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules_sorted[1:5])
```

**Explanation:**
- The only change in the settings is `confidence = 0.5`, so only the stronger rules are kept.
- `inspect(rules[1:10])` shows the first ten rules found.
- `sort(rules, by = "confidence", decreasing = TRUE)` arranges the rules from the strongest to the weakest.
- `inspect(rules_sorted[1:5])` shows the top five strongest rules.

---

## 6. Output

### Run 1 output (confidence 0.3)

![Run 1 rules](images/03_apriori_run1_rules_confidence_0.3.png)

- The program checked **9,835 baskets** and **169 items**. After removing items that were too rare, **88 items** were left.
- It found **125 rules**.

First five rules from Run 1:

| # | If customer buys | Then also buys | Confidence | Lift | Baskets |
|---|---|---|---|---|---|
| 1 | Hard cheese | Whole milk | 0.41 | 1.61 | 99 |
| 2 | Butter milk | Other vegetables | 0.37 | 1.92 | 102 |
| 3 | Butter milk | Whole milk | 0.41 | 1.62 | 114 |
| 4 | Ham | Whole milk | 0.44 | 1.73 | 113 |
| 5 | Sliced cheese | Whole milk | 0.44 | 1.72 | 106 |

### Run 2 output (confidence 0.5)

![First 10 rules](images/04_apriori_run2_first_10_rules.png)

- With the stricter setting, only **15 rules** remained.

### Top 5 rules after sorting by confidence

![Top 5 sorted rules](images/05_top_5_rules_sorted_by_confidence.png)
![Top 5 counts](images/06_top_5_rules_counts.png)

| # | If customer buys | Then also buys | Confidence | Lift | Baskets |
|---|---|---|---|---|---|
| 1 | Citrus fruit, root vegetables | Other vegetables | 0.59 | 3.03 | 102 |
| 2 | Tropical fruit, root vegetables | Other vegetables | 0.58 | 3.02 | 121 |
| 3 | Curd, yogurt | Whole milk | 0.58 | 2.28 | 99 |
| 4 | Other vegetables, butter | Whole milk | 0.57 | 2.24 | 113 |
| 5 | Tropical fruit, root vegetables | Whole milk | 0.57 | 2.23 | 118 |

---

## 7. What I understood from the results

- **Whole milk and other vegetables appear on the right-hand side of almost every rule.** This matches the earlier summary, where they are the two most popular items, so they are often bought along with many other products.
- **Fruit and vegetables go together.** Customers who buy citrus fruit or tropical fruit along with root vegetables buy other vegetables in about 58–59% of cases. These rules also have the highest lift (about 3), meaning the link is much stronger than chance.
- **Dairy items go together.** Curd with yogurt, and butter with other vegetables, lead to whole milk in more than half of the baskets.
- **A stricter setting gives fewer but stronger rules.** Raising confidence from 0.3 to 0.5 reduced the rules from 125 to 15, so the remaining ones are the more reliable patterns.

### How a store could use this
- Place items from the same rule close together on shelves, such as dairy items near whole milk.
- Create bundle offers, such as a "fruit and vegetables" pack.
- Make sure popular items like whole milk are always in stock, since they are linked with many other purchases.

---

## 8. Limitations

- This is a **sample dataset used for learning**, so the findings show the method, not the habits of one real store.
- A rule shows that items are **bought together**. It does not prove that buying one item causes the other purchase.
- Only one support value (0.01) was used. Trying other values would find rarer but possibly interesting combinations.

---

## 9. How to run it yourself

1. Install R and RStudio.
2. Install the package: `install.packages("arules")`
3. Open either file from the `code/` folder in RStudio and click **Source**.

---

## 10. Project structure

```
market-basket-analysis-groceries/
├── README.md
├── code/
│   ├── 01_apriori_support0.01_confidence0.3.R
│   └── 02_apriori_support0.01_confidence0.5_sorted.R
└── images/
    └── (output screenshots)
```

---

**Tools used:** R, RStudio, `arules` package
**Author:** Swapnil Anilkumar
