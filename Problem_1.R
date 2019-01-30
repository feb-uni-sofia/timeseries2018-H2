## Points 33

## Do not remove the following line, otherwise the automatic code check will fail.
install.packages('xts')

library(xts)


## a) Read data and create an xts object

gdp <- read.csv('https://s3.eu-central-1.amazonaws.com/sf-timeseries/data/gdp_bg_qrt_2000-2017.csv')
timeIndex <- as.yearqtr(gdp$Index, format = '%YQ%q')

gdpSeries <- xts(gdp$GDP, order.by = timeIndex)

## b)

plot(gdpSeries)

## The series show a trend. The GDP increases from 2001 to the end of 2008.
## After a drop in 2009 it continues to increase, although more slowly

## There is a visible seasonal pattern with quarterly GDP being much lower in
## the first quarter of the year.

## Because of the trend and the seasonal pattern the series does not appear to 
## be stationary


## c)

growthrateSeries <- diff(log(gdpSeries), 4)

## d)

plot(growthrateSeries)
## It seems that the growth rate time series do not follow any trend.

## e)

## Fit a couple of models, examine the residual
## diganostic plots and compare AIC

fit1 <- arima (growthrateSeries, order = c(1, 0, 0))
fit1
tsdiag(fit1)

fit2 <- arima (growthrateSeries, order = c(2, 0, 0))
fit2
tsdiag(fit2)

fit3 <- arima (growthrateSeries, order = c(3, 0, 0))
fit3
tsdiag(fit3)

fit4 <- arima (growthrateSeries, order = c(4, 0, 0))
fit4
tsdiag(fit4)

fit1$aic
fit2$aic
fit3$aic
fit4$aic

## The best AR model so far appears to be is AR4. Its AIC is the lowest compared to 0.

## f)
tsdiag(fit1)
tsdiag(fit2)
tsdiag(fit3)

tsdiag(fit4)

# The fit4 is adequate, because we can see from the ACF plot of the residuals that they don't have 
# autocorrelation between each other.

## g)

predictionQ42017 <- predict(fit4, n.ahead = 1)

## h) 

upperIntervalLimit <- predictionQ42017$pred + 2 * predictionQ42017$se
lowerIntervalLimit <- predictionQ42017$pred - 2 * predictionQ42017$se

## Print the interval

c(lowerIntervalLimit, upperIntervalLimit)
