library(shiny)
#library(rclipboard) # for 'Copy to Clipboard' buttons
library(shinyWidgets) # for setting background color of UI elements
#library(shinytitle)
library(shinyalert) # fancy alerts for success and failure
#library(shinyjs) # to hide and show UI elements 
#library(openssl) # to create our encryption key
#library(rdrop2)
#library(digest)
#library(words) # database to use for random password generator
#library(dplyr)
#library(stringr)

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

categories <<- c("Web account",
                 "Email",
                 "Credit card",
                 "Bank details",
                 "Healthcare account",
                 "Bills acount",
                 "Tax account",
                 "Pension account",
                 "Insurance account",
                 "Streaming account",
                 "Gaming account",
                 "Shopping account",
                 "Wifi account",
                 "Other")

#### UI ----
ui = fluidPage(   
  
  setBackgroundColor("#404040"), # #93c2eb
  #setBackgroundColor("#93c2eb"), # #93c2eb
  
  rclipboard::rclipboardSetup(),
  
  titlePanel(div(img(src = "YuPass-logo.png", height = 100, width = 100),
                 span("YuPass - Password Manager app", style = "color:white;"))),
  
  title = shinytitle::use_shiny_title(),
  
  
  sidebarLayout(
    sidebarPanel(
      Sidebar_items,
      width = 4
    ),
    #### Main panel ----
    mainPanel(
      shinyjs::useShinyjs(),
      tags$head(tags$style(
        HTML("hr {border-top: 1px solid #ffffff;}")
      )),
      tabsetPanel(type = "tabs",
                  tabPanel(span(style = "color:#9999ff;font-weight:bold;",
                                "User Interface"), 
                           uiOutput("UserInterface"),
                           icon = span(style = "color:#9999ff;font-weight:bold;",
                                       icon("keyboard"))
                  ),
                  tabPanel(span(style = "color:#cc6699;font-weight:bold;",
                                "Database Table"), 
                           p(),
                           p(span(style ="color:#888888;font-weight:bold;",
                                  'If you see message starting with "Error:", your Master password is wrong !')),
                           span(style = "color:#cc6699;font-weight:bold;font-family:'Lucida Console';",
                                dataTableOutput("Database")
                           ),
                           hr(),
                           
                           div(style="text-align:center; color: #80b3ff", tags$b("Copyright"),icon("copyright"),
                               tags$b("2022-2022"),br(), tags$b("Altay Yuzeir"),
                               tags$a(href ="https://github.com/AltayYuzeir/Shiny_Password_manager",
                                      tags$b(tags$span(style = "color: #80b3ff", icon("github"), "GitHub")),
                                      target = "_blank")),
                           
                           icon = span(style = "color:#cc6699;font-weight:bold;",
                                       icon("table"))
                  )
      )
    )
  )  
)

#### Server ----
server = function(input, output, session) {
  
  output$UserInterface = renderUI({
    UserInterface_items
  })
  
  # Database tab ----
  output$Database = renderDataTable({
    reload_database_table(input$masterPassword, path)
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
    shinyjs::show("addNewTypeLabel")
    shinyjs::show("confirmNewType")
    shinyjs::show("cancelNewType")
  })
  
  observeEvent(input$cancelNewType,{
    updateTextInput(inputId = "addNewType", value = "")
    shinyjs::hide("addNewTypeLabel")
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
      shinyjs::hide("addNewTypeLabel")
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
    ###############
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
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
            mode = input$masterPasswordOptions
            if(mode == "Keep") return()
            else updateTextInput(inputId = "masterPassword", value = "")
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
              
              output$Database = renderDataTable({
                reload_database_table(input$masterPassword, path)
              })
              
              shinyjs::hide(id = "searchProfileField")
              shinyjs::hide(id = "searchLogin")
              shinyjs::hide(id = "searchLoginField")
              shinyjs::hide(id = "loadRecord")
              shinyjs::hide(id = "closeSearch") 
              
              mode = input$masterPasswordOptions
              if(mode == "Keep") return()
              else updateTextInput(inputId = "masterPassword", value = "")
              
            }}
    
  })
  
  #### Delete Record ----
  observeEvent(input$deleteRecord,
               {
                 AccountType = input$type
                 MasterPassword = input$masterPassword
                 Profile = input$profile
                 Login = input$login
                 Password = input$password
                 if(file.exists(paste0(path,"Database"))){  
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
                         
                       }
                       else {
                         
                         shinyjs::show("confirmDeleteRecord")
                         shinyjs::show("cancelDeleteRecord")
                         
                       }
                       
                     }
                     
                     mode = input$masterPasswordOptions
                     if(mode == "Keep") return()
                     else updateTextInput(inputId = "masterPassword", value = "")
                     #shinyjs::hide("showhideMasterPasswordField")
                   } }
                 else {
                   shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
                   shinyjs::hide("confirmDeleteRecord")
                   shinyjs::hide("cancelDeleteRecord")
                 }
               })
  
  #### Confirm Delete Record ----
  observeEvent(input$confirmDeleteRecord, {
    AccountType = input$type
    MasterPassword = input$masterPassword
    Profile = input$profile
    Login = input$login
    Password = input$password
    if(file.exists(paste0(path,"Database"))){
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
            
          }
          else {
            id <- as.numeric(rownames(for_deletion))
            
            write.aes(database[-id,], paste0(path,"Database"), key = key)
            
            shinyalert("Success", "You have deleted this record !", type = "success")
            shinyjs::hide("confirmDeleteRecord")
            shinyjs::hide("cancelDeleteRecord")
            
            
            output$Database = renderDataTable({
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }
          
        }
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }}
    else {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmDeleteRecord")
      shinyjs::hide("cancelDeleteRecord")
      
    }
  })
  #### Cancel Delete ----
  observeEvent(input$cancelDeleteRecord,{
    shinyjs::hide("confirmDeleteRecord")
    shinyjs::hide("cancelDeleteRecord")
  })
  
  #### Edit Record ----
  observeEvent(input$editRecord,{
    AccountType = input$type
    MasterPassword = input$masterPassword
    Profile = input$profile
    Login = input$login
    Password = input$password
    if(file.exists(paste0(path,"Database"))){
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
            
          }
          else {
            
            shinyjs::show("confirmEditRecord")
            shinyjs::show("cancelEditRecord")
            
          }}
        
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
      }}
    else {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmEditRecord")
      shinyjs::hide("cancelEditRecord")
    }
    
  })
  
  #### Confirm Edit Record ----
  observeEvent(input$confirmEditRecord, {
    AccountType = input$type
    MasterPassword = input$masterPassword
    Profile = input$profile
    Login = input$login
    Password = input$password
    if(file.exists(paste0(path,"Database"))){
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
            
            output$Database = renderDataTable({
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchProfileField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }}
        
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
      }}
    else {
      shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      shinyjs::hide("confirmEditRecord")
      shinyjs::hide("cancelEditRecord")
      
    }
  })
  #### Cancel Edit ----
  observeEvent(input$cancelEditRecord,{
    shinyjs::hide("confirmEditRecord")
    shinyjs::hide("cancelEditRecord")
  })
  
  #### Search Profile ----
  observeEvent(input$searchProfile,{
    
    MasterPassword = input$masterPassword
    if(file.exists(paste0(path,"Database"))){
      if (
        is_empty_input(MasterPassword)
        
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
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
      }} else shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    
    
  })
  
  
  #### Search Logins ----
  observeEvent(input$searchLogin,{
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
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }
    }
  })
  
  #### Load Record ----
  observeEvent(input$loadRecord,{
    MasterPassword = input$masterPassword
    if (
      is_empty_input(MasterPassword)
      
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
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
      }}
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
      if(file.exists(paste0(path,"Database"))){
        if (
          is_empty_input(MasterPassword)
          
        ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
        else {
          passphrase <- charToRaw(MasterPassword)
          key <- openssl::sha256(passphrase)
          
          database = read.aes(paste0(path,"Database"), key = key)
          if(!all(colnames(database) == c("Profile", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
          else write.aes(database, file, key = key)
        }
      } else shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
    })
  
  #### Remove Duplicates ----
  observeEvent(input$removeDuplicates,{
    
    MasterPassword = input$masterPassword
    if(file.exists(paste0(path,"Database"))){
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
          
          output$Database = renderDataTable({
            reload_database_table(input$masterPassword, path)
          })
        }
      }} else shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
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
    updateTextInput(inputId = "randomUsername", value = "")
    updateTextInput(inputId = "appendNum", value = "")
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
