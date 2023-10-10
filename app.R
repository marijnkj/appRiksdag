library(analyzeRiksdag)

print("Checking for updates... please wait.")
get_Riksdag()

ui <- fluidPage(
  titlePanel("Swedish voting"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("assembly_year", h3("Choose assembly year"),
                  choices=fun_get_assembly_year_options(), selected=fun_get_assembly_year_options()[1]),
      uiOutput("utskott_choice"),
      uiOutput("beteckning_choice"),
      textInput("agenda_item", h3("Choose agenda point"), value="1"),
      selectInput("filter", h3("Choose filter"),
                  choices=list("Gender"="Gender", "Region"="Region", "Party"="Party"), selected="Gender"),
    ),
    mainPanel(
      plotlyOutput("bar_plot")
    )
  )
)

server <- function(input, output) {
  output$utskott_choice <- renderUI({
    selectInput("utskott", h3("Select utskott"),
                choices=get_utskott(input$assembly_year))
  })
  
  output$beteckning_choice <- renderUI({
    selectInput("beteckning", h3("Select beteckning"),
                choices=get_titlar(input$assembly_year, input$utskott))
  })
  
  output$bar_plot <- renderPlotly({
    df <- fun_fetch_data(input$assembly_year, input$beteckning, input$agenda_item)
    fun_bar_chart(df, input$filter)})
}

shinyApp(ui=ui, server=server)
