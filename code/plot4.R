# install reshape2 (if not installed), then load it

if("reshape2" %in% rownames(installed.packages()) == FALSE) {
        install.packages("reshape2")
}

library(reshape2)

# create temporary empty file
temp <- tempfile()

# download zip and assigns to tempfile

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

# read data

classes <- c("character", "character", rep("numeric", 7))
data <- read.table(unz(temp, unzip(temp, list=TRUE)[1]), # lee directamente el único archivo sea el que sea
                   sep=";", colClasses=classes, na.strings="?", header=TRUE) 

# remove temp file

unlink(temp)


# convert first column to class Date

data$Date <- as.Date(data$Date, "%d/%m/%Y")

# keep only 2007-02-01 and 2007-02-02 dates

data1 <- data[data$Date=="2007-02-01"|data$Date=="2007-02-02",]

# remove original data set to save space

rm(data)

# create a new column of POSIXct class merging date and time

data1$datetime <- as.POSIXct(strptime(with(data1, paste(Date, Time)), format="%Y-%m-%d %H:%M:%S"))

# melt the data merging the Sub_metering variables

data2 <- melt(data1[,7:10], id="datetime")

# Draw four graphs in a single object, grouped in 2 X 2 

png("plot4.png")

# set graphic area

par(mfrow=c(2,2))

# 1st grapht, reuse plot 2 from the assignment

with(data1, plot(datetime, Global_active_power, type="l",
                 xlab="", ylab="Global Active Power"))

# second graph

with(data1, plot(datetime, Voltage, type="l"))

# 3d graph, reuse plot 3 from the assignment

plot(data2$datetime, data2$value, type="n", xlab="", ylab="Energy sub metering") ## initiate plot
points(data2[data2$variable=="Sub_metering_1",c(1,3)], type="l")                 ## add sub_metering_1 line
points(data2[data2$variable=="Sub_metering_2",c(1,3)], type="l", col="red")      ## add sub_metering_1 line
points(data2[data2$variable=="Sub_metering_3",c(1,3)], type="l", col="blue")     ## add sub_metering_1 line
legend("topright", legend=levels(data2$variable), col=c("black", "red", "blue"), lty=1, bty="n")  ## add legend

# fourth graph

with(data1, plot(datetime, Global_reactive_power, type="l"))

# close png file

dev.off()
