source("D:\\Datascience\\Neural\\InteractiveR\\NNPredict.R");

# data loading, scaling within min and max for test data set

library(RODBC) 
conn = odbcDriverConnect('driver={SQL Server};server=192.168.100.139;database=NeuralNetwork;UID=sa;PWD=dataport')
SourceTestData = sqlQuery(conn, 'Select * from NuralTestSet')
testdata = SourceTestData
names(testdata) = c("L1", "L2", "L3", "P1", "P2", "P3")
sapply(testdata, class)
head(testdata,10)

testdata$L1 = as.numeric(testdata$L1)
totalrows = nrow(testdata);
testdata = testdata[1:totalrows,];

#scaling test data
maxs = apply(testdata, 2, max)
mins = apply(testdata, 2, min)
scaled_data = as.data.frame(scale(testdata, center = mins, scale = maxs - mins))
totalrows = nrow(scaled_data);
testdata = scaled_data[1:totalrows,]
sapply(testdata, class)
head(testdata, 10)


# testing neural network with test dataset
predict = compute(nn, testdata[,1:6])
predict_result = predict$net.result * (max(traindata$Target)-min(traindata$Target))+min(traindata$Target)
predict_result = round(predict_result, 6)  #taking upto 6 digit after decimal
#testdata_actual_result = (testdata$Target)*(max(testdata$Target)-min(testdata$Target))+min(testdata$Target)
#MSE = sum((testdata_actual_result - predict_result)^2)/nrow(testdata)
#cat("Mean Square Error(MSE) = ", MSE);


#writing final output to csv and MSSQL database
colnames(predict_result) = c("Predicted_Output");

### Writing prediction with testdata into database
final_result = cbind(SourceTestData, predict_result);
#write.csv(final_result, "output/prediction.csv", row.names=FALSE);  #row.names=FALSE will avoid the extra serial number
sqlQuery(conn,"truncate table dbo.NeuralOutput_Prediction");
sqlSave(conn, final_result[,1:7], tablename = "NeuralOutput_Prediction", rownames = FALSE, colnames = FALSE, append = TRUE, fast = FALSE)


### Writing result matrix of predicted output into database
result_matrix = as.data.frame(nn$result.matrix)
result_matrix$names = rownames(result_matrix)
#write.csv(result_matrix, "output/result_matrix.csv")
sqlQuery(conn,"truncate table NeuralOutput_ResultMatrix");
sqlSave(conn, result_matrix, tablename = "NeuralOutput_ResultMatrix", rownames = FALSE, colnames = FALSE, append = TRUE, fast = FALSE)


### Writing each edge weight into database
weights = matrix(unlist(nn$weights), ncol = 4, byrow = TRUE)  #as nn$weights is a matrix, convert it first into dataframe
weights = as.data.frame(weights)
#write.csv(weights, "output/edge_weights.csv")
sqlQuery(conn,"truncate table NeuralOutput_EdgeWeight");
sqlSave(conn, weights, tablename = "NeuralOutput_EdgeWeight", rownames = FALSE, colnames = FALSE, append = TRUE, fast = FALSE)

close(conn)


