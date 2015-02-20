#DS04 Exploratory Data Analysis Project 2, plot 3

#Q3 Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen
#   decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? 
#   Use the ggplot2 plotting system to make a plot to answer this question
#   Increases: point (over the full interval 1999-2008) 
#   Decreases: Nonpoint, Non-road, onroad.

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

# Get only Baltimore
NEI3 <- filter(NEI,fips == "24510")

# Group the data
NEI3 <- group_by(NEI3, year, type)   #produces a 16x3 data frame

# Summarise the emissions; summarise peels off a single layer of grouping
summarydata <- summarize(NEI3,sum(Emissions))  

# Give the data nice names
names(summarydata) <- c("Year","Type","TotalEmissions")

# Plot to screen. 
#   factor(Year) means the x axis will show only the year values present in the summarised data, else it shows 1999, 2000, 2001 etc
#   Note that the geom_line's x-axis is "year" (line graphs need a numeric x-axis) which is why for each year, not for each bar in the graph
 p <- ggplot(summarydata, aes(x=factor(Year), y=TotalEmissions, fill=Type)) +                                # basic aesthetics
          geom_bar(position="dodge",stat="identity", alpha=0.4) +                                       # add the bars, change alpha so trendlines more visible
          xlab("Year") +                                                                                # add labels
          ylab("Total emissions (all sources)") +
          stat_smooth(method=lm, formula=y~x, aes(group=Type,col=Type),se=FALSE, size=1, linetype=1)    # add trendlines for each group, coloured by group

# see 2nd ggsave/rstudio issue for why we need a plot object when running in R studio
print(p)                                                                                                

# Plot to file using ggsave, and adjusting for dpi
ggsave(filename="plot3.png", width=480/72, height=480/72,dpi=72)

# ggsave, rstudio issues
# http://stackoverflow.com/questions/16472935/ggplot2-ggsave-function-causes-graphics-device-to-not-display-plots
# http://stackoverflow.com/questions/26643852/ggplot-plots-in-scripts-do-not-display-in-rstudio
