#DS04 Exploratory Data Analysis Project 1.2

# utility function
InstallIfNeeded <- function(pkg)  {
 if (!require(pkg, character.only = TRUE)) {
     install.packages(pkg)
     if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
 }
}

# install/load libraries as necessary
InstallIfNeeded("dplyr")
InstallIfNeeded("ggplot2")
InstallIfNeeded("lattice")

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

# Filter to relevant data via dplyr
pc <- filter(powerconsumption, (Date=="1/2/2007"|Date=="2/2/2007"))

# Save memory
#rm(powerconsumption)

#Convert dates to POSIX
pc$Date  <- as.POSIXlt(paste(as.Date(pc$Date,format="%d/%m/%Y"), pc$Time, sep=" "))

#Create plot on screen. Axis labels (cex.lab) and axis text (cex.axis) appear to be smaller than default, so I've used 0.9 as a scaling factor.
#plot(pc$Date,pc$Sub_metering_1,col="black", type="l", xlab= "", ylab="Energy sub metering", cex.lab=0.9,cex.axis=0.9)
#points(pc$Date,pc$Sub_metering_2,col="red",type="l")
#points(pc$Date,pc$Sub_metering_3,col="blue",type="l")
#legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),col=c("Black","Red","Blue"),lwd=1,cex=0.9)

## Create plot and send to a file (no plot appears on screen)
png(file = "plot3.png",width = 480, height = 480)  ## Open PNG device

plot(pc$Date,pc$Sub_metering_1,col="black", type="l", xlab= "", ylab="Energy sub metering", cex.lab=0.9,cex.axis=0.9)
points(pc$Date,pc$Sub_metering_2,col="red",type="l")
points(pc$Date,pc$Sub_metering_3,col="blue",type="l")
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),col=c("Black","Red","Blue"),lwd=1,cex=0.9)

dev.off()  ## Close the PNGF file device
