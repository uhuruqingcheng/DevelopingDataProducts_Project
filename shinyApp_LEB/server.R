LEB<-function(country, gender){
    if(gender=="Male")return(mean(LEBmaleCat$Value[LEBmaleCat$country==country]))
    else return(mean(LEBfemaleCat$Value[LEBmaleCat$country==country]))
}

LEBCategories<-function(ccountry,gender){
    if(gender=="Male"){temp <- LEBmaleCat}
    else{temp <- LEBfemaleCat}
    temp<-subset(temp,temp$country==ccountry)
    temp<-temp[order(temp$Year,decreasing=TRUE),c("Year","gender","Value")]
    return(temp)
}
LEBTrend<-function(ccountry){
    temp1<-subset(LEBmaleCat,LEBmaleCat$country==ccountry,select=c("Year","Value","gender"))
    temp2<-subset(LEBfemaleCat,LEBfemaleCat$country==ccountry,select=c("Year","Value","gender"))
    temp<- rbind(temp1,temp2)
#     temp<-temp[order(c(temp$Year,temp$gender)),]
    names(temp)<-c("Year","Life Expectancy at Birth Value","gender")
    return(temp)
}
library(shiny)
library(reshape2)
LEBmaleCat <- read.csv("data/LifeExpectancyAtBirth_male.csv")
LEBfemaleCat <- read.csv("data/LifeExpectancyAtBirth_female.csv")
LEBmaleCat$Year<-as.numeric(format(as.Date(as.character(LEBmaleCat$Date),format="%d/%m/%Y"),"%Y"))
LEBfemaleCat$Year<-as.numeric(format(as.Date(as.character(LEBfemaleCat$Date),format="%d/%m/%Y"),"%Y"))
LEBmaleCat$gender<- factor("male")
LEBfemaleCat$gender<- factor("female")

shinyServer(
    function(input, output) { 
        output$oiLEB <- renderPrint({
            input$goButton
            isolate(LEB(input$country,input$gender))
        })
        output$oicountry<-renderText({
            input$goButton
            isolate(input$country)
        })
        output$oigender<-renderText({
            input$goButton
            isolate(input$gender)
        })  
        output$oiLEBcattable = renderDataTable({
            input$goButton
            isolate(LEBCategories(input$country,input$gender))
        })
        output$Plot1 <- renderChart({
            input$goButton
            isolate(datat<-LEBTrend(input$country))
            hp1 <- hPlot(x = "Year", y = "Life Expectancy at Birth Value",group="gender", data = datat, type = "line")
            hp1$addParams(dom ='Plot1')
            return(hp1)
        })
    })  