
UserInterface_items = list(


p(),
fluidRow(column(width = 9,
                div(id = "masterPasswordLabel",passwordInput(inputId = "masterPassword",
                                                             label = "Master Password:",
                                                             placeholder = "3a2TR_3GG!!!_12land2;)",
                                                             width = "95%"
                ))),
         tags$style(type="text/css", "#masterPasswordLabel {color:white;}"),
         tags$style(type="text/css", "#masterPassword {font-family:'Lucida Console';}"),
         
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
    width = 6,
    shinyjs::hidden(textInput("showhideMasterPasswordField", label = NULL)),
  ),
  column(
    width = 1,
    actionButton("hideMasterPass",
                 "Hide",
                 icon = icon("eye-slash"),
                 style = "background:#ccccff;color:#404040;")
  ),
  
  column(
    width = 2,
    actionButton("changeMasterPassword",
                 "Change Master Pass",
                 icon = icon("triangle-exclamation"),
                 style = "background:#cc3300;color:#404040;")
  )
),
tags$style(type='text/css', "input#showhideMasterPasswordField {font-family:'Lucida Console'; margin-bottom: -20px; margin-left: -50px; margin-right: 0px;width: 390px}"),
tags$style(type='text/css', "button#hideMasterPass {  margin-left: -70px; }"),
tags$style(type="text/css", "#themeOptions {color:white;}"),
p(),
fluidRow(
  column(width = 7,
         shinyjs::hidden(textInput("newMasterPasswordField", label = NULL, width = "100%",
                                   placeholder = "Enter new Master Password here"))
         ),
  column(width = 2,
         shinyjs::hidden(actionButton("confirmNewMasterPass", "Confirm Change", 
                                      icon = icon("check-double"),
                                      style = "background:#669900;"))
         ),
  column(width = 2,
         shinyjs::hidden(actionButton("cancelNewMasterPass", "Cancel Change",
                                      icon = icon("ban"),
                                      style = "background:#999966;"))
  )
  
),
tags$style(type='text/css', "button#cancelNewMasterPass { margin-left: 30px; }"),
hr(),

div(id = "profileLabel",textInput(inputId = "profile",
                                  label = "Profile (website/credit card/other accounts):",
                                  placeholder = "bubble.com"
                                  
)),
tags$style(type="text/css", "#profileLabel {color:white;}"),
tags$style(type="text/css", "#profile {font-family:'Lucida Console';}"),
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
  ),
  column(
    width = 2,
    div(id = "login2clipboard", uiOutput("login2clipboard"))
  )
),
tags$style(type="text/css", "#loginLabel {color:white;}"),
tags$style(type="text/css", "#login {font-family:'Lucida Console';}"),
tags$style(type="text/css", "button#pasteLogin { margin-left: -30px; margin-top:25px;}"),
tags$style(type="text/css", "#login2clipboard {margin-top:25px;}"),

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
    tags$b("2022-2022"),br(), tags$b("Altay Yuzeir"),
    tags$a(href ="https://github.com/AltayYuzeir/Shiny_Password_manager",
           tags$b(tags$span(style = "color: #80b3ff", icon("github"), "GitHub")),
           target = "_blank")),
br()

)