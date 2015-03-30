library(ggplot2)

eta2002 = function(Ca) {
  p1 = 0.1
  p2 = p1 * 1e-4
  p3 = 3
  p4 = 1
  
  tau = p1/(p2+Ca^p3) + p4
  return(1/tau)
}


x = seq(0,1,length=1001)   # Ca
y = eta2002(x)         # eta
data1 = data.frame(x,y)

ggplot(data=data1, aes(x=x, y=y)) +
  geom_line() +
  xlab(expression("[Ca"^"2+" ~ "]")) +
  ylab(expression(eta)) +
  theme_bw() +
  theme(panel.grid.minor=element_blank())
