#DS04 Exploratory Data Analysis Project 1.1

# utility function
InstallIfNeeded <- function(pkg)  {
 if (!require(pkg, character.only = TRUE)) {
     install.packages(pkg)
     if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
 }
}

# install/load libraries as necessary
InstallIfNeeded("dplyr")

# Read data into current folder
fn <- "household_power_consumption.txt"
if (!file.exists(fn)) {
   download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                 "household_power_consumption.zip")
   unzip("household_power_consumption.zip")
}

#only re-read variable if necessary 
if (!exists("powerconsumption")) {
    powerconsumption <- read.table(fn,header = TRUE,sep=";",na.strings="?",stringsAsFactors=FALSE)
} 

# Filter to relevant data
pc <- filter(powerconsumption, (Date=="1/2/2007"|Date=="2/2/2007"))

# Save memory if necessary
#rm(powerconsumption)

#Create plot on screen
#hist(pc$Global_active_power,breaks=15,col="red",
#     xlab="Global Active Power (kilowatts)",
#     ylab="Frequency",
#     main="Global Active Power")

## Create plot and send to a file (no plot appears on screen)
png(file = "plot1.png",width = 480, height = 480)  ## Open PNG device

hist(pc$Global_active_power,breaks=15,col="red",
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency",
     main="Global Active Power")
dev.off()  ## Close the PNG file device
