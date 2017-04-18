set.seed(500)
library(MASS)
library(neuralnet)

paste("My Working Directory:", getwd(), sep=" ");
current_dir = "D:\\Datascience\\Neural\\InteractiveR" ;
print(current_dir);
setwd(current_dir);

data = read.csv("TrainDataset.csv", header=FALSE, sep=",");
names(data) = c("L1", "L2", "L3", "P1", "P2", "P3", "Target")
data = data[-c(1),]
totalRows = nrow(data)
print(totalRows)

# data scaling within min and max for tarining data set
traindata = data[1:totalRows,]
traindata$L1 = as.numeric(traindata$L1)
head(traindata,5)
str(traindata)
sapply(traindata, class)


maxs = apply(traindata, 2, max)
mins = apply(traindata, 2, min)
scaled_data = as.data.frame(scale(traindata, center = mins, scale = maxs - mins))
totalrows = nrow(scaled_data);
traindata = scaled_data[1:totalrows,]
head(traindata,5)



# train neural network with training dataset
n = names(traindata)
f = as.formula(paste("Target ~", paste(n[!n %in% "Target"], collapse = " + ")))
print(f)
nn = neuralnet(f, data=traindata, hidden=c(5,3,3),err.fct="ce",linear.output=FALSE)

# plots the neural network as png file
png(filename = "output/dnn.png")
plot(nn, rep="best", radius = 0.1, arrow.length = 0.15)
dev.off()


