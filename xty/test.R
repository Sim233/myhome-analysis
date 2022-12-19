mydata = read.csv("preprocess-data/jiayuan.csv")
times = mydata[,"time"]


getYear = function(x) {
  as.integer(substr(x,1,4))
}
getMonth = function(x) {
  as.integer(substr(x,6,7))
}
getDay = function(x) {
  as.integer(substr(x,9,10))
}
getDayIdByYear = function(x) {
  mds = c(31,28,31,30,31,30,31,31,30,31,30,31)
  month = getMonth(x); dateID = getDay(x);
  if (month > 1) {
    for (i in 1:(month-1)) {
      dateID = dateID + mds[i]
    }
  }
  return(dateID)
}
getDayId = function(x) {
  mds = c(31,28,31,30,31,30,31,31,30,31,30,31)
  year = getYear(x); month = getMonth(x); dateID = getDay(x);
  if (month > 1) {
    for (i in 1:(month-1)) {
      dateID = dateID + mds[i]
    }
  }
  dateID = dateID + (year - 2004) * 366
  return(dateID)
}

print(getDay(times[10000]))
print(getMonth(times[10000]))
print(getYear(times[10000]))
print(getDayId(times[10000]))
print(getDayIdByYear(times[10000]))

