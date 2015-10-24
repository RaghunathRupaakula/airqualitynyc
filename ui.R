### This r script builds an interface for the user to input ambient temperature and wind speeds in 
### New york city and calls the server.R to estimate the ozone present in the atmosphere and the
### air quality index.

library("shiny")

shinyUI(pageWithSidebar(
  
  h1("Air Quality Assessment for Newyork city based on ozone estimation",
     style="font-family:verdana; color:#8B0000; padding:5px; text-align:center"),
  
  sidebarPanel(
    h3('Input the ambient readings'),
    sliderInput('wind','Wind Speed (mph)',value = 0,min = 0,max = 25,step = 0.1),
    sliderInput('temp','Temperature (F)',value = 110,min = 0,max = 120,step = 1),
    submitButton("Submit")
  ),
  mainPanel(
  
  tabsetPanel(
    tabPanel("AIRQUALITYINDEX",verbatimTextOutput("airqltyindx")),
    tabPanel("SUMMARY","This application estimates the air quality index of the New York City based on the estimation of ozone present in the atmosphere. According to the standards, Ozone concentration of anything less than 50 parts per billion (ppb) is considered Good for people, anything more than 50 ppb and less than 100 ppb is considered Moderately Good and anything greater than 100 ppb is considered Unhealthy.
The application is written using shiny package in R. The ui.R file contains the script to provide functionality for the users to input the ambient temperature (in F) and wind speed (in mph) in New York City. It then calls the server.R script by passing the temperature and wind speed readings to obtain an estimate of ozone in the atmosphere and the air quality index.
             The server.R script takes the input readings and calls a function airqltyozone by passing the input readings as arguments. This function applies rain forest machine learning algorithm on the airquality dataset in the R datasets package, estimates the ozone concentration and in turn estimates the air quality index by using the standard reference as mentioned above. The server.R, then sends the ozone estimation and air quality estimation to the ui.R script which then displays it on the UI screen.
             ")
    
  )
)))