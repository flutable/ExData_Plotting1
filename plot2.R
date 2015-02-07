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

# Read data
fn <- "household_power_consumption.txt"
if (!file.exists(fn)) {
    powerconsumption <- read.table(fn,header = TRUE,sep=";",na.strings="?",stringsAsFactors=FALSE)
}

# Filter to relevant data via dplyr
pc <- filter(powerconsumption, (Date=="1/2/2007"|Date=="2/2/2007"))

# Save memory
#rm(powerconsumption)

#Convert dates to POSIX
pc$Date  <- as.POSIXlt(paste(as.Date(pc$Date,format="%d/%m/%Y"), pc$Time, sep=" "))

#Create plot on screen
#plot(pc$Date,pc$Global_active_power,col="black", type="l", xlab= "", ylab="Global Active Power (kilowatts)") #gives a box plot unless dates are in POSIX format

## Create plot and send to a file (no plot appears on screen)
png(file = "plot2.png",width = 480, height = 480)  ## Open PNG device
plot(pc$Date,pc$Global_active_power,col="black", type="l", 
     xlab= "", ylab="Global Active Power (kilowatts)") #gives a box plot unless dates are in POSIX format
dev.off()  ## Close the PNGF file device
