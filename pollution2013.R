# Create pollutant function to evaluate pollution for a specific location
# Data set is available from here:
# https://github.com/DataScienceSpecialization/courses/blob/master/09_DevelopingDataProducts/yhat/annual_all_2013.csv

d <- read.csv("annual_all_2013.csv")
sub <- subset(d, Parameter.Name %in% c("PM2.5 - Local Conditions", "Ozone")
              & Pollutant.Standard %in% c("Ozone 8-Hour 2008", "PM25 Annual 2006"),
              c(Longitude, Latitude, Parameter.Name, Arithmetic.Mean))

pollavg2013 <- aggregate(sub[, "Arithmetic.Mean"],
                     sub[, c("Longitude", "Latitude", "Parameter.Name")],
                     mean, na.rm = TRUE)
pollavg2013$Parameter.Name <- factor(pollavg2013$Parameter.Name, labels = c("ozone", "pm25"))
names(pollavg2013)[4] <- "level"

## Remove unneeded objects
rm(d, sub)

## Write function
monitors2013 <- data.matrix(pollavg2013[, c("Longitude", "Latitude")])

library(fields)

## Input is data frame with
## lon: longitude
## lat: latitude
## radius: Radius in miles for finding monitors2013

pollutant2013 <- function(df) {
    x <- data.matrix(df[, c("lon", "lat")])
    r <- df$radius
    d <- rdist.earth(monitors2013, x)
    use <- lapply(seq_len(ncol(d)), function(i) {
        which(d[, i] < r[i])
    })
    levels <- sapply(use, function(idx) {
        with(pollavg2013[idx, ], tapply(level, Parameter.Name, mean))
    })
    dlevel <- as.data.frame(t(levels))
    data.frame(df, dlevel)
}