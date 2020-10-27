train<-read.csv("train_dummy.csv")
hist(log(train$SalePrice))

Y = train$SalePrice

X = train
X$SalePrice<- NULL

#install.packages('devtools')
#devtools::install_url('https://github.com/catboost/catboost/releases/download/v0.24.2/catboost-R-Windows-0.24.2.tgz', INSTALL_opts = c("--no-multiarch"))


library(catboost)
train_pool <- catboost.load_pool(data=X,label=Y)
model<- catboost.train(train_pool,NULL,
                       params = list(loss_function = 'RMSE',
                                     iterations = 1200,
                                     metric_period = 10,
                                     depth = 12))
pool<-read.csv("test_dummy.csv")
pred=catboost.predict(model, 
                 catboost.load_pool(pool), 
                 verbose=FALSE,
                 ntree_start=0, 
                 ntree_end=0, 
                 thread_count=-1 )
df<- data.frame(Id=pool$Id,
                SalePrice=pred)
head(df)
write.csv(df,"cat_r.csv",row.names = FALSE)
