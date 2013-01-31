lat.grad.movie = function(all.populations, time.step) {
  timeslices = seq(10,10000, by=time.step)

  max.rich = max(table(all.populations[all.populations$time.of.extinction > 30000,'region']))
  
  reg.rich.thru.time = data.frame(time=NA, region=NA, total.rich=NA)
  par(mfrow = c(1,1))
  for (t in timeslices) {
    
    all.pops = subset(all.populations, time.of.origin < t & time.of.extinction > t)
    all.reg.rich = data.frame(table(all.pops$region))
    names(all.reg.rich) = c('region','total.rich')
    all.reg.rich$region = as.numeric(as.character(all.reg.rich$region))

    plot(11 - all.reg.rich$region, log10(all.reg.rich$total.rich), type='b', lwd = 4, cex = .5, col = 'red',
                                         xlim = c(0,11), ylim=c(0, log10(max.rich)), xlab="Latitude",ylab = "log10 Species richness")
    text(10, log10(max.rich), paste("t =", t))
    
    reg.rich.thru.time = rbind(reg.rich.thru.time, cbind(time=rep(t,nrow(all.reg.rich)), all.reg.rich))
    for (i in 1:1000000) {}
  }

}