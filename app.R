library(analyzeRiksdag)

ui <- fluidPage(
  titlePanel("Swedish voting"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("assembly_year", h3("Choose assembly year"),
                  choices=fun_get_assembly_year_options(), selected=fun_get_assembly_year_options()[1]),
      textInput("beteckning", h3("Choose beteckning"), value="AU10"),
      textInput("agenda_item", h3("Choose agenda point"), value="2"),
      selectInput("filter", h3("Choose filter"),
                             choices=list("Gender"="Gender", "Region"="Region", "Party"="Party"), selected="Gender")
    ),
    mainPanel(
      plotlyOutput("bar_plot")
    )
  )
)

server <- function(input, output) {
  output$bar_plot <- renderPlotly({
    df <- fun_fetch_data(input$assembly_year, input$beteckning, input$agenda_item)
    fun_bar_chart(df, input$filter)})
}

shinyApp(ui=ui, server=server)
