#DS04 Exploratory Data Analysis Project 

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


# Q1 Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#    A: They appear to have decreased from ~7.5Mt to ~ 3 Mt.
# NEI2 <- group_by(NEI,year)
# plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources (tonnes)",pch=20)
# 
# png(file = "plot1.png",width = 480, height = 480)  ## Open PNG device
# plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources (tonnes)",pch=20)
# dev.off()  ## Close the PNG file device

#Q2 Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#    A: Over that period, yes, though there was an increase in 2005.
# NEI2 <- group_by(NEI,year)
# NEI2 <- filter(NEI2,fips == "24510")
# plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources, Baltimore (tonnes)",pch=20)
# 
# png(file = "plot2.png", width = 480, height = 480)  
# plot(summarize(NEI2,sum(Emissions)), xlab="Year",ylab= "tonnes (t)", main="Total PM25 emissions, all sources, Baltimore (tonnes)",pch=20)
# dev.off()  

#Q3 Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen
#   decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? 
#   Use the ggplot2 plotting system to make a plot to answer this question
#   Increases: point (over the full interval 1999-2008) 
#   Decreases: Nonpoint, Non-road, onroad.

#Get only Baltimore
#NEI3 <- filter(NEI,fips == "24510")

#Group the data
#NEI3 <- group_by(NEI3, year, type)   #produces a 16x3 data frame

#Summarise the emissions; summarise peels off a single layer of grouping
#summarydata <- summarize(NEI3,sum(Emissions))  
#names(summarydata) <- c("Year","Type","TotalEmissions")

#Plot it. factor(Year) means the x axis will show only the year values present in the summarised data, else it shows 1999, 2000, 2001 etc
#   Note that the geom_line's x-axis is "year" (line graphs need a numeric x-axis) which is why for each year, not for each bar in the graph
# ggplot(summarydata,aes(x=factor(Year),y=TotalEmissions, fill=Type)) +
#          geom_bar(position="dodge",stat="identity", alpha=0.4) +
#          xlab("Year") +
#          ylab("Total emissions (all sources)") +
#          #geom_line(aes(x = as.numeric(factor(Year)), y = TotalEmissions,col=Type)) +
#          stat_smooth(method=lm, formula=y~x, aes(group=Type,col=Type),se=FALSE, size=1, linetype=1)    #add trendlines for each group, coloured by group
# ggsave(filename="plot3.png", width=480/72, height=480/72,dpi=72)


## Create plot and send to a file (no plot appears on screen)
#png(file = "plotx.png",width = 480, height = 480)  ## Open PNG device

#dev.off()  ## Close the PNG file device

# Q4 Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
#    A: From 1999, emissions decreased slightly in 2002 and 2005 but decreased considerably in 2008.

# find all instances of EI.Sector having both "coal" or "comb"(ustion) in them, returning a logical index vector
# Source: http://stackoverflow.com/questions/2219830/regular-expression-to-find-two-strings-anywhere-in-input
# coalsources <- grepl("(coal(.|\n)*comb)|(comb(.|\n)*coal)", SCC$EI.Sector, perl=TRUE, ignore.case=TRUE) #logical vector
# 
# 
# # Create a subset of SCC containing only the "coal" SCC codes
# coalSCC <- subset(SCC,subset=coalsources)
# 
# #Create a subset of NEI with all fips (counties), and all SCCs in coalSCC
# NEIallUSA <- filter(NEI,SCC %in% coalSCC$SCC)
# 
# #Group by year so we can see the trend
# NEIallUSAgrp <- group_by(NEIallUSA,year)
# 
# #Summarize by year
# summaryAllUSA <- summarize(NEIallUSAgrp,sum(Emissions))
# 
# #Give the result sensible names
# names(summaryAllUSA) <- c("Year","TotalEmissions")
# ggplot(summaryAllUSA,aes(x=factor(Year),y=TotalEmissions)) +
#     geom_bar(stat="identity") +
#     xlab("Year") +
#     ylab("Total emissions USA by sector (coal combustion)") 
# 
# ggsave(filename="plot4.png", width=480/72, height=480/72,dpi=72)

# Q5 How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 
#    A: THey have decreased by 

# What is a motor vehicle source? 
# I assume it is anything in EI.Sector starting with " On road" (leading space filters out "Non-road").
# See ftp://ftp.epa.gov/EmisInventory/2008v3/doc/scc_eissector_xwalk_2008neiv3.xlsx which shows equivalences (crosswalks) between
# SCCs and environmental inventory Sectors.
# mvSCCindex <- grep(" On-road", SCC$EI.Sector, perl=TRUE, ignore.case=TRUE) #index vector
# mvSCCdata <- SCC[mvSCCindex, ]                                    # can't seem to select just SCC$SCC, gives "invalid column error"
# 
# # Filter NEI to Baltimore area
# NEIBalt <- filter(NEI,fips == "24510")
# 
# mvNEIBalt <- NEIBalt[NEIBalt$SCC %in% mvSCCdata$SCC, ]
# 
# mvNEIBaltGrp <- group_by(mvNEIBalt, year)   
# 
# #Summarise the emissions; summarise peels off a single layer of grouping
# mvNEIBaltGrpSummary <- summarize(mvNEIBaltGrp,sum(Emissions))  
# 
# names(mvNEIBaltGrpSummary) <- c("Year","TotalEmissions")
# #Generate plot
# ggplot(mvNEIBaltGrpSummary,aes(x=factor(Year),y=TotalEmissions)) +
#     geom_bar(stat="identity", alpha=0.4) +
#     xlab("Year") +
#     ylab("Baltimore emissions (Sector: Mobile On-road)") #+
#    stat_smooth(method=lm, formula=y~x, se=FALSE, size=1, linetype=1)

# Q6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles 
# County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
mvSCCindex <- grep(" On-road", SCC$EI.Sector, perl=TRUE, ignore.case=TRUE) #index vector
mvSCCdata <- SCC[mvSCCindex, ]                                    # can't seem to select just SCC$SCC, gives "invalid column error"

# Filter NEI to Baltimore & LA counties
NEIBalt <- filter(NEI,fips == "24510")
NEILA   <- filter(NEI,fips == "06037")

# Extract the rows for each county that contain an "on-road" SCC
mvNEIBalt <- NEIBalt[NEIBalt$SCC %in% mvSCCdata$SCC, ]
mvNEILA   <- NEILA[NEILA$SCC     %in% mvSCCdata$SCC, ]

# Group the data by year
mvNEIBaltGrp <- group_by(mvNEIBalt, year)   
mvNEILAGrp   <- group_by(mvNEILA, year)   

# Summarise the emissions; summarise peels off a single layer of grouping
mvNEIBaltGrpSummary <- summarize(mvNEIBaltGrp,sum(Emissions))  
mvNEILAGrpSummary   <- summarize(mvNEILAGrp,  sum(Emissions))  

# Add nicer names to the summaries
names(mvNEIBaltGrpSummary) <- c("Year","Emissions")
names(mvNEILAGrpSummary)   <- c("Year","Emissions")

#Merge the summaries
mvSummary <- cbind(mvSummary, as.factor(rep(c("Baltimore","LA"),each=4)))
names(mvSummary) <- c("Year", "Emissions", "City")

#Generate plot - qplot
# qplot(Year,log10(Emissions,data=mvSummary, facets = . ~ City)    # vertical scales make it hard to compare

Generate plot - ggplot
ggplot(mvSummary,aes(x=factor(Year),y=Emissions,col=City)) + geom_line() +
    xlab("Emissions") +
    ylab("Balt/LA total emissions (Mobile On-road)") #+
    #stat_smooth(method=lm, formula=y~x, se=FALSE, size=1, linetype=1)
# ggplot(summarydata,aes(x=factor(Year),y=TotalEmissions, fill=Type)) +
#          geom_bar(position="dodge",stat="identity", alpha=0.4) +
#          xlab("Year") +
#          ylab("Total emissions (all sources)") +
#          #geom_line(aes(x = as.numeric(factor(Year)), y = TotalEmissions,col=Type)) +
#          stat_smooth(method=lm, formula=y~x, aes(group=Type,col=Type),se=FALSE, size=1, linetype=1)    #add trendlines for each group, coloured by group

# ggplot(mvSummary,aes(x=factor(Year),y=Balt,col="red")) +
#     geom_line(mvSummary,aes(x=factor(Year),y=LA,col="blue")) +
#     xlab("Year") +
#     ylab("Baltimore & LA total emissions (Sector: Mobile On-road)") 
#     #stat_smooth(method=lm, formula=y~x, se=FALSE, size=1, linetype=1)
