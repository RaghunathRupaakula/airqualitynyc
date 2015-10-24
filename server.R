## This r script receives the ambient temperature and wind speed as inputs from the ui.R script ##
## It then builds a machine learning algorithm to estimate the ozone (in ppb) present in the    ##
## atmosphere and applies it to the inputted temperature and wind speed. It then estimates the  ##
## air quality based on the estimated ozone by using a referance.                               ##


library(shiny)

## Receive inputs from ui.R, call the function airqltyozone to get the estimated ozone and air quality
## index and assign it to the output variables.
shinyServer(
  function(input, output) {
    
    ## Call the airqltyindx function by passing the user inputted temperature and wind speed to estimate
    ## the air quality index
   
     output$airqltyindx<-renderText(airqltyozone(input$temp,input$wind))
    
    
    ## Function to build machine algorithm on air quality dataset to estimate ozone and in turn the air
    ## quality index.
    
    airqltyozone<-function(Temp,Wind){
      library("datasets")
      library("randomForest")
      cleanairquality<-airquality
      
      ## Impute missing values for Ozone variable in the cleanairquality data frame
      for (i in 1:12) {
        
        if(length(cleanairquality[is.na(airquality$Ozone) & airquality$Month==i,]$Ozone)>0) {
          
          cleanairquality[is.na(airquality$Ozone) & airquality$Month==i,]$Ozone<-
            mean(cleanairquality[!is.na(airquality$Ozone) & airquality$Month==i,]$Ozone)
          
        }
        
      }
      
      ## Apply random forest machine learning algorithm to estimate ozone in atmosphere.
      library("caret")
      
      fit<-train(form=Ozone ~ Wind + Temp,data = cleanairquality,method="rf")
      test<-data.frame(Temp,Wind)
      ozoneppb<-as.numeric(predict(object = fit,newdata = test))
      ozone<-paste("The estimated amount of ozone present in the atmosphere is ",ozoneppb,".",sep = "")
      
      if(ozoneppb<=50)
      {
        airqltyindx<-as.character("The air quality is likely to be GOOD.")
      }
      else 
      {
        if(ozoneppb>50 & ozoneppb<=100)
        {
          airqltyindx<-as.character("The air quality is likely to be MODERATE.")
        }
        
        else
        {
          airqltyindx<-as.character("The air quality is likely to be UNHEALTHY.")
        }
      }
      return(paste(ozone,airqltyindx,sep=""))
      
      }
    }
)