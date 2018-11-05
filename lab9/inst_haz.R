#Function to calculate instantaneous hazard using basehaz() output
instant_haz<-function(modelno, centered.TF="FALSE")
{
  if (centered.TF=="TRUE") cumhaz<-basehaz(modelno,centered=TRUE)
  if (centered.TF=="FALSE") cumhaz<-basehaz(modelno,centered=FALSE)

#Take the cumululative hazard and create variable for instantaneous hazard
cumhaz$delta<-rep(NA,dim(cumhaz)[1])

#Loop 1: Calculate delta hazards
for (i in 2:dim(cumhaz)[1]){
  cumhaz$delta[i]<-(cumhaz$hazard[i]-cumhaz$hazard[i-1])
  #basehaz() stacks baseline hazards for each strata in matrix
  #When use strata() term in coxph, need following command to appropriately calculate delta h
  if (dim(cumhaz)[2]==4) if (cumhaz$strata[i]!= cumhaz$strata[i-1]) cumhaz$delta[i]<-NA
}

#Remove all time points with no change in hazard
cumhaz2<-cumhaz[cumhaz$delta!=0 & is.na(cumhaz$delta)==F,]
cumhaz2$inst_haz<-rep(NA,dim(cumhaz2)[1])
cumhaz2$inst_haz[1]<-cumhaz2$delta[1]/cumhaz2$time[1]

#Loop 2: Calculate instantaneous hazard
for (j in 2:dim(cumhaz2)[1]){
    cumhaz2$inst_haz[j]<-cumhaz2$delta[j]/(cumhaz2$time[j]-cumhaz2$time[j-1])
    #See above note re: strata()
    if (dim(cumhaz2)[2]==5) if (cumhaz2$strata[j]!= cumhaz2$strata[j-1])
    cumhaz2$inst_haz[j]<-cumhaz2$delta[j]/cumhaz2$time[j]
}

#Change units from per day to per year
cumhaz2$inst_haz<-cumhaz2$inst_haz*365.25
cumhaz2$time<-cumhaz2$time/365.25
return(cumhaz2)
}
