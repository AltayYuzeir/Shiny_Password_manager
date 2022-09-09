
UserInterface_items = list(


p(),
fluidRow(column(width = 9,
                div(id = "masterPasswordLabel",passwordInput(inputId = "masterPassword",
                                                             label = "Master Password:",
                                                             #placeholder = "EXample_M4ST3R!!!_p@ssw0rd;)",
                                                             placeholder = "3a2TR_3GG!!!_12land2;)",
                                                             width = "95%"
                ))),
         tags$style(type="text/css", "#masterPasswordLabel {color:white;}"),
         
         column(width = 3,
                div(id ="masterPasswordOptions", radioButtons("masterPasswordOptions", "Select mode:", 
                                                              choices = c("Clear Master Password"="Clear", "Keep Master Password"="Keep"),
                                                              selected = "Keep",
                                                              inline = F)
                ))),
tags$style(type="text/css", "#masterPasswordOptions {color:white;}"),

fluidRow(
  column(
    width = 2,
    actionButton("showMasterPass",
                 "Show",
                 icon = icon("eye"),
                 style = "background:#ccccff;color:#404040;")
  ),
  column(
    #offset = 2,
    width = 6,
    shinyjs::hidden(textInput("showhideMasterPasswordField", label = NULL)),
  ),
  column(
    width = 2,
    actionButton("hideMasterPass",
                 "Hide",
                 icon = icon("eye-slash"),
                 style = "background:#ccccff;color:#404040;")
  )
),
tags$style(type='text/css', "input#showhideMasterPasswordField {font-family:'Lucida Console'; margin-bottom: -20px; margin-left: -50px; margin-right: 0px;width: 390px}"),
tags$style(type='text/css', "button#hideMasterPass {  margin-left: -70px; }"),
tags$style(type='text/css', "button#reloadButton {  margin-left: -60px; }"),

hr(),

div(id = "websiteLabel",textInput(inputId = "website",
                                  label = "Profile (website/credit card/other accounts):",
                                  placeholder = "bubble.com"
                                  
)),
tags$style(type="text/css", "#websiteLabel {color:white;}"),
fluidRow(
  
  column(width = 5,
         div(
           id = "loginLabel",
           textInput(
             inputId = "login",
             label = "Login (username/email/phone number):",
             placeholder = "SlowGenomics1337"
             
           )
         )),
  column(width = 2,
         
         div(
           id = "pasteLogin",
           actionButton(inputId = "pasteLogin", label = "Paste Username", 
                        icon = icon("id-card-clip"), 
                        style = "background:#8cd9b3;color:#404040;"))
  )
),
tags$style(type="text/css", "#loginLabel {color:white;}"),
tags$style(type="text/css", "button#pasteLogin { margin-left: -30px; margin-top:25px;}"),

fluidRow(
  column(width = 7,
         div(id ="passwordLabel",passwordInput(inputId = "password",
                                               label = "Password:",
                                               placeholder = "D1r7D3v1LChub8yB3rRy",
                                               width = "100%"
                                               
         ))),
  column(width = 2,
         div(
           id = "pastePassword",
           actionButton("pastePassword", "Paste Password", 
                        icon = icon("qrcode"),
                        style = "background:#99ccff;color:#404040;")
         ))
),
tags$style(type="text/css", "#passwordLabel {color:white;}"),
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
    #offset = 1,
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
    actionButton("searchRecord",
                 "Search Profiles",
                 icon = icon("magnifying-glass"),
                 style = "background:#df9fbf;color:#404040;")
    
  ),
  column(
    width = 4,
    #selectizeInput("searchRecord", label = NULL, choices = "")
    uiOutput("searchBarWebsite")
  )
  
),
#p(),
fluidRow(
  column(
    width = 2,
    offset = 2,
    #p(),
    uiOutput("confirmEditRecord")
    
  ),
  column(
    width = 2,
    offset = 0,
    #p(),
    uiOutput("confirmDeleteRecord")
    
  ),
  
  column(
    width = 2,
    offset = 0,
    uiOutput("searchLoginButton")
    
  ),
  
  column(
    width = 4,
    uiOutput("searchBarLogin")
    
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
    #p(),
    uiOutput("cancelEditRecord")
    
  ),
  column(
    width = 2,
    offset = 0,
    #p(),
    uiOutput("cancelDeleteRecord")
    
  ),
  column(
    width = 2,
    offset = 2,
    uiOutput("loadRecordButton")
    
  ),
  column(
    width = 2,
    uiOutput("closeSearchButton")
    
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
    tags$b("2022-2022"),br(), tags$b("Altay Yuzeir")),
br()
#hr(),

)