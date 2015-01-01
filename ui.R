library(leaflet)
library(ShinyDash)

addResourcePath(
    prefix = 'shinyDash',
    directoryPath = system.file('shinyDash', package='ShinyDash'))

row <- function(...) {
    tags$div(class="row", ...)
}
col <- function(width, ...) {
    tags$div(class=paste0("span", width), ...)
}
actionLink <- function(inputId, ...) {
    tags$a(href='javascript:void',
           id=inputId,
           class='action-button',
           ...)
}

shinyUI(navbarPage("Pollution in the US",
                   tabPanel("Map",
    bootstrapPage(
    leafletMap("map", "100%", 400,
               initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
               options=list(
                   center = c(39.2833, -76.6167),
                   zoom = 6
                   )
    ),
    tags$div(
        class = "container",
        
        tags$p(tags$br()),
        row(
            col(
                7,
                numericInput('rad', 'Radius (mi)', 20),
                selectInput("year", "Year:",
                            c("2014",
                              "2013")),
                tags$hr(),
                checkboxInput('addMarkerOnClick', 'Add marker on click', TRUE)
            ),
            col(
                5,
                conditionalPanel(
                    condition = 'output.markers',
                    h4('Marker locations'),
                    actionLink('clearMarkers', 'Clear markers')
                ),
                tableOutput('markers')
            )
        )
    )
)),
tabPanel("About",
         mainPanel(
             includeMarkdown("About.md")
         )
))
)