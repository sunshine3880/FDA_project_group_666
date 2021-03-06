## This is the R code for FDA.
> library(readxl)
> library(timeDate)
> library(timeSeries)
> data <- read_excel("~/qq/data.xlsx")
> head(data)
    v1 v2 v3    v4   v5
1 1975  1  1 25.25 9.43
2 1975  2  1 25.29 9.11
3 1975  3  1 25.36 8.90
4 1975  4  1 25.40 8.82
5 1975  5  1 25.48 8.91
6 1975  6  1 25.46 8.89
> hpi=data$v4; mort=data$v5； 
> plot(hpi,type='l',col="red");
> par(new=TRUE);
> plot(mort,type='l',col="blue"); ## plot the data of hpi and mort in one picture
> y1=hpi[100:380]; x1=mort[100:380];
> plot(y1,type='l',col="red");
> par(new=TRUE);
> plot(x1,type='l',col="blue");   ## plot the data of hpi and mort without putliar in one picture  
> acf(hpi)   ## Indicates strong serial correlations (unit root)
> dhpi=diff(hpi)  ## Working on differenced data for seasonal adjustion
> acf(dhpi)
> m1=ar(dhpi,method="mle")
> m1$order
[1] 12
> t.test(dhpi)

	One Sample t-test

data:  dhpi
t = 8.6791, df = 499, p-value < 2.2e-16
alternative hypothesis: true mean is not equal to 0
95 percent confidence interval:
 0.2460435 0.3900365
sample estimates:
mean of x 
  0.31804 

> m2=arima(hpi,order=c(12,1,0))  ## we try AR(1) model with hpi being differentiate for once
> m2

Call:
arima(x = hpi, order = c(12, 1, 0))

Coefficients:
         ar1      ar2      ar3     ar4      ar5      ar6     ar7     ar8      ar9
      1.2343  -0.2827  -0.3300  0.3316  -0.0762  -0.1727  0.1563  0.0020  -0.0972
s.e.  0.0434   0.0687   0.0696  0.0710   0.0725   0.0725  0.0724  0.0729   0.0713
        ar10    ar11     ar12
      0.1159  0.3202  -0.2325
s.e.  0.0698  0.0689   0.0436

sigma^2 estimated as 0.04963:  log likelihood = 38.27,  aic = -50.54
> tsdiag(m2,gof=24)
> m3=arima(hpi,order = c(0,1,12))  ## we try MA(1) model with hpi being differentiate for once
> m3

Call:
arima(x = hpi, order = c(0, 1, 12))

Coefficients:
         ma1     ma2     ma3     ma4      ma5      ma6      ma7     ma8
      1.4624  1.5468  0.9097  0.2230  -0.3856  -0.5987  -0.2677  0.4097
s.e.  0.0463  0.0829  0.1111  0.1327   0.1348   0.1105   0.0828  0.0745
         ma9    ma10    ma11    ma12
      0.9889  1.0300  0.6967  0.3537
s.e.  0.1083  0.1326  0.0939  0.0439

sigma^2 estimated as 0.06846:  log likelihood = -42.29,  aic = 110.58

> tsdhpi=ts(dhpi)
> auto.arima(tsdhpi)
Series: tsdhpi 
ARIMA(5,0,4) with non-zero mean 

Coefficients:
          ar1      ar2     ar3      ar4      ar5     ma1     ma2     ma3
      -0.2278  -0.0519  0.6993  -0.0264  -0.1985  1.7173  2.1132  1.1465
s.e.   0.1003   0.0833  0.0668   0.0861   0.0776  0.0979  0.1577  0.1502
         ma4    mean
      0.4051  0.3143
s.e.  0.0818  0.0919

sigma^2 estimated as 0.06933:  log likelihood=-39.09
AIC=100.18   AICc=100.72   BIC=146.54
> m4=arima(hpi,order = c(5,1,4))
> m4

Call:
arima(x = hpi, order = c(5, 1, 4))

Coefficients:
          ar1      ar2     ar3     ar4      ar5     ma1     ma2     ma3
      -0.2191  -0.0476  0.7262  0.0043  -0.1634  1.7278  2.1454  1.1841
s.e.   0.1095   0.0829  0.0678  0.0886   0.0760  0.1066  0.1708  0.1561
         ma4
      0.4289
s.e.  0.0874

sigma^2 estimated as 0.0693:  log likelihood = -44.05,  aic = 108.09
> Box.test(m4$residuals)

	Box-Pierce test

data:  m4$residuals
X-squared = 0.34351, df = 1, p-value = 0.5578

> pp=1-pchisq(0.34,12)
> pp
[1] 1

## above results are not as good as the ARIMA(5,1,4) model.

acf(mort)
plot(mort,type='l') ## Indicates strong serial correlations (unit root)  

> y=hpi[2:500]; x=mort[2:500];
> n1=lm(y~x)
> n1

Call:
lm(formula = y ~ x)

Coefficients:
(Intercept)            x  
     193.19       -11.48  

> summary(n1)

Call:
lm(formula = y ~ x)

Residuals:
   Min     1Q Median     3Q    Max 
-66.44 -18.44   0.08  16.45  68.85 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 193.1870     3.7381   51.68   <2e-16 ***
x           -11.4821     0.4187  -27.42   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 30.46 on 497 degrees of freedom
Multiple R-squared:  0.6021,	Adjusted R-squared:  0.6013 
F-statistic: 752.1 on 1 and 497 DF,  p-value: < 2.2e-16

> acf(n1$residuals)
> pacf(n1$residuals)  ### <== First two lags are significant
> m5=arima(hpi,order=c(2,0,0),include.mean=F,xreg=mort)
> m5

Call:
arima(x = hpi, order = c(2, 0, 0), xreg = mort, include.mean = F)

Coefficients:
         ar1      ar2   mort
      1.4729  -0.6005  0.0748
s.e.  0.0356   0.0356  0.0340

sigma^2 estimated as 0.07448:  log likelihood = -61.54,  aic = 131.08
> tsdiag(m5,gof=24)


> dmort=diff(mort)
> length(dmort)
[1] 500
> y=dhpi[2:500]; x=dmort[1:499];
> n2=lm(y~x)
> n2

Call:
lm(formula = y ~ x)

Coefficients:
(Intercept)            x  
     0.3219       0.2753  

> summary(n2)

Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.8216 -0.2826 -0.0219  0.2232  2.6871 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.32190    0.03661   8.794   <2e-16 ***
x            0.27533    0.12558   2.193   0.0288 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.817 on 497 degrees of freedom
Multiple R-squared:  0.00958,	Adjusted R-squared:  0.007587 
F-statistic: 4.807 on 1 and 497 DF,  p-value: 0.0288

> acf(n2$residuals)
> pacf(n2$residuals)  ### <== First two lags are significant
> m6=arima(dhpi,order=c(2,0,0),include.mean=F,xreg=dmort)  
> m6

Call:
arima(x = dhpi, order = c(2, 0, 0), xreg = dmort, include.mean = F)

Coefficients:
         ar1      ar2   dmort
      1.4729  -0.6005  0.0748
s.e.  0.0356   0.0356  0.0340

sigma^2 estimated as 0.07448:  log likelihood = -61.54,  aic = 131.08
> tsdiag(m6,gof=24)

> dim(data)
[1] 501   5
> idx=c(1:501)[data[,1]==2007]
> idx
 [1] 385 386 387 388 389 390 391 392 393 394 395 396
> source("backtest.R")
> backtest(m6,dhpi,384,1,inc.mean = F,xre=dmort)
[1] "RMSE of out-of-sample forecasts"
[1] 0.515049
[1] "Mean absolute error of out-of-sample forecasts"
[1] 0.3533172
### arch model
> acf(hpi^2)
> acf(dhpi^2)
> pacf(dhpi^2)
> source("archtest.R")
> m7=archTest(dhpi,2)
> m7

Call:
lm(formula = atsq ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.8685 -0.1381 -0.1188 -0.0560  5.7094 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.12633    0.03761   3.359 0.000843 ***
x1           1.16821    0.04200  27.815  < 2e-16 ***
x2          -0.35628    0.04200  -8.483 2.55e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.7709 on 495 degrees of freedom
Multiple R-squared:  0.7746,	Adjusted R-squared:  0.7737 
F-statistic: 850.7 on 2 and 495 DF,  p-value: < 2.2e-16
