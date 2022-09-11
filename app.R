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
                               tags$b("2022-2022"),br(), tags$b("Altay Yuzeir")),
                           
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
    MasterPassword = input$masterPassword
    Website = input$website
    Login = input$login
    Password = input$password
    
    if (
      is_empty_input(MasterPassword) |
      is_empty_input(Website) |
      is_empty_input(Login) |
      is_empty_input(Password)
      
      
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Website, Login and Password !", type = "error")
    else{
      
      if(file.exists(paste0(path,"Database.ycpt"))){
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          if(any(Website == database$Website) & any(Login == database$Login) ) shinyalert("Alert", "This records alredy exists !\n Website and Login information is in Database !", type = "error")
          else {
            record = c(Website, Login, Password)
            database = rbind(database, record)
            
            write.aes(database, paste0(path,"Database.ycpt"), key = key)
            
            shinyalert("Success", "Record successfully added to the database !", type = "success")
            
            output$Database = renderDataTable({
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchWebsiteField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }}
        
      } else {
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = data.frame(matrix(nrow = 0, ncol = 3))
        database = cbind("------","------","------")
        colnames(database) = c("Website", "Login", "Password")
        record = c(Website, Login, Password)
        database = rbind(database, record)
        
        write.aes(database, paste0(path,"Database.ycpt"), key = key)
        shinyalert("Success", "You have created new \n Encrypted password database !", type = "success")
      }
      
      mode = input$masterPasswordOptions
      if(mode == "Keep") return()
      else updateTextInput(inputId = "masterPassword", value = "")
      #shinyjs::hide("showhideMasterPasswordField")
      
      
    }
  })
  
  #### Delete Record ----
  observeEvent(input$deleteRecord,
               {
                 
                 MasterPassword = input$masterPassword
                 Website = input$website
                 Login = input$login
                 Password = input$password
                 
                 if ( is_empty_input(MasterPassword) |
                      is_empty_input(Website) |
                      is_empty_input(Login) |
                      is_empty_input(Password)
                      
                 ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Website and Login !", type = "error")
                 else{
                   
                   passphrase <- charToRaw(MasterPassword)
                   key <- openssl::sha256(passphrase)
                   if(file.exists(paste0(path,"Database.ycpt"))){
                     database = read.aes(paste0(path,"Database.ycpt"), key = key)
                     if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
                     else {
                       
                       for_deletion = subset(database, Website == input$website & Login == input$login)
                       
                       if (nrow(for_deletion) == 0) {
                         shinyalert("No matches", "This record does not exist !", type = "info")
                         shinyjs::hide("confirmDeleteRecordButton")
                         shinyjs::hide("cancelDeleteRecordButton")
                         
                       }
                       else {
                         output$confirmDeleteRecord = renderUI({
                           actionButton("confirmDeleteRecordButton",
                                        "Confirm Delete", icon = icon("trash"),
                                        style = "background:#ff1a1a;color:#404040;margin-top:5px;")
                           
                           
                         })
                         
                         output$cancelDeleteRecord = renderUI({
                           actionButton("cancelDeleteRecordButton",
                                        "Cancel Delete", icon = icon("ban"),
                                        style = "background:#ccffcc;color:#404040;margin-top:5px;")
                         })
                       }
                       
                     }
                     
                     mode = input$masterPasswordOptions
                     if(mode == "Keep") return()
                     else updateTextInput(inputId = "masterPassword", value = "")
                     #shinyjs::hide("showhideMasterPasswordField")
                   }
                   else {
                     shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
                     shinyjs::hide("confirmDeleteRecordButton")
                     shinyjs::hide("cancelDeleteRecordButton")
                     
                   }
                 }
               })
  
  #### Confirm Delete Record ----
  observeEvent(input$confirmDeleteRecordButton, {
    MasterPassword = input$masterPassword
    Website = input$website
    Login = input$login
    Password = input$password
    
    if ( is_empty_input(MasterPassword) |
         is_empty_input(Website) |
         is_empty_input(Login) |
         is_empty_input(Password)
         
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Website and Login !", type = "error")
    else{
      
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      if(file.exists(paste0(path,"Database.ycpt"))){
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          for_deletion = subset(database, Website == input$website & Login == input$login)
          
          if (nrow(for_deletion) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmDeleteRecordButton")
            shinyjs::hide("cancelDeleteRecordButton")
            
          }
          else {
            id <- as.numeric(rownames(for_deletion))
            
            write.aes(database[-id,], paste0(path,"Database.ycpt"), key = key)
            
            shinyalert("Success", "You have deleted this record !", type = "success")
            shinyjs::hide("confirmDeleteRecordButton")
            shinyjs::hide("cancelDeleteRecordButton")
            
            if(nrow(database) == 2){
              shinyjs::hide(id = "searchWebsiteField")
              shinyjs::hide(id = "searchLogin")
              shinyjs::hide(id = "searchLoginField")
              shinyjs::hide(id = "loadRecord")
              shinyjs::hide(id = "closeSearch")    
            }
            
            output$Database = renderDataTable({
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchWebsiteField")
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
      }
      else {
        shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
        shinyjs::hide("confirmDeleteRecordButton")
        shinyjs::hide("cancelDeleteRecordButton")
        
      }
    }})
  #### Cancel Delete ----
  observeEvent(input$cancelDeleteRecordButton,{
    shinyjs::hide("confirmDeleteRecordButton")
    shinyjs::hide("cancelDeleteRecordButton")
  })
  
  #### Edit Record ----
  observeEvent(input$editRecord,{
    
    MasterPassword = input$masterPassword
    Website = input$website
    Login = input$login
    Password = input$password
    
    if ( is_empty_input(MasterPassword) |
         is_empty_input(Website) |
         is_empty_input(Login) |
         is_empty_input(Password)
         
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Website, Login and Password !", type = "error")
    else{
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      if(file.exists(paste0(path,"Database.ycpt"))){
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          for_edit <<- subset(database, Website == input$website & Login == input$login)
          
          if (nrow(for_edit) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmEditRecordButton")
            shinyjs::hide("cancelEditRecordButton")
            
          }
          else {
            output$confirmEditRecord = renderUI({
              actionButton("confirmEditRecordButton", "Confirm Edit", icon = icon("pen-clip"),
                           style = "background:#ff9933;color:#404040;margin-top:5px;")
            })
            
            output$cancelEditRecord = renderUI({
              actionButton("cancelEditRecordButton", "Cancel Edit", icon = icon("ban"),
                           style = "background:#ccffcc;color:#404040;margin-top:5px;")
            })
            
          }}
        
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
      }
      else {
        shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
        shinyjs::hide("confirmEditRecordButton")
        shinyjs::hide("cancelEditRecordButton")
      }
    }
  })
  
  #### Confirm Edit Record ----
  observeEvent(input$confirmEditRecordButton, {
    MasterPassword = input$masterPassword
    Website = input$website
    Login = input$login
    Password = input$password
    
    if ( is_empty_input(MasterPassword) |
         is_empty_input(Website) |
         is_empty_input(Login) |
         is_empty_input(Password)
         
         
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password, Website, Login and Password !", type = "error")
    else{
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      if(file.exists(paste0(path,"Database.ycpt"))){
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          if (nrow(for_edit) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmEditRecordButton")
            shinyjs::hide("cancelEditRecordButton")
            
          }
          else {
            for_edit$Website = input$website
            for_edit$Login = input$login
            for_edit$Password = input$password
            id <- as.numeric(rownames(for_edit))
            database[id,] = for_edit
            for_edit$Website <<- "I"
            for_edit$Login <<- "love"
            for_edit$Password <<- "YuPass !"
            write.aes(database, paste0(path,"Database.ycpt"),key = key)
            
            shinyalert("Success", "You have edited this record !", type = "success")
            shinyjs::hide("confirmEditRecordButton")
            shinyjs::hide("cancelEditRecordButton")
            
            output$Database = renderDataTable({
              reload_database_table(input$masterPassword, path)
            })
            
            shinyjs::hide(id = "searchWebsiteField")
            shinyjs::hide(id = "searchLogin")
            shinyjs::hide(id = "searchLoginField")
            shinyjs::hide(id = "loadRecord")
            shinyjs::hide(id = "closeSearch") 
            
          }}
        
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
      }
      else {
        shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
        shinyjs::hide("confirmEditRecordButton")
        shinyjs::hide("cancelEditRecordButton")
        
      }
    }})
  #### Cancel Edit ----
  observeEvent(input$cancelEditRecordButton,{
    shinyjs::hide("confirmEditRecordButton")
    shinyjs::hide("cancelEditRecordButton")
  })
  
  #### Search Website ----
  observeEvent(input$searchRecord,{
    
    MasterPassword = input$masterPassword
    
    if (
      is_empty_input(MasterPassword)
      
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
    else{
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      if(file.exists(paste0(path,"Database.ycpt"))){
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          if(nrow(database) == 1) shinyalert("Alert", "Encrypted Database is empty !\n No records are present in the Database !", type = "error")
          else{
            websites = database$Website
            websites = websites[2:length(websites)]
            #websites[1] = "You can delete and type :)"
            
            output$searchBarWebsite = renderUI({
              
              selectInput(inputId = "searchWebsiteField",
                          label = NULL,
                          choices = websites,
                          #selected = websites[1],
                          selectize = T)
            })
            
            output$searchLoginButton = renderUI({
              actionButton("searchLogin", "Search Logins", icon = icon("right-to-bracket"),
                           style = "background:#df9fbf;color:#404040;margin-top:5px;")
            })
            
            mode = input$masterPasswordOptions
            if(mode == "Keep") return()
            else updateTextInput(inputId = "masterPassword", value = "")
          }}
      } else shinyalert("Alert", "This Encrypted database does not exist !", type = "error")
      
    }
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
      
      database = read.aes(paste0(path,"Database.ycpt"), key = key)
      if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
      else {
        logins = subset(database, Website == input$searchWebsiteField)
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
        
        output$loadRecordButton = renderUI({
          actionButton("loadRecord", "Load Record", icon = icon("upload"),
                       style = "background:#df9fbf;color:#404040;margin-top:5px;")
        })
        
        output$closeSearchButton = renderUI({
          actionButton("closeSearch", "Close Search", icon = icon("circle-xmark"),
                       style = "background:#df9fbf;color:#404040;margin-top:5px;")
        })
        
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
      updateTextInput(inputId = "website",
                      value = input$searchWebsiteField)
      updateTextInput(inputId = "login",
                      value = input$searchLoginField)
      
      MasterPassword = input$masterPassword
      
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      
      database = read.aes(paste0(path,"Database.ycpt"), key = key)
      if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
      else {
        password = subset(database, Website == input$searchWebsiteField & 
                            Login == input$searchLoginField)
        password = password$Password
        updateTextInput(inputId = "password",
                        value = password)
      }}
  })
  
  
  #### Close Search ----
  observeEvent(input$closeSearch,{
    
    shinyjs::hide(id = "searchWebsiteField")
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
        '.ycpt',
        sep = ''
      )
    },
    content = function(file) {
      MasterPassword = input$masterPassword
      
      if (
        is_empty_input(MasterPassword)
        
      ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
      else {
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"Database.ycpt"), key = key)
        if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else write.aes(database, file, key = key)
      }
    }
  )
  
  #### Remove Duplicates ----
  observeEvent(input$removeDuplicates,{
    
    MasterPassword = input$masterPassword
    
    if (is_empty_input(MasterPassword)
        
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
    else {
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      
      database = read.aes(paste0(path,"Database.ycpt"), key = key)
      if(!all(colnames(database) == c("Website", "Login", "Password") )) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
      else {
        database = unique(database)
        write.aes(database, paste0(path,"Database.ycpt"), key=key)
        
        shinyalert("Success", "You have successfully removed all duplicates !", type = "success")
        
        output$Database = renderDataTable({
          reload_database_table(input$masterPassword, path)
        })
      }
    }
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
    shinyjs::show(id = "turnOffUsernameGenerator")
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
    
    output$turnOffUsernameGenerator = renderUI({
      actionButton("turnOffUsername", "Turn off Generator", icon = icon("power-off"),
                   style = "background:#d2a679;color:#404040")
    })
    
  })
  
  
  #### Turn off Username Generator ----
  observeEvent(input$turnOffUsername,{
    updateTextInput(inputId = "randomUsername", value = "")
    shinyjs::hide(id = "randomUsername")
    shinyjs::hide(id = "appendNum")
    shinyjs::hide(id = "copyRandomUsername2clipboard")
    shinyjs::hide(id = "turnOffUsernameGenerator")
    
  })
  
  #### Password Generator ----
  observeEvent(input$generatePassword,{
    
    pass = password_generator(input$randomPasswordType, input$passwordLength)                    
    
    shinyjs::show(id = "randomPassword")
    shinyjs::show(id = "copyRandomPassword2clipboard")
    shinyjs::show(id = "turnOffPasswordGenerator")
    
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
    
    output$turnOffPasswordGenerator = renderUI({
      actionButton("turnOffPassword", "Turn off Generator", icon = icon("power-off"),
                   style = "background:#d2a679;color:#404040")
    })
    
  })
  
  #### Turn off Password Generator ----
  observeEvent(input$turnOffPassword,{
    updateTextInput(inputId = "randomPassword", value = "")
    shinyjs::hide(id = "randomPassword")
    shinyjs::hide(id = "copyRandomPassword2clipboard")
    shinyjs::hide(id = "turnOffPasswordGenerator")
    
  })
  
}

shinyApp(ui = ui, server = server)
