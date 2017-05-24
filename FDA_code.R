## This is the R code for FDA.
> library(readxl)
> data <- read_excel("~/qq/data.xlsx")
> hpi=data$v4; mort=data$V5
> plot(hpi,type='l')  
> acf(hpi)   ## Indicates strong serial correlations (unit root)
> acf(diff(hpi))
> m1=ar(diff(hpi),method="mle")
> m1$order
[1] 12
> t.test(diff(hpi))

	One Sample t-test

data:  diff(hpi)
t = 8.6791, df = 499, p-value < 2.2e-16   ## not significant
alternative hypothesis: true mean is not equal to 0
95 percent confidence interval:
 0.2460435 0.3900365
sample estimates:
mean of x 
  0.31804 

> m2=arima(hpi,order=c(12,1,0))
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
> m3=arima(hpi,order = c(0,1,12))
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


## above results are not as good as the ARIMA(12,1,0) model.
acf(hpi)
acf(mort)
plot(mort,type='l') ## Indicates strong serial correlations (unit root)  
dhpi=diff(hpi)  ## Working on differenced data 
acf(dhpi)
> m4

Call:
arima(x = dhpi, order = c(12, 0, 0), include.mean = F)

Coefficients:
         ar1      ar2      ar3     ar4      ar5      ar6     ar7     ar8      ar9
      1.2343  -0.2827  -0.3300  0.3316  -0.0762  -0.1727  0.1563  0.0020  -0.0972
s.e.  0.0434   0.0687   0.0696  0.0710   0.0725   0.0725  0.0724  0.0729   0.0713
        ar10    ar11     ar12
      0.1159  0.3202  -0.2325
s.e.  0.0698  0.0689   0.0436

sigma^2 estimated as 0.04963:  log likelihood = 38.27,  aic = -50.54

> dmort=diff(mort)
> length(dmort)
[1] 500
> y=dhpi[2:500]; x=dmort[1:499];
> n1=lm(y~x)
> n1

Call:
lm(formula = y ~ x)

Coefficients:
(Intercept)            x  
     0.3219       0.2753  

> summary(n1)

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
