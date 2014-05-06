
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

# plot 2 from the assignment

png("plot2.png")
with(data1, plot(datetime, Global_active_power, type="l",
                 xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()
