#DS04 Exploratory Data Analysis Project 2, plot 4

# Q4 Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
#    A: From 1999, emissions decreased slightly in 2002 and 2005 but decreased considerably in 2008.

# utility function #Thanks StackOverflow!
InstallIfNeeded <- function(pkg)  {
 if (!require(pkg, character.only = TRUE)) {
     install.packages(pkg)
     if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
 }
}

# install/load libraries as necessary
InstallIfNeeded("dplyr")
InstallIfNeeded("ggplot2")

#-----Read data into current folder
fnPM25Emissions <- "summarySCC_PM25.rds"
fnSCCTable <- "Source_Classification_Code.rds"

if ( !file.exists(fnPM25Emissions ) | !file.exists(fnSCCTable) ) {
    message("Data file(s) missing, downloading....")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","exdata_data_NEI_data.zip")
    message("Unzipping data files...")
    unzip("exdata_data_NEI_data.zip")
}

#----- Only re-read variable if necessary   #NEI takes about 20 seconds to read
if (!exists("NEI")) {
    message("NEI missing, now reading...")
    NEI <- readRDS("summarySCC_PM25.rds")
} 
if (!exists("SCC")) {
    message("SCC missing, now reading...")
    SCC <- readRDS("Source_Classification_Code.rds")
} 

# find all instances of EI.Sector having both "coal" or "comb"(ustion) in them, returning a logical index vector
# Source: http://stackoverflow.com/questions/2219830/regular-expression-to-find-two-strings-anywhere-in-input
coalsources <- grepl("(coal(.|\n)*comb)|(comb(.|\n)*coal)", SCC$EI.Sector, perl=TRUE, ignore.case=TRUE) #logical vector


# Create a subset of SCC containing only the "coal" SCC codes
coalSCC <- subset(SCC,subset=coalsources)

# Create a subset of NEI with all fips (counties), and all SCCs in coalSCC
NEIallUSA <- filter(NEI,SCC %in% coalSCC$SCC)

# Group by year so we can see the trend
NEIallUSAgrp <- group_by(NEIallUSA,year)

# Summarize by year
summaryAllUSA <- summarize(NEIallUSAgrp,sum(Emissions))

# Give the result sensible names
names(summaryAllUSA) <- c("Year","TotalEmissions")

# Create plot
p <- ggplot(summaryAllUSA,aes(x=factor(Year),y=TotalEmissions)) +
        geom_bar(stat="identity") +
        xlab("Year") +
        ylab("Total emissions USA by sector (coal combustion)") 
print(p)

# Plot to file 
ggsave(filename="plot4.png", width=480/72, height=480/72,dpi=72)
