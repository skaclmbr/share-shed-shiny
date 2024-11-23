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
    title = "ShareShed",
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
              tabName = "Search",
              title = "Search",
              icon = f7Icon("search"),
              active = TRUE
            ),
            f7PanelItem(
              tabName = "Library",
              title = "Library",
              icon = f7Icon("book")
            )
          )
        ),
        f7Panel(
          id = "mypanel2",
          side = "right",
          effect = "floating",
          title = "Login",
          f7Block(
            # add signout button UI
            div(class = "pull-right", signoutUI(id = "signout")),

            # add signin panel UI function without signup or password recovery panel
            signinUI(id = "signin", .add_forgotpw = TRUE, .add_btn_signup = TRUE),
            signupUI("signup"),

            # setup output to show user info after signin
            verbatimTextOutput("user_data")
            )
        )
      ),
      navbar = f7Navbar(
        title = "ShareShed",
        hairline = TRUE,
        leftPanel = TRUE,
        rightPanel = TRUE
      ),
      f7Tabs(
        id = "tabs",
        animated = TRUE,
        #swipeable = TRUE,
        f7Tab(
          title = "Search",
          tabName = "Search",
          icon = f7Icon("search"),
          active = TRUE,
          f7Card(
            title="Users",
            p(textOutput("testuserinfo"))
          ),
          lapply(1:30, function(i) {
            f7Card(title = sprintf("Card %s", i),
                   p(sprintf("Content %s", i)))
          })
        ),
        f7Tab(
          title = "Library",
          tabName = "Library",
          icon = f7Icon("keyboard"),
          f7Card(
            p("TESTING")
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


    ##################################################################
    ## USER MANAGEMENT
        # Export reactive values for testing
    # Export reactive values for testing
    exportTestValues(
        auth_status = credentials()$user_auth,
        auth_info   = credentials()$info
    )

    # call the signout module with reactive trigger to hide/show
    signout_init <- signoutServer(
        id = "signout",
        active = reactive(credentials()$user_auth)
    )

    # call signin module supplying data frame,
    credentials <- signinServer(
        id = "signin",
        users_db = users$find('{}'), ## add mongodb connection instead of tibble
        sodium_hashed = TRUE,
        reload_on_signout = FALSE,
        signout = reactive(signout_init())
    )

    # call signup module supplying credentials() reactive
    signupServer(
      id = "signup", credentials = credentials, mongodb = users
    )
    output$testuserinfo <- renderText({

      ufind <- users$find('{"username" : "user2"}')
      print(ufind$name)
    })

    output$user_data <- renderPrint({
        # use req to only render results when credentials()$user_auth is TRUE
        req(credentials()$user_auth)
        str(credentials())
    })
    # # # datatable
    # # output$data <- renderTable({
    # #   mtcars[, c("mpg", input$variable), drop = FALSE]
    # # }, rownames = TRUE)
  }
)