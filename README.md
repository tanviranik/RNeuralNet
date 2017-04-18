# RNeuralNet
R code for neural network

## How to?
Please execute the main.R file. The main.R file first tries to connect to MSSQL database to get the training dataset. I have encouneted lots of tutorials which reads from csv files or text files. But I have implemented MSSQL base connectivity to retrieve dataset from MSSQL database. 

```
Code for connecting to MSSQL database:
library(RODBC) 
conn = odbcDriverConnect('driver={SQL Server};server=192.168.100.139;database=NeuralNetwork;UID=sa;PWD=dataport')
dataset = sqlQuery(conn, 'Select * from NuralTestSet')
```

Next approach is to scale the training and test dataset. Because all the columns of the dataset are not scaled. Minimum and maximum of different columns may vary. So I have chosen min max scaling. 


```
Give examples
```

