# Function for looking at detailed clade level patterns for 6 example clades of different age
# The 'time.buffer' is the potential +/- variation (in time units) allowed in selecting clades of a specific age


clade.exmpl.figs = function(sim.results, reg.stats, clade.slices=6, seed=1) {
  require(caper)
  
  all.pops = sim.results$all.populations
  phylo.out = sim.results$phylo.out
  max.time = as.integer(max(all.pops$time.of.origin))
  sim.params = sim.results$params.out
  stats = reg.stats
 
  #Clade origin times (i.e. root distances)
  # --only focus on clades w/ at least 10 species for analysis
  rootdist = stats[stats$richness >= 10, c('clade.id','clade.origin.time')]
  
  if (nrow(rootdist) < 1) {
    stop("There are no clades with sufficient species for analysis")
  } else {
  clade.time.slices = round(seq(max.time/(clade.slices+1), max.time - max.time/(clade.slices+1),length.out=clade.slices),0)

  pdf(paste('clade_example_figs_sim',sim.params[1,1],'.pdf',sep=''),width=10,height=9)
  par(mfrow=c(3,3),oma = c(1,1,4,0),mar=c(4,4,1,1))
  
  for (c in 1:clade.slices) {
  
    #Choose a clade randomly from those that are closest to the specified clade time slice,
    #specifically those that are within 100 time units of the closest clade
    set.seed(seed)
    clade = sample(rootdist$clade.id[abs(rootdist$clade.origin.time - clade.time.slices[c]) < 
                                     (min(abs(rootdist$clade.origin.time - clade.time.slices[c]))+100)],1)
    cl.members = clade.members(which(phylo.out$tip.label==clade),phylo.out)
    cl.subset = subset(all.pops, spp.name %in% cl.members)
    cl.analysis = regional.calc(cl.subset[c('region','spp.name','time.of.origin','reg.env','extant')], phylo.out, max.time)
    
    attach(cl.analysis)
    if(length(unique(richness[!is.na(richness)])) > 2) {
      plot(richness~reg.env, xlab="Environment",ylab="Species Richness", cex=3, pch=16, col='darkblue',xlim=range(sim.results$all.populations$reg.env))
      legend("top",legend=paste('r =',round(cor(richness,reg.env,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Environment",ylab="Species Richness", type="n")
      text(1,1,"NA")
    }
    
    if(length(unique(MRD[!is.na(MRD)])) > 2) {
      plot(richness~MRD, xlab = "MRD", ylab="Species Richness", cex=3, pch=15, col = 'skyblue')
      legend("top",legend=paste('r =',round(cor(richness,MRD,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="MRD",ylab="Species Richness", type="n")
      text(1,1,"NA")
    }

    if(length(unique(PSV[!is.na(PSV)])) > 2) {
      plot(richness~PSV, xlab = "PSV", ylab="Species Richness", cex=3, pch=17, col = 'darkgreen')
      legend("top",legend=paste('r =',round(cor(richness,PSV,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="PSV",ylab="Species Richness", type="n")
      text(1,1,"NA")    
    }
    
    if(length(unique(richness[!is.na(richness)])) > 2) {
      plot(richness~time.in.region, xlab = "Time in Region", ylab="Species Richness", cex=3, pch=17, col = 'yellow3')
      legend("top",legend=paste('r =',round(cor(richness,time.in.region,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Time in Region",ylab="Species Richness", type="n")
      text(1,1,"NA")
    }
    
    if(length(unique(MRD[!is.na(MRD)])) > 2) {
      plot(MRD~reg.env, ylab = "MRD", xlab="Environment", cex=3, pch=18, col = 'orange',xlim=range(sim.results$all.populations$reg.env))
      legend("top",legend=paste('r =',round(cor(reg.env,MRD,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Environment",ylab="MRD", type="n")
      text(1,1,"NA")
    }
    
    if(length(unique(MRD[!is.na(MRD)])) > 2) {
      plot(PSV~reg.env, ylab = "PSV", xlab="Environment", cex=3, pch=15, col = 'darkred',xlim=range(sim.results$all.populations$reg.env))
      legend("top",legend=paste('r =',round(cor(reg.env,PSV,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Environment",ylab="PSV", type="n")
      text(1,1,"NA")
    }

    if(length(unique(richness[!is.na(richness)])) > 2) {
      plot(richness~extinction.rate, ylab = "Species Richness", xlab="Extinction Rate", cex=3, pch=16, col = 'purple3')
      legend("top",legend=paste('r =',round(cor(richness,extinction.rate,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Extinction Rate",ylab="Species Richness", type="n")
      text(1,1,"NA")
    }
    
    if(length(unique(extinction.rate[!is.na(extinction.rate)])) > 2) {
      plot(extinction.rate~region, ylab = "Extinction Rate", xlab="Region", cex=3, pch=18, col = 'pink')
      legend("top",legend=paste('r =',round(cor(region,extinction.rate,use="complete.obs"),2)), bty='n')
    } else {
      plot(1,1, xlab="Region",ylab="Extinction Rate", type="n")
      text(1,1,"NA")
    }
    
    if (sim.params$carry.cap=='on' & sim.params$energy.gradient=='on') {
      K.text = 'K gradient present'
    } else if (sim.params$carry.cap=='on' & sim.params$energy.gradient=='off') {
      K.text = 'K constant across regions'
    } else if (sim.params$carry.cap=='off') {
      K.text = 'no K'
    }
    mtext(paste('Sim',sim.params[1,1],', Origin =',sim.params[1,3],', w =',sim.params[1,4],', sigma =',sim.params[1,7],
                ',disp = ',sim.params[1,6],', specn =',sim.params[1,5],',',K.text),outer=T,line=2)
    
    mtext(paste("CladeID =",clade,"; Clade time of origin =", rootdist[rootdist$clade.id==clade,'time.of.origin'],"; Clade richness =",length(cl.members)),3,outer=T,line=.3)
    detach(cl.analysis)
  } #end clade loop
  dev.off()
} #end else

} #end function
