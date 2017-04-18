# RNeuralNet
R code for neural network

## How to?
Please execute the main.R file. The main.R file first tries to connect to MSSQL database to get the training dataset. I have encouneted lots of tutorials which reads from csv files or text files. But I have implemented MSSQL base connectivity to retrieve dataset from MSSQL database. 

```
#Code for connecting to MSSQL database:
library(RODBC) 
conn = odbcDriverConnect('driver={SQL Server};server=192.168.100.139;database=NeuralNetwork;UID=sa;PWD=dataport')
dataset = sqlQuery(conn, 'Select * from NuralTestSet')
```

Next approach is to scale the training and test dataset. Because all the columns of the dataset are not scaled. Minimum and maximum of different columns may vary. So I have chosen min max scaling. 

```
#Code for scaling
maxs = apply(dataset, 2, max)
mins = apply(dataset, 2, min)
scaled_data = as.data.frame(scale(dataset, center = mins, scale = maxs - mins))
#Prepare training dataset and test dataset from the scaled_date
```

Traing the neural network using the below codes
```
# train neural network with training dataset
n = names(traindata)
f = as.formula(paste("Target ~", paste(n[!n %in% "Target"], collapse = " + ")))
print(f)
nn = neuralnet(f, data=traindata, hidden=c(5,3,3),err.fct="ce",linear.output=FALSE)
```

Plot the neural network diagram or store it as a png file. These types of statistical images preserve clear visibility of the neural network model you are developing.  
```
# train neural network with training dataset
n = names(traindata)
f = as.formula(paste("Target ~", paste(n[!n %in% "Target"], collapse = " + ")))
print(f)
nn = neuralnet(f, data=traindata, hidden=c(5,3,3),err.fct="ce",linear.output=FALSE)
```

In order to predict the result from neural network, the corresponding code is:
```
# testing neural network with test dataset
predict = compute(nn, testdata[,1:6])
predict_result = predict$net.result * (max(traindata$Target)-min(traindata$Target))+min(traindata$Target)
predict_result = round(predict_result, 6)  #taking upto 6 digit after decimal
```
Finally the result output along with prediction has been inserted into MSSQL database. So this R codes deal with MSSQL database only. It reads data as training set from MSSQL database and again sends the prediction output back into MSSQL database.


