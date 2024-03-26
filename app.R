library(shiny)
#library(rclipboard) # for 'Copy to Clipboard' buttons
library(shinyWidgets) # for setting background color of UI elements
#library(shinytitle)
library(shinyalert) # fancy alerts for success and failure
#library(shinyjs) # to hide and show UI elements 
#library(openssl) # to create our encryption key
#library(digest)
#library(words) # database to use for random password generator
#library(dplyr)
#library(stringr)#

library(DT)

source(file = "functions.R")
source(file = "user_manual.R")
source(file = "tab_UI.R")
source(file = "sidebar_UI.R")
source(file = "reload_database.R")

# Add your destination folder for permanent storage of your encrypted database
path = Sys.getenv("USERPROFILE")
path = gsub( "\\\\", "/", path)
path = paste0(path, "/YuPass_Password_Manager/")
word_bank = words::words
if(!dir.exists(path)) dir.create(path)

js <- "
function(cell) {
  var $cell = $(cell);
  var originalText = $cell.text(); // Save original text
  var hiddenText = '*'.repeat(originalText.length); // Create string of stars with same length
  $cell.html('<span>' + hiddenText + '</span>'); // Initially set text to hiddenText inside a span
  var $btn = $('<button style=\"margin-left: 10px; color: black;\">Show Password</button>'); // Create the button with margin-left and black text
  $cell.append($btn); // Append button to cell
  var isHidden = true;

  $btn.click(function () {
    var $textSpan = $cell.find('span');
    if (isHidden) {
      $textSpan.text(originalText); // Show original text
      $btn.text('Hide Password');
    } else {
      $textSpan.text(hiddenText); // Hide text with stars
      $btn.text('Show Password');
    }
    isHidden = !isHidden;
  });
}
"

#### UI ----
ui = fluidPage(   
  tags$head(tags$link(rel="shortcut icon", href="unlock-keyhole-solid.svg")),
  
  setBackgroundColor("#404040"), # #93c2eb
  #setBackgroundColor("#93c2eb"), # #93c2eb
  
  rclipboard::rclipboardSetup(),
  
  titlePanel(div(img(src = "YuPass-logo.png", height = 100, width = 100),
                 span("YuPass - Password Manager app", style = "color:white;"))),
  
  title = shinytitle::use_shiny_title(),
  
  
  sidebarLayout(
    sidebarPanel(
      style = "color:white",
      Sidebar_items,
      width = 4
    ),
    #### Main panel ----
    mainPanel(
      shinyjs::useShinyjs(),
      tags$head(tags$style(
        HTML("hr {border-top: 1px solid #ffffff;}")
      )),
      fluidRow(column(width = 9,
                      div(id = "masterPasswordLabel",passwordInput(inputId = "masterPassword",
                                                                   label = "Master Password:",
                                                                   placeholder = "3a2TR_3GG!!!_12land2;)",
                                                                   width = "95%"
                      ))),
               tags$style(type="text/css", "#masterPassword {font-family:'Lucida Console';}"),
               tags$style(type='text/css', "#masterPasswordLabel {color: white; }"),
               column(width = 3,
                      div(id = "masterPasswordOptionsLabel", radioButtons("masterPasswordOptions", "Select mode:", 
                                                                          choices = c("Clear Master Password"="Clear", "Keep Master Password"="Keep"),
                                                                          selected = "Keep",
                                                                          inline = F))
               ),
               tags$style(type='text/css', "#masterPasswordOptionsLabel {color: white; }"),
               
      ),
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
                       style = "background:#666699;color:white;")
        )
      ),
      tags$style(type='text/css', "input#showhideMasterPasswordField {font-family:'Lucida Console'; margin-bottom: -20px; margin-left: -50px; margin-right: 0px;width: 390px}"),
      tags$style(type='text/css', "button#hideMasterPass {  margin-left: -70px; }"),
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
      #hr(),
      p(),
      p(),
      tabsetPanel(type = "tabs",
                  tabPanel(span(style = "color:#336699;font-weight:bold;",
                                "Actions Tab"),
                           style = "color:white",
                           UserInterface_items,
                           icon = span(style = "color:#336699;font-weight:bold;",
                                       icon("keyboard"))
                  ),
                  tabPanel(span(style = "color:#993300;font-weight:bold;",
                                "Database Table"), 
                           p(),
                           
                           p(span(style ="color:#888888;font-weight:bold;",
                                  'If you see message starting with "Error:", your Master Password is wrong !')),
                           span(style = "color:#cc6699;font-weight:bold;font-family:'Lucida Console';",
                                DT::DTOutput("Database"),
                                tags$head(tags$style("#Database {color: white;}")),
                                tags$head(tags$style("#Database .dataTables_filter input {
          background:white;color:#4d4d4d;}")),
                           ),
                           hr(),
                           
                           div(style="text-align:center; color: #80b3ff", tags$b("Copyright"),icon("copyright"),
                               tags$b("2022-present"),br(), tags$b("Altay Yuzeir"),
                               tags$a(href ="https://github.com/AltayYuzeir/Shiny_Password_manager",
                                      tags$b(tags$span(style = "color: #80b3ff", icon("github"), "GitHub")),
                                      target = "_blank")),
                           
                           icon = span(style = "color:#993300;font-weight:bold;",
                                       icon("table"))
                  )
      )
    )
  )  
)

#### Server ----
server = function(input, output, session) {
  
  # Database tab ----
  output$Database = DT::renderDataTable({
    #reload_database_table(input$masterPassword, path)
    
    DT::datatable(reload_database_table(input$masterPassword, path), 
                  rownames = FALSE, selection = "none",
                  options = list(
                    "columnDefs" = list(
                      list(
                        "targets" = c(3),
                        "createdCell" = JS(js),
                        className = 'dt-left'
                      ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
    
  })
  
  shinytitle::change_window_title(session, title = "YuPass")
  
  #### Show-Hide Master Password ----
  observeEvent(input$showMasterPass, {
    Password = input$masterPassword
    updateTextInput(inputId = "showhideMasterPasswordField",
                    label = NULL,
                    value = input$masterPassword)
    
    shinyjs::show("showhideMasterPasswordField")
  })
  
  
  observeEvent(input$hideMasterPass, {
    updateTextInput(inputId = "showhideMasterPasswordField", value = "")
    shinyjs::hide("showhideMasterPasswordField")
  })
  #### Update Master Password ----
  observeEvent(input$changeMasterPassword,{
    
    MasterPassword = input$masterPassword
    if(file.exists(paste0(path,"Database"))){
      if ( is_empty_input(MasterPassword)
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else{
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        
        else {
          
          shinyjs::show("newMasterPasswordField")
          shinyjs::show("confirmNewMasterPass")
          shinyjs::show("cancelNewMasterPass")
          
        }
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }}
    else {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    }
    
  })
  
  observeEvent(input$confirmNewMasterPass,{
    
    MasterPassword = input$masterPassword
    if(file.exists(paste0(path,"Database"))){
      if ( is_empty_input(MasterPassword)
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else{
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) 
          shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        
        else {
          
          new_passphrase <- charToRaw(input$newMasterPasswordField)
          new_key <- openssl::sha256(new_passphrase)
          
          write.aes(database, paste0(path,"Database"), key = new_key)
          updateTextInput(inputId = "masterPassword", value = "")
          updateTextInput(inputId = "newMasterPasswordField", value = "")
          
          shinyalert("Success", "Master Password was \nsuccessfully changed !", type = "success")
          
          shinyjs::hide("newMasterPasswordField")
          shinyjs::hide("confirmNewMasterPass")
          shinyjs::hide("cancelNewMasterPass")
          shinyjs::hide("showhideMasterPasswordField")
        }
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }}
    else {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("newMasterPasswordField")
      shinyjs::hide("confirmNewMasterPass")
      shinyjs::hide("cancelNewMasterPass")
    }
    
  })
  
  observeEvent(input$cancelNewMasterPass,{
    shinyjs::hide("newMasterPasswordField")
    shinyjs::hide("confirmNewMasterPass")
    shinyjs::hide("cancelNewMasterPass")
  })
  
  #### Add new account type ----
  observeEvent(input$new_type,{
    shinyjs::show("addNewType")
    shinyjs::show("confirmNewType")
    shinyjs::show("cancelNewType")
  })
  
  observeEvent(input$cancelNewType,{
    updateTextInput(inputId = "addNewType", value = "")
    shinyjs::hide("addNewType")
    shinyjs::hide("confirmNewType")
    shinyjs::hide("cancelNewType")
  })
  
  observeEvent(input$confirmNewType,{
    new_type = input$addNewType
    if(is_empty_input(new_type)) shinyalert("Alert", "Please input new account type !", type = "error")
    else {
      categories <<- c(categories, new_type)
      updateSelectInput(inputId = "type", choices = categories, 
                        selected = new_type)
      shinyalert("Success", "You added new non-permanent account type !", type = "success")
      updateTextInput(inputId = "addNewType", value = "")
      shinyjs::hide("addNewType")
      shinyjs::hide("confirmNewType")
      shinyjs::hide("cancelNewType")
    }
  })
  
  #### Show-Hide Password ----
  observeEvent(input$showPass, {
    Password = input$password
    updateTextInput(inputId = "showhidePasswordField",
                    label = NULL,
                    value = input$password
    )
    
    shinyjs::show("showhidePasswordField")
  })
  
  
  observeEvent(input$hidePass, {
    updateTextInput(inputId = "showhidePasswordField", value = "")
    shinyjs::hide("showhidePasswordField")
  })
  
  output$password2clipboard = renderUI({
    rclipboard::rclipButton(
      inputId = "copyPassword2clipboard",
      label = "Copy to Clipboard",
      clipText = input$password,
      icon = icon("clipboard"),
      style = "background:#b3b3ff;color:#404040;"
    )
  })
  
  output$login2clipboard = renderUI({
    rclipboard::rclipButton(
      inputId = "copyPassword2clipboard",
      label = "Copy to Clipboard",
      clipText = input$login,
      icon = icon("clipboard"),
      style = "background:#b3b3ff;color:#404040;"
    )
  })
  
  ### Paste ----
  observeEvent(input$pasteLogin,{
    username = input$randomUsername
    if(is_empty_input(username)) shinyalert("Alert", "Please Generate username !", type = "error")
    else updateTextInput(inputId = "login",
                         value = paste0(username))
  })
  
  observeEvent(input$pastePassword,{
    pass = input$randomPassword
    if(is_empty_input(pass)) shinyalert("Alert", "Please Generate password !", type = "error")
    else updateTextInput(inputId = "password",
                         value = paste0(pass))
  })
  
  #### Save Record ----
  observeEvent(input$saveRecord, {
    AccountType = input$type
    MasterPassword = input$masterPassword
    Profile = input$profile
    Login = input$login
    Password = input$password
    
    if(file.exists(paste0(path,"Database"))){
      
      if (
        is_empty_input(MasterPassword) |
        is_empty_input(Profile) |
        is_empty_input(Login) |
        is_empty_input(Password)
        
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile, Login and Password !", type = "error")
      else{
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) 
          shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          if(any(Profile == database$Profile) & any(Login == database$Login) ) shinyalert("Alert", "This records alredy exists !\n Profile and Login information is in Database !", type = "error")
          else {
            record = c(AccountType, Profile, Login, Password)
            database = rbind(database, record)
            
            write.aes(database, paste0(path,"Database"), key = key)
            
            shinyalert("Success", "Record successfully added to the database !", type = "success")
            
            output$Database = renderDataTable({
              #reload_database_table(input$masterPassword, path)
              
              DT::datatable(reload_database_table(input$masterPassword, path), 
                            rownames = FALSE, selection = "none",
                            options = list(
                              "columnDefs" = list(
                                list(
                                  "targets" = c(3),
                                  "createdCell" = JS(js),
                                  className = 'dt-left'
                                ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
              
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
            
            if(input$masterPasswordOptions != "Keep") 
              updateTextInput(inputId = "masterPassword", value = "")
            #shinyjs::hide("showhideMasterPasswordField")
            
          }}}} else {
            
            if (
              is_empty_input(MasterPassword) |
              is_empty_input(Profile) |
              is_empty_input(Login) |
              is_empty_input(Password)
              
            ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile, Login and Password !", type = "error")
            else {
              passphrase <- charToRaw(MasterPassword)
              key <- openssl::sha256(passphrase)
              
              database = data.frame(matrix(nrow = 0, ncol = 3))
              database = cbind("------","------","------","------")
              colnames(database) = c("Account_Type","Profile", "Login", "Password")
              record = c(AccountType, Profile, Login, Password)
              database = rbind(database, record)
              
              write.aes(database, paste0(path,"Database"), key = key)
              shinyalert("Success", "You have created new \n Encrypted password database !", type = "success")
              
              output$Database = DT::renderDT({
                #reload_database_table(input$masterPassword, path)
                
                DT::datatable(reload_database_table(input$masterPassword, path), 
                              rownames = FALSE, selection = "none",
                              options = list(
                                "columnDefs" = list(
                                  list(
                                    "targets" = c(3),
                                    "createdCell" = JS(js),
                                    className = 'dt-left'
                                  ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
                
              })
              
              shinyjs::hide(id = "searchProfileField")
              shinyjs::hide(id = "searchLogin")
              shinyjs::hide(id = "searchLoginField")
              shinyjs::hide(id = "loadRecord")
              shinyjs::hide(id = "closeSearch") 
              
              if(input$masterPasswordOptions != "Keep") 
                updateTextInput(inputId = "masterPassword", value = "")
              
            }}
    
  })
  
  #### Delete Record ----
  observeEvent(input$deleteRecord, {
    
    if(!file.exists(paste0(path,"Database")))
    {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmDeleteRecord")
      shinyjs::hide("cancelDeleteRecord")
      shinyjs::show("deleteRecord")
      
    }
    
    else {  
      AccountType = input$type
      MasterPassword = input$masterPassword
      Profile = input$profile
      Login = input$login
      Password = input$password
      
      if ( is_empty_input(MasterPassword) |
           is_empty_input(Profile) |
           is_empty_input(Login) |
           is_empty_input(Password)
           
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile and Login !", type = "error")
      else{
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          for_deletion = subset(database, Profile == input$profile & Login == input$login)
          
          if (nrow(for_deletion) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmDeleteRecord")
            shinyjs::hide("cancelDeleteRecord")    
            shinyjs::show("deleteRecord")
            
          }
          else {
            
            shinyjs::show("confirmDeleteRecord")
            shinyjs::show("cancelDeleteRecord")
            shinyjs::hide("deleteRecord")
            
          }
          
        }
        
        if(input$masterPasswordOptions != "Keep")
          updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      } }
    
  })
  
  #### Confirm Delete Record ----
  observeEvent(input$confirmDeleteRecord, {
    
    if(!file.exists(paste0(path,"Database")))
    {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmDeleteRecord")
      shinyjs::hide("cancelDeleteRecord")
      shinyjs::show("deleteRecord")
    }
    
    else {
      AccountType = input$type
      MasterPassword = input$masterPassword
      Profile = input$profile
      Login = input$login
      Password = input$password
      
      if ( is_empty_input(MasterPassword) |
           is_empty_input(Profile) |
           is_empty_input(Login) |
           is_empty_input(Password)
           
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile and Login !", type = "error")
      else{
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) 
          shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          for_deletion = subset(database, Profile == input$profile & Login == input$login)
          
          if (nrow(for_deletion) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmDeleteRecord")
            shinyjs::hide("cancelDeleteRecord")
            shinyjs::show("deleteRecord")
            
          }
          else {
            id <- as.numeric(rownames(for_deletion))
            
            write.aes(database[-id,], paste0(path,"Database"), key = key)
            
            shinyalert("Success", "You have deleted this record !", type = "success")
            shinyjs::hide("confirmDeleteRecord")
            shinyjs::hide("cancelDeleteRecord")
            shinyjs::show("deleteRecord")
            
            
            output$Database = DT::renderDT({
              #reload_database_table(input$masterPassword, path)
              
              DT::datatable(reload_database_table(input$masterPassword, path), 
                            rownames = FALSE, selection = "none",
                            options = list(
                              "columnDefs" = list(
                                list(
                                  "targets" = c(3),
                                  "createdCell" = JS(js),
                                  className = 'dt-left'
                                ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
              
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }
          
        }
        
        if(input$masterPasswordOptions != "Keep")
          updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }}
    
  })
  #### Cancel Delete ----
  observeEvent(input$cancelDeleteRecord,{
    shinyjs::hide("confirmDeleteRecord")
    shinyjs::hide("cancelDeleteRecord")
    shinyjs::show("deleteRecord")
    
  })
  
  #### Edit Record ----
  observeEvent(input$editRecord,{
    
    if(!file.exists(paste0(path,"Database")))
      
    {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmEditRecord")
      shinyjs::hide("cancelEditRecord")
      shinyjs::show("editRecord")
      
    }
    else {
      AccountType = input$type
      MasterPassword = input$masterPassword
      Profile = input$profile
      Login = input$login
      Password = input$password
      
      if ( is_empty_input(MasterPassword) |
           is_empty_input(Profile) |
           is_empty_input(Login) |
           is_empty_input(Password)
           
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile, Login and Password !", type = "error")
      else{
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          for_edit <<- subset(database, Profile == input$profile & Login == input$login)
          
          if (nrow(for_edit) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmEditRecord")
            shinyjs::hide("cancelEditRecord")
            shinyjs::show("editRecord")
          }
          else {
            
            shinyjs::show("confirmEditRecord")
            shinyjs::show("cancelEditRecord")
            shinyjs::hide("editRecord")
            
          }}
        
        
        if(input$masterPasswordOptions != "Keep")
          updateTextInput(inputId = "masterPassword", value = "")
      }}
    
  })
  
  #### Confirm Edit Record ----
  observeEvent(input$confirmEditRecord, {
    
    if(!file.exists(paste0(path,"Database")))
    {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmEditRecord")
      shinyjs::hide("cancelEditRecord")
      shinyjs::show("editRecord")
      
      
    }
    else {
      
      AccountType = input$type
      MasterPassword = input$masterPassword
      Profile = input$profile
      Login = input$login
      Password = input$password
      
      if ( is_empty_input(MasterPassword) |
           is_empty_input(Profile) |
           is_empty_input(Login) |
           is_empty_input(Password)
           
           
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Profile, Login and Password !", type = "error")
      else{
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          if (nrow(for_edit) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmEditRecord")
            shinyjs::hide("cancelEditRecord")
            shinyjs::show("editRecord")
            
          }
          else {
            for_edit$AccountType = input$Account_Type
            for_edit$Profile = input$profile
            for_edit$Login = input$login
            for_edit$Password = input$password
            id <- as.numeric(rownames(for_edit))
            database[id,] = for_edit
            for_edit$AccountType <<- "I"
            for_edit$Profile <<- "love"
            for_edit$Login <<- "YuPass"
            for_edit$Password <<- "!"
            write.aes(database, paste0(path,"Database"),key = key)
            
            shinyalert("Success", "You have edited this record !", type = "success")
            shinyjs::hide("confirmEditRecord")
            shinyjs::hide("cancelEditRecord")
            shinyjs::show("editRecord")
            
            output$Database = DT::renderDT({
              #reload_database_table(input$masterPassword, path)
              
              DT::datatable(reload_database_table(input$masterPassword, path), 
                            rownames = FALSE, selection = "none",
                            options = list(
                              "columnDefs" = list(
                                list(
                                  "targets" = c(3),
                                  "createdCell" = JS(js),
                                  className = 'dt-left'
                                ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
              
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }}
        
        
        if(input$masterPasswordOptions != "Keep")
          updateTextInput(inputId = "masterPassword", value = "")
      }}
  })
  #### Cancel Edit ----
  observeEvent(input$cancelEditRecord,{
    shinyjs::hide("confirmEditRecord")
    shinyjs::hide("cancelEditRecord")
    shinyjs::show("editRecord")
    
  })
  
  #### Search Profile ----
  observeEvent(input$searchProfile,{
    
    if(!file.exists(paste0(path,"Database")))
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    
    else {
      MasterPassword = input$masterPassword
      
      if (
        is_empty_input(MasterPassword)) 
        shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else{
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          if(nrow(database) == 1) shinyalert("Alert", "Encrypted Database is empty !\n No records are present in the Database !", type = "error")
          else{
            profiles = database$Profile
            profiles = profiles[2:length(profiles)]
            #profiles[1] = "You can delete and type :)"
            
            output$searchBarProfile = renderUI({
              
              selectInput(inputId = "searchProfileField",
                          label = NULL,
                          choices = profiles,
                          #selected = profiles[1],
                          selectize = T)
            })
            
            shinyjs::show("searchLogin")
            
            mode = input$masterPasswordOptions
            if(mode == "Keep") return()
            else updateTextInput(inputId = "masterPassword", value = "")
          }}
      }}
    
    
  })
  
  #### Search Logins ----
  observeEvent(input$searchLogin,{
    if(!file.exists(paste0(path,"Database")))
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    
    else {
      MasterPassword = input$masterPassword
      if (
        is_empty_input(MasterPassword)
        
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else{
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          logins = subset(database, Profile == input$searchProfileField)
          logins = logins$Login
          
          output$searchBarLogin = renderUI({
            div(id = "searchBarLoginStyle",
                selectInput(inputId = "searchLoginField",
                            label = NULL,
                            choices = logins,
                            selected = logins[1],
                            selectize = T 
                )
            )
            
          })
          
          shinyjs::show("loadRecord")
          shinyjs::show("closeSearch")
          
          
          if(input$masterPasswordOptions != "Keep") 
            updateTextInput(inputId = "masterPassword", value = "")
          #shinyjs::hide("showhideMasterPasswordField")
        }
      }}
  })
  
  #### Load Record ----
  observeEvent(input$loadRecord,{
    
    if(!file.exists(paste0(path,"Database")))
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    else{
      
      MasterPassword = input$masterPassword
      if (is_empty_input(MasterPassword) ) 
        shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else{
        updateTextInput(inputId = "profile",
                        value = input$searchProfileField)
        updateTextInput(inputId = "login",
                        value = input$searchLoginField)
        
        MasterPassword = input$masterPassword
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          to_load = subset(database, Profile == input$searchProfileField & 
                             Login == input$searchLoginField)
          password = to_load$Password
          account = to_load$Account_Type
          updateTextInput(inputId = "password",
                          value = password)
          updateSelectInput(inputId = "type",
                            selected = account)
        }}}
  })
  
  
  #### Close Search ----
  observeEvent(input$closeSearch,{
    
    shinyjs::hide(id = "searchProfileField")
    shinyjs::hide(id = "searchLogin")
    shinyjs::hide(id = "searchLoginField")
    shinyjs::hide(id = "loadRecord")
    shinyjs::hide(id = "closeSearch")    
    
  })
  
  
  #### Download Database ----
  output$downloadDatabase <- downloadHandler(
    filename = function() {
      adj_time = Sys.time()
      attr(adj_time, "tzone") <- ("Europe/Berlin")
      paste(
        format(adj_time, "%d-%b-%Y_%Hh-%Mmin"),
        sep = ""
      )
    },
    content = function(file) {
      MasterPassword = input$masterPassword
      if(!file.exists(paste0(path,"Database")))
        shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      else {
        if (
          is_empty_input(MasterPassword)) 
          shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
        else {
          passphrase <- charToRaw(MasterPassword)
          key <- openssl::sha256(passphrase)
          
          database = read.aes(paste0(path,"Database"), key = key)
          if(!all(colnames(database) == c("Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
          else write.aes(database, file, key = key)
        }
      }
    })
  
  #### Remove Duplicates ----
  observeEvent(input$removeDuplicates,{
    
    MasterPassword = input$masterPassword
    if(!file.exists(paste0(path,"Database")))
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    else {
      if (is_empty_input(MasterPassword)
          
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else {
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database"), key = key)
        if(!all(colnames(database) == c("Account_Type","Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          database = unique(database)
          write.aes(database, paste0(path,"Database"), key=key)
          
          shinyalert("Success", "You have successfully removed all duplicates !", type = "success")
          
          output$Database = DT::renderDT({
            #reload_database_table(input$masterPassword, path)
            
            DT::datatable(reload_database_table(input$masterPassword, path), 
                          rownames = FALSE, selection = "none",
                          options = list(
                            "columnDefs" = list(
                              list(
                                "targets" = c(3),
                                "createdCell" = JS(js),
                                className = 'dt-left'
                              ) ) ))%>% DT::formatStyle(columns = names(data), color="white")
            
          })
        }
      }}
  })
  #### User manual ----
  observeEvent(input$userManual,{
    
    shinyjs::show(id = "userManualText")
    
    output$userManualText = renderText({
      br()
      user_manual
    })
    
    output$hideUserManual = renderUI({
      br()
      fluidRow(
        column(width = 4,
               offset = 3,
               actionButton("hideUserManualButton", "Close User manual", 
                            icon = icon("book"),
                            style = "background:#b366ff;color:#404040;margin-top:10px")
        ))
    })
    
  })
  
  observeEvent(input$hideUserManualButton, {
    shinyjs::hide(id = "userManualText")
    shinyjs::hide(id = "hideUserManualButton")
    
  })
  
  #### Username Generator ----
  observeEvent(input$generateUsername,{
    
    username = username_generator(input$letterCount, input$wordCount)
    
    shinyjs::show(id = "randomUsername")
    shinyjs::show(id = "copyRandomUsername2clipboard")
    shinyjs::show(id = "turnOffUsername")
    shinyjs::show(id = "appendNum")
    
    updateTextInput(inputId = "randomUsername",
                    value = paste0(username,input$appendNum))
    
    observeEvent(input$appendNum,{
      updateTextInput(inputId = "randomUsername",
                      value = paste0(username,input$appendNum))
    })
    
    
    output$randomUsername2clipboard <- renderUI({
      rclipboard::rclipButton(
        inputId = "copyRandomUsername2clipboard",
        label = "Copy to Clipboard",
        clipText = paste0(username,input$appendNum),
        icon = icon("clipboard"),
        style = "background:#ff99cc;color:#404040;"
      )
    })
    
    shinyjs::show("turnOffUsername")
  })
  
  
  #### Turn off Username Generator ----
  observeEvent(input$turnOffUsername,{
    updateTextInput(inputId = "appendNum", value = "")
    updateTextInput(inputId = "randomUsername", value = "")
    shinyjs::hide(id = "randomUsername")
    shinyjs::hide(id = "appendNum")
    shinyjs::hide(id = "copyRandomUsername2clipboard")
    shinyjs::hide(id = "turnOffUsername")
    
  })
  
  #### Password Generator ----
  observeEvent(input$generatePassword,{
    
    pass = password_generator(input$randomPasswordType, input$passwordLength)                    
    
    shinyjs::show(id = "randomPassword")
    shinyjs::show(id = "copyRandomPassword2clipboard")
    shinyjs::show(id = "turnOffPassword")
    
    updateTextInput(inputId = "randomPassword",
                    value = pass)
    
    
    output$randomPassword2clipboard <- renderUI({
      rclipboard::rclipButton(
        inputId = "copyRandomPassword2clipboard",
        label = "Copy to Clipboard",
        clipText = pass,
        icon = icon("clipboard"),
        style = "background:#ff99cc;color:#404040;"
      )
    })
    
    shinyjs::show("turnOffPassword")
    
  })
  
  #### Turn off Password Generator ----
  observeEvent(input$turnOffPassword,{
    updateTextInput(inputId = "randomPassword", value = "")
    shinyjs::hide(id = "randomPassword")
    shinyjs::hide(id = "copyRandomPassword2clipboard")
    shinyjs::hide(id = "turnOffPassword")
    
  })
  
}

shinyApp(ui = ui, server = server)
