

Sidebar_items = list(

tags$style(".well {background-color:#737373;}"), # #ffe6e6

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
                 radioButtons("wordCount", "Word count:", choices = c(2,3,4),
                                                    selected = 2, inline = T)
                 
),
column(
  width = 6,
shinyjs::hidden(textInput("appendNum", "Append your number:", placeholder = "0049")),

)
),
sliderInput("letterCount", "Letter count for a word in range:", 
                                     min = 3, max = 14, value = c(4,12), step = 1),


actionButton("generateUsername", "Generate Username", 
             icon = icon("id-card-clip"),
             style = "background:#8cd9b3;color:#404040;"),

p(),
shinyjs::hidden(textInput('randomUsername', label = NULL)),

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
sliderInput("passwordLength",
            label = "Length of Random Password:",
            value = 20,
            min = 10,
            max = 40,
            step = 1),


radioButtons(inputId = "randomPasswordType", "Select password type:",
                                            choices = c("Letters & Numbers" = "noSpecials",
                                                        "Letts & Nums + Specials" = "Specials"),
                                            inline = T),


actionButton("generatePassword", "Generate Password", 
             icon = icon("qrcode"), style = "background:#99ccff;color:#404040;"), # #b3d9ff
p(),
div(id = "randomPasswordLabel", shinyjs::hidden(textInput('randomPassword', label = NULL))),
tags$style(type="text/css", "#randomPasswordLabel {font-family:'Lucida Console';}"), 
# font-family:'Lucida Console' 
# font-style: italic; font-family: 'Yusei Magic';
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