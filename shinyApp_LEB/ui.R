library(shiny)
require(rCharts)
LEBmale <- read.csv("data/LifeExpectancyAtBirth_male.csv")
shinyUI(pageWithSidebar(
    headerPanel("Life Expectancy at Birth (LEB) of Different Country"),
    sidebarPanel(
        radioButtons(inputId="gender", label="Gender", choices=c("Female","Male")),
        selectInput(inputId="country", label="Country", choices=sort(levels(LEBmale$country)),
                    multiple = FALSE, selected="United States"),
        actionButton("goButton", "Go!"),
        br(),
        br(),
        
        p(strong(em("Documentation:",a("Life Expectancy at Birth (LEB) of Different Country",href="README.html")))),
        p(strong(em("Github repository:",
                    a("Developing Data Products - Project - Shiny App",
                      href="https://github.com/uhuruqingcheng/DevelopingDataProducts_Project"))))
    ),
    mainPanel(
        tabsetPanel(
# If there are same thing (such as: verbatimTextOutput("oicountry"),) in two tabPanel, 
# then all things in tabsetPanel can not been seen. 
            tabPanel("Mean value",
                     h5("Mean LEB value of recent year:"),
                     verbatimTextOutput("oiLEB"),
                     img(src="Esperanza_de_vida.png", height = 600, width =600),
                     p("Source: ", a("List of countries by life expectancy", 
                                href = "https://en.wikipedia.org/wiki/Life_expectancy"))
                    ),
            tabPanel("Data Summary",
                     h5("Available data for"),
                     verbatimTextOutput("oigender"), 
                     verbatimTextOutput("oicountry"), 
                     h5("Mean Life Expectancy at Birth Value (years): "),
                     dataTableOutput("oiLEBcattable")
                    ),
            tabPanel("Plot: Mean LEB Trend",
                     h5("Mean LEB Trend per Years: "),
                     showOutput("Plot1","highcharts")
                    )   
        ),
    br(),
    p(strong("When I went to school, they asked me what I wanted to be when I grew up. I wrote down 'happy'. They told me I didn’t understand the assignment, and I told them they didn’t understand life. (John Lennon)"))
    )
)
)