library(maps)

# load pollutant function
source("pollution2013.R", local = TRUE)
source("pollution2014.R", local = TRUE)

handleEvent <- function(button, handler) {
    fun <- exprToFunction(button)
    observe({
        val <- fun()
        if (is.null(val) || identical(val, 0))
            return()
        
        isolate(handler())
    })
}

shinyServer(function(input, output, session) {
    values <- reactiveValues(markers = NULL)
    output$map <- reactive({10})
    
    map <- createLeafletMap(session, 'map')
        
    handleEvent(input$map_click, function() {
        if (!input$addMarkerOnClick)
            return()
        if(input$year == 2014){
            map$addMarker(input$map_click$lat, input$map_click$lng, NULL)
            values$markers <- rbind(data.frame(pol=pollutant2014(data.frame(lon=input$map_click$lng,
                                                                        lat=input$map_click$lat,
                                                                        radius=input$rad))
            ),
            values$markers)
        }else{
            map$addMarker(input$map_click$lat, input$map_click$lng, NULL)
            values$markers <- rbind(data.frame(pol=pollutant2013(data.frame(lon=input$map_click$lng,
                                                                            lat=input$map_click$lat,
                                                                            radius=input$rad))
            ),
            values$markers)
        }
        })
    
    handleEvent(input$clearMarkers, function() {
        map$clearMarkers()
        values$markers <- NULL
    })
        
    output$markers <- renderTable({
        if (is.null(values$markers))
            return(NULL)
        
        data <- values$markers
        colnames(data) <- c('Longitude', 'Latitude', 'Radius', 'Ozone', 'PM25')
        return(data)
        })
})