
categories <<- c(
  "Social media",
  "Web account",
  "Email",
  "Credit card",
  "Bank details",
  "Healthcare account",
  "Bills acount",
  "Tax account",
  "Pension account",
  "Insurance account",
  "Streaming service",
  "Gaming",
  "Online shopping",
  "Wifi account",
  "Other")

UserInterface_items = list(

p(),
fluidRow(
  column(width = 4,
         selectInput(inputId = "type",
                                           label = "Select account type:",
                                           choices = categories,
                                           selected = categories[1]
                                           
         )
  ),
  column(width = 5,
textInput(inputId = "profile",
                                  label = "Enter Profile:",
                                  placeholder = "bubble.com"
                                  
)
),
column(width = 2,
   div( id = "new_type",
         actionButton(inputId = "new_type",
                      label = "Add account type",
                      icon = icon("plus"),
                      style = "background:#ffcc99;color:#404040;"
                      )))
),
tags$style(type="text/css", "button#new_type { margin-left: 0px; margin-top:25px;}"),

tags$style(type="text/css", ".selectize-input {font-family:'Lucida Console';} .selectize-dropdown {font-family:'Lucida Console';}"),
tags$style(type="text/css", "#profile {font-family:'Lucida Console';}"),
fluidRow(
  column(width = 6,
         shinyjs::hidden(textInput("addNewType", "Enter new type: (Non-persistent)",
                   placeholder = "Personal account"))),
  column(width = 3,
         shinyjs::hidden(actionButton("confirmNewType", "Confirm new type", 
                                      icon = icon("check"), style = "background:#ccff99;color:#404040;"))),
  column(width = 3,
         shinyjs::hidden(actionButton("cancelNewType", "Cancel new type",
                                      icon = icon("ban"), style = "background:#ff9999;color:#404040;")))
  
),
tags$style(type="text/css", "#addNewType {font-family:'Lucida Console';}"),
tags$style(type="text/css", "button#confirmNewType { margin-left: -100px; margin-top:25px;}"),
tags$style(type="text/css", "button#cancelNewType { margin-left: -140px; margin-top:25px;}"),

fluidRow(
  
  column(width = 5,
        
           textInput(
             inputId = "login",
             label = "Enter Login:",
             placeholder = "SlowGenomics1337"
             
           
         )),
  column(width = 2,
         
         div(
           id = "pasteLogin",
           actionButton(inputId = "pasteLogin", label = "Paste Username", 
                        icon = icon("id-card-clip"), 
                        style = "background:#8cd9b3;color:#404040;"))
  ),
  column(
    width = 2,
    div(id = "login2clipboard", uiOutput("login2clipboard"))
  )
),
tags$style(type="text/css", "#login {font-family:'Lucida Console';}"),
tags$style(type="text/css", "button#pasteLogin { margin-left: -30px; margin-top:25px;}"),
tags$style(type="text/css", "#login2clipboard {margin-top:25px;}"),

fluidRow(
  column(width = 7,
passwordInput(inputId = "password",
                                               label = "Enter Password:",
                                               placeholder = "D1r7D3v1LChub8yB3rRy",
                                               width = "100%"
                                               
         )),
  column(width = 2,
         div(
           id = "pastePassword",
           actionButton("pastePassword", "Paste Password", 
                        icon = icon("qrcode"),
                        style = "background:#99ccff;color:#404040;")
         ))
),
tags$style(type="text/css", "#password {font-family:'Lucida Console';;}"),
tags$style(type="text/css", "button#pastePassword{ margin-top:25px;}"),

fluidRow(
  column(
    width = 2,
    actionButton("showPass",
                 "Show",
                 icon = icon("eye"),
                 style = "background:#ccccff;color:#404040;")
  ),
  column(
    width = 4,
    shinyjs::hidden(textInput("showhidePasswordField", label = NULL)),
  ),
  column(
    width = 1,
    actionButton("hidePass",
                 "Hide",
                 icon = icon("eye-slash"),
                 style = "background:#ccccff;color:#404040;"),
    
  ),
  column(
    width = 2,
    uiOutput("password2clipboard")
  )
),
tags$style(type='text/css', "input#showhidePasswordField { font-family:'Lucida Console';margin-bottom: -20px; margin-left: -50px; width: 310px}"),
tags$style(type='text/css', "button#hidePass { margin-left: -10px;}"),

#tags$style(type='text/css', "#password2clipboard { padding-left: 0px; }"),

br(),
br(),
fluidRow(
  column(
    width = 2,
    actionButton("saveRecord",
                 "Save Record",
                 icon = icon("check"),
                 style = "background:#1affb2;color:#404040;")
  ),
  column(
    width = 2,
    actionButton("editRecord",
                 "Edit Record",
                 icon = icon("pen-to-square"),
                 style = "background:#ffcc99;color:#404040;")
  ),
  column(
    width = 2,
    actionButton("deleteRecord",
                 "Delete Record",
                 icon = icon("xmark"),
                 style = "background:#ff6666;color:#404040;")
  ),
  column(
    width = 2,
    actionButton("searchProfile",
                 "Search Profiles",
                 icon = icon("magnifying-glass"),
                 style = "background:#df9fbf;color:#404040;")
    
  ),
  column(
    width = 4,
    span(style = "font-family:'Lucida Console'", 
         uiOutput("searchBarProfile")
         
         )
  )
  
),
fluidRow(
  column(
    width = 2,
    offset = 2,
    shinyjs::hidden(actionButton("confirmEditRecord", "Confirm Edit", icon = icon("pen-clip"),
                                 style = "background:#ff9933;color:#404040;margin-top:5px;"))
    
  ),
  column(
    width = 2,
    offset = 0,
    
    shinyjs::hidden(actionButton("confirmDeleteRecord",
                 "Confirm Delete", icon = icon("trash"),
                 style = "background:#ff1a1a;color:#404040;margin-top:5px;"))
    
  ),
  
  column(
    width = 2,
    offset = 0,
    shinyjs::hidden(actionButton("searchLogin", "Search Logins", icon = icon("right-to-bracket"),
                                 style = "background:#df9fbf;color:#404040;margin-top:5px;"))
    
  ),
  
  column(
    width = 4,
    span(style = "font-family:'Lucida Console'",uiOutput("searchBarLogin"))
    
  )
),

tags$head(
  tags$style(HTML("

        #searchBarLoginStyle {
          padding-top: 5px;
        }

      "))
),

fluidRow(
  column(
    width = 2,
    offset = 2,
    shinyjs::hidden(actionButton("cancelEditRecord", "Cancel Edit", icon = icon("ban"),
                                 style = "background:#ccffcc;color:#404040;margin-top:5px;"))
    
  ),
  column(
    width = 2,
    offset = 0,
    shinyjs::hidden(actionButton("cancelDeleteRecord",
                                 "Cancel Delete", icon = icon("ban"),
                                 style = "background:#ccffcc;color:#404040;margin-top:5px;"))
  ),
  column(
    width = 2,
    offset = 2,
   
    shinyjs::hidden(actionButton("loadRecord", "Load Record", icon = icon("upload"),
                                 style = "background:#df9fbf;color:#404040;margin-top:5px;"))
    
  ),
  column(
    width = 2,
    
    shinyjs::hidden(actionButton("closeSearch", "Close Search", icon = icon("circle-xmark"),
                                 style = "background:#df9fbf;color:#404040;margin-top:5px;"))
  )
),
tags$style(type='text/css', "button#closeSearch { margin-left: -10px; }"),

br(),
hr(),
fluidRow(
  column(
    width = 2,
    offset = 2,
    downloadButton("downloadDatabase", "Download Database",
                   style = "background:#bfbfbf;color:#404040;"),
    
  ),
  column(
    width = 2,
    offset = 3,
    actionButton("removeDuplicates", "Remove Duplicates", icon = icon("eraser"),
                 style = "background:#bfbfbf;color:#404040;"),
    
  )
),
hr(),

div(style="text-align:center; color: #80b3ff", tags$b("Copyright"),icon("copyright"),
    tags$b("2022-present"), tags$b(" | "), 
    tags$b("Altay Yuzeir"),
    tags$a(href ="https://github.com/AltayYuzeir/Shiny_Password_manager",
           tags$b(tags$span(style = "color: #80b3ff", icon("github"), "GitHub")),
           target = "_blank"), br(),
    tags$b("All rights reserved"), tags$b(" | "), tags$b("Developed with R/Shiny")),
br()
)