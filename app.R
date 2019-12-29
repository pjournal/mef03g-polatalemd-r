library(readxl)
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(ggplot2)


tmp=tempfile(fileext=".xlsx")

download.file("https://github.com/pjournal/mef03g-polatalemd-r/blob/master/university_statistics_2019-2014.xlsx?raw=true",destfile=tmp,mode='wb')
raw_data=readxl::read_excel(tmp)
file.remove(tmp)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("lumen"),
                
                titlePanel("Student Distribution In Years"),
                sidebarLayout(
                    sidebarPanel(
                        selectInput(inputId = "name_of_university",label = "Name of University:",
                                    choices = unique(raw_data$name_of_university))),
                    mainPanel(plotOutput("phonePlot"))
                )
)


library(datasets)

server <- function(input, output) {
    
    filtered <- reactive({
        raw_data %>%
            filter(name_of_university == input$name_of_university)
        
    })
    
    output$phonePlot <- renderPlot({
        
        ggplot(filtered(),
               aes(x = year_of_education,y = total_total))  +
            geom_bar(stat="identity", position=position_dodge(),fill="tomato3") + 
            labs(x="Years", y = "Number Of Students") +
            theme_minimal()
        
    })
    
}

shinyApp(ui = ui, server = server)