
# create temporary empty file
temp <- tempfile()

# downloads zip and assigns to tempfile

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

# reads data

classes <- c("character", "character", rep("numeric", 7))
data <- read.table(unz(temp, unzip(temp, list=TRUE)[1]), # lee directamente el único archivo sea el que sea
                   sep=";", colClasses=classes, na.strings="?", header=TRUE) 

# removes temp file

unlink(temp)


# converts first column to class Date

data$Date <- as.Date(data$Date, "%d/%m/%Y")

# keep only 2007-02-01 and 2007-02-02 dates

data1 <- data[data$Date=="2007-02-01"|data$Date=="2007-02-02",]

# removes original data set to save space

rm(data)

# plot 1 from the assignment
png("plot1.png")
with(data1, hist(Global_active_power, col="red",
                 main = "Global Active Power",
                 xlab="Global Active Power (kilowatts)",
                 ylab = "Frequency"))

dev.off()
