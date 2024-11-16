# Share Shed Shiny Implementation
# v0.2
# 2024-11-16
# Scott K. Anderson
# https://github.com/skaclmbr


if (!require(shiny))
  install.packages("shiny", repos = "http://cran.us.r-project.org")

if (!require(shinyMobile))
  install.packages("shinyMobile", repos = "http://cran.us.r-project.org")

if (!require(shinyAuthX))
  install.packages("shinyAuthX", repos = "http://cran.us.r-project.org")


source("utils.R")

app_opts <-   list(
  theme = "auto",
  dark = "auto",
  skeletonsOnLoad = FALSE,
  preloader = FALSE,
  filled = FALSE,
  color = "#BCD979",
  touch = list(
    touchClicksDistanceThreshold = 5,
    tapHold = TRUE,
    tapHoldDelay = 750,
    tapHoldPreventClicks = TRUE,
    iosTouchRipple = FALSE,
    mdTouchRipple = TRUE
  ),
  iosTranslucentBars = FALSE,
  navbar = list(
    iosCenterTitle = TRUE,
    hideOnPageScroll = TRUE
  ),
  toolbar = list(
    hideOnPageScroll = FALSE
  ),
  pullToRefresh = FALSE
)

shinyApp(
  ui = f7Page(
    options = app_opts,
    title = "shinyMobile Sandbox",
    f7TabLayout(
      panels = tagList(
        f7Panel(
          id = "mypanel1",
          side = "left",
          effect = "push",
          title = "Left panel",
          f7Block("A panel with push effect"),
          f7PanelMenu(
            id = "menu",
            f7PanelItem(
              tabName = "Tab1",
              title = "Tab 1",
              icon = f7Icon("folder"),
              active = TRUE
            ),
            f7PanelItem(
              tabName = "Tab2",
              title = "Tab 2",
              icon = f7Icon("keyboard")
            ),
            f7PanelItem(
              tabName = "Tab3",
              title = "Tab 3",
              icon = f7Icon("layers_alt")
            )
          )
        ),
        f7Panel(
          id = "mypanel2",
          side = "right",
          effect = "floating",
          title = "Right panel",
          f7Block(
            "A panel with cover effect"
          )
        )
      ),
      navbar = f7Navbar(
        title = "shinyMobile Sandbox",
        hairline = TRUE,
        leftPanel = TRUE,
        rightPanel = TRUE
      ),
      f7Tabs(
        id = "tabs",
        animated = TRUE,
        #swipeable = TRUE,
        f7Tab(
          title = "Tab 1",
          tabName = "Tab1",
          icon = f7Icon("folder"),
          active = TRUE,
          lapply(1:30, function(i) {
            f7Card(title = sprintf("Card %s", i),
                   p(sprintf("Content %s", i)))
          })
        ),
        f7Tab(
          title = "Tab 2",
          tabName = "Tab2",
          icon = f7Icon("keyboard"),
          f7Card(
            title = "Card header",
            "A card"
          )
        ),
        f7Tab(
          title = "Tab 3",
          tabName = "Tab3",
          icon = f7Icon("layers_alt"),
          f7Card(
            title = "Card header",
            f7SmartSelect(
              inputId = "variable",
              label = "Variables to show:",
              choices = c("Cylinders" = "cyl",
                          "Transmission" = "am",
                          "Gears" = "gear"),
              openIn = "sheet",
              multiple = TRUE
            ),
            tableOutput("data")
          )
        )
      )
    )
  ),
  server = function(input, output, session) {
    # update tabs depending on side panel
    observeEvent(input$menu, {
      updateF7Tabs(id = "tabs",
                   selected = input$menu,
                   session = session)
    })

    # datatable
    output$data <- renderTable({
      mtcars[, c("mpg", input$variable), drop = FALSE]
    }, rownames = TRUE)
  }
)