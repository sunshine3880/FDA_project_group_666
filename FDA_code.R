## This is the R code for FDA.
> library(readxl)
Warning message:
程辑包‘readxl’是用R版本3.1.3 来建造的 
> data <- read_excel("~/qq/data.xlsx")
> hpi=data$v4; mort=data$v5
> plot(hpi,type='l')   ## Indicates strong serial correlations (unit root)
> acf(hpi)
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

> m1=arima(hpi,order=c(12,1,0))
> m1

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
