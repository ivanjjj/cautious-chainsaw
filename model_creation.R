## https://www.kaggle.com/anthonypino/melbourne-housing-market

## Load Libraries
library(dplyr)
library(caret)

## Load data set
melbourne_house_prices <- read.csv("Melbourne_housing_FULL.csv")

## Clean data
melbourne_house_prices$Type <- gsub('\\<h\\>', 'House', melbourne_house_prices$Type)
melbourne_house_prices$Type <- gsub('\\<t\\>', 'Town House', melbourne_house_prices$Type)
melbourne_house_prices$Type <- gsub('\\<u\\>', 'Unit', melbourne_house_prices$Type)

melbourne_house_prices$Distance <- as.numeric(melbourne_house_prices$Distance)
melbourne_house_prices$Type <- as.factor(melbourne_house_prices$Type)
melbourne_house_prices$Regionname <- as.factor(melbourne_house_prices$Regionname)

## Change price data from numeric to factor and include range in factor
melbourne_house_prices$Price <- melbourne_house_prices$Price / 1000

label_interval <- function(breaks) {
  paste0("$", breaks[1:length(breaks) - 1], "k-$", breaks[2:length(breaks)], "k")
}

my_breaks <- c(seq(0,2000, by=200), seq(3000, 5000, by=1000), 20000)

melbourne_house_prices <- melbourne_house_prices %>% mutate(
    Price = cut(Price,
                    breaks = my_breaks,
                    labels = label_interval(my_breaks))
    )

## Select required columns

m_house_prices <- melbourne_house_prices %>%
  select(Regionname, Type, Distance, Price) %>%
  filter(!is.na(Price), !is.na(Distance), Regionname != "#N/A")

## Remove price ranges not used

m_house_prices$Price <- droplevels(m_house_prices$Price)
m_house_prices$Regionname <- droplevels(m_house_prices$Regionname)

## Split data into training and testing sets

inTrain <- createDataPartition(m_house_prices$Price, p=0.7, list=FALSE)
training <- m_house_prices[inTrain,]
testing <- m_house_prices[-inTrain,]

## Create model

fit <- train(Price~., method="rpart", data=training)

## Save choices to file and table of house prices
Regionname_choices <- levels(m_house_prices$Regionname)
type_choices <- levels(m_house_prices$Type)

write.csv(Regionname_choices, file = "Regionname_choices.csv")
write.csv(type_choices, file = "type_choices.csv")

write.csv(data.frame(table(m_house_prices$Regionname,
                           m_house_prices$Price)),
          file = "house_price_table.csv")
## Save model to file

saveRDS(fit, "fit.rds")
