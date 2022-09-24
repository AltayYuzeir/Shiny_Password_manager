

Sidebar_items = list(

tags$style(".well {background-color:#737373;}"), # #ffe6e6

tags$head(
  tags$style(
    type = "text/css",
    "
             #loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #A74BA9;
               z-index: 105;
             }
          "
  )
),

fluidRow(
  column( width = 4, 
          offset = 3,
          actionButton("userManual", "Open User manual", 
                       icon = icon("book-open"), 
                       style = "background:#70dbdb;color:#404040")
          
  )
),
p(),
htmlOutput("userManualText"),
#br(),
uiOutput("hideUserManual"),
hr(),
#### Username generator ----
span(h3("Random Username Generator"),style = "color:white"),

fluidRow(column( width = 6,
                 div(id = "wordCount", radioButtons("wordCount", "Word count:", choices = c(2,3,4),
                                                    selected = 2, inline = T)),
                 tags$style(type="text/css", "#wordCount {color:white;}")
                 
),
column(
  width = 6,
  div(id = "appendNumLabel", shinyjs::hidden(textInput("appendNum", "Append your number:", placeholder = "0049"))),
  tags$style(type="text/css", "#appendNumLabel {color:white;}")
  
)
),
div(id  = "letterCount", sliderInput("letterCount", "Letter count for a word in range:", 
                                     min = 3, max = 14, value = c(4,12), step = 1)),
tags$style(type="text/css", "#letterCount {color:white;}"),

actionButton("generateUsername", "Generate Username", 
             icon = icon("id-card-clip"),
             style = "background:#8cd9b3;color:#404040;"),

p(),
div(id = "randomUsernameLabel", shinyjs::hidden(textInput('randomUsername', label = NULL))),
tags$style(type="text/css", "#randomUsernameLabel {font-family:'Lucida Console';}"), #'Lucida Console'

fluidRow(
  column(
    width = 6,
    uiOutput("randomUsername2clipboard")
    
  ),
  column(
    width = 6,
    shinyjs::hidden(actionButton("turnOffUsername", "Turn off Generator", icon = icon("power-off"),
                                 style = "background:#d2a679;color:#404040"))
  )
  
),

#### Password generator ----
hr(),
span(h3("Random Password Generator"),style = "color:white"),
#br(),
div(id = "passwordLength",sliderInput("passwordLength", 
                                      label = "Length of Random Password:",
                                      value = 20, 
                                      min = 10, 
                                      max = 40, 
                                      step = 1)),
tags$style(type="text/css", "#passwordLength {color:white;}"),


div(id = "randomPasswordType" ,radioButtons(inputId = "randomPasswordType", "Select password type:",
                                            choices = c("Letters & Numbers" = "noSpecials",
                                                        "Letts & Nums + Specials" = "Specials"),
                                            inline = T)),

tags$style(type="text/css", "#randomPasswordType {color:white;}"),


actionButton("generatePassword", "Generate Password", 
             icon = icon("qrcode"), style = "background:#99ccff;color:#404040;"), # #b3d9ff
p(),
div(id = "randomPasswordLabel", shinyjs::hidden(textInput('randomPassword', label = NULL))),
tags$style(type="text/css", "#randomPasswordLabel {font-family:'Lucida Console';}"), # font-family:'Lucida Console' # font-style: italic; font-family: 'Yusei Magic';
#font-family:'Lucida Console';
# font-family: 'Kirnberg';            


fluidRow(
  column(
    width = 6,
    uiOutput("randomPassword2clipboard")
    
  ),
  column(
    width = 6,
    shinyjs::hidden( actionButton("turnOffPassword", "Turn off Generator", icon = icon("power-off"),
                                  style = "background:#d2a679;color:#404040"))
  )
  
)
)