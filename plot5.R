#DS04 Exploratory Data Analysis Project 2, plot 5

# Q5 How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? 
#    A: They have decreased from approximately 350 tonnes/year to approximately 90 tonnes/year 

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

# What is a motor vehicle source? 
# I assume it is anything in EI.Sector starting with " On road" (leading space filters out "Non-road").
# See ftp://ftp.epa.gov/EmisInventory/2008v3/doc/scc_eissector_xwalk_2008neiv3.xlsx which shows equivalences (crosswalks) between
# SCCs and environmental inventory Sectors.

# Extract vehicle data using " on road" criterion
mvSCCindex <- grep(" On-road", SCC$EI.Sector, perl=TRUE, ignore.case=TRUE) # index vector
mvSCCdata <- SCC[mvSCCindex, ]                                             # use index to extract all data (can't seem to select just SCC$SCC, gives "invalid column error")

# Filter NEI to Baltimore area
NEIBalt <- filter(NEI,fips == "24510")

# Extract motor vehicle (mv) sources by matching SCCs
mvNEIBalt <- NEIBalt[NEIBalt$SCC %in% mvSCCdata$SCC, ]

# Group by year
mvNEIBaltGrp <- group_by(mvNEIBalt, year)   

# Summarise the emissions; summarise peels off a single layer of grouping
mvNEIBaltGrpSummary <- summarize(mvNEIBaltGrp,sum(Emissions))  

# Add nice names to the summary
names(mvNEIBaltGrpSummary) <- c("Year","TotalEmissions")

# Create plot
p <- ggplot(mvNEIBaltGrpSummary,aes(x=factor(Year),y=TotalEmissions)) +
		geom_bar(stat="identity", alpha=0.4) +
		xlab("Year") +
		ylab("Baltimore emissions (Sector: Mobile On-road)") #+
		stat_smooth(method=lm, formula=y~x, se=FALSE, size=1, linetype=1)
# Plot to screen
print(p)

# Plot to file
ggsave(filename="plot5.png", width=480/72, height=480/72,dpi=72)