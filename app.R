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


# Add your destination folder for permanent storage of your encrypted ledger
path = "C:/Users/Altay/Password_Manager/"
word_bank = words::words

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
                       div(id = "wordCount", radioButtons("wordCount", "Word count", choices = c(2,3,4),
                                                          selected = 2, inline = T)),
                       tags$style(type="text/css", "#wordCount {color:white;}")
                       
      ),
      column(
        width = 6,
        div(id = "appendNumLabel", textInput("appendNum", "Append your number", placeholder = "0049")),
        tags$style(type="text/css", "#appendNumLabel {color:white;}")
        
      )
      ),
      div(id  = "letterCount", sliderInput("letterCount", "Number of letters in a word in range", 
                                           min = 3, max = 14, value = c(4,12), step = 1)),
      tags$style(type="text/css", "#letterCount {color:white;}"),
      
      actionButton("generateUsername", "Generate Username", 
                   icon = icon("id-card-clip"),
                   style = "background:#8cd9b3;color:#404040;"),
      
      p(),
      div(id = "randomUsername", h5(textOutput('randomUsername'))),
      tags$style(type="text/css", "#randomUsername {color:white;font-family:;}"), #'Lucida Console'
      
      fluidRow(
        column(
          width = 6,
          uiOutput("randomUsername2clipboard")
          
        ),
        column(
          width = 6,
          uiOutput("turnOffUsernameGenerator")
        )
        
      ),
      
      #### Password generator ----
      hr(),
      span(h3("Random Password Generator"),style = "color:white"),
      #br(),
      div(id = "passwordLength",sliderInput("passwordLength", 
                                            label = "Length of Random Password",
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
      
      div(id = "randomPassword", h5(textOutput('randomPassword'))),
      tags$style(type="text/css", "#randomPassword {color:white;font-family:'Lucida Console'; }"), #  font-style: italic; font-family: 'Yusei Magic';
      #font-family:'Lucida Console';
      # font-family: 'Kirnberg';            
      
      
      fluidRow(
        column(
          width = 6,
          uiOutput("randomPassword2clipboard")
          
        ),
        column(
          width = 6,
          uiOutput("turnOffPasswordGenerator")
        )
        
      ),
      
      width = 4
    ),
    #### Main panel ----
    mainPanel(
      tags$head(tags$style(
        HTML("hr {border-top: 1px solid #ffffff;}")
      )),
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
          uiOutput("outputMasterPass"),
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
      
      hr(),
      div(id = "websiteLabel",textInput(inputId = "website",
                                        label = "Profile (website/credit card/other accounts):",
                                        placeholder = "bubble.com"
                                        
      )),
      tags$style(type="text/css", "#websiteLabel {color:white;}"),
      
      div(id = "loginLabel",textInput(inputId = "login",
                                      label = "Login (username/email/phone number):",
                                      placeholder = "SlowGenomics1337"
                                      
      )),
      tags$style(type="text/css", "#loginLabel {color:white;}"),
      
      div(id ="passwordLabel",passwordInput(inputId = "password",
                                            label = "Password:",
                                            placeholder = "D1r7D3v1LChub8yB3rRy",
                                            width = "60%"
                                            
      )),
      tags$style(type="text/css", "#passwordLabel {color:white;}"),
      
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
          uiOutput("outputPass"),
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
      br(),
      #hr(),
      shinyjs::useShinyjs()
      
    )
  )  
)

#### Server ----
server = function(input, output, session) {
  
  shinytitle::change_window_title(session, title = "YuPass")
  
  
  #### Show-Hide Master Password ----
  observeEvent(input$showMasterPass, {
    Password = input$masterPassword
    output$outputMasterPass = renderUI({
      textInput("showhideMasterPasswordField",
                label = NULL,
                value = Password)
    })
    shinyjs::show("showhideMasterPasswordField")
  })
  
  observeEvent(input$hideMasterPass, {
    updateTextInput(inputId = "showhideMasterPasswordField", value = "")
    shinyjs::hide("showhideMasterPasswordField")
  })
  
  #### Show-Hide Password ----
  observeEvent(input$showPass, {
    Password = input$password
    output$outputPass = renderUI({
      textInput("showhidePasswordField",
                label = NULL,
                value = Password,
                width = "100%")
    })
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
      
      if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          record = c(Website, Login, Password)
          database = rbind(database, record)
          
          write.aes(database, paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
          
          shinyalert("Success", "Record successfully added to the ledger !", type = "success")
        }
        
      } else {
        
        passphrase <- charToRaw(MasterPassword)
        key <- openssl::sha256(passphrase)
        
        database = data.frame(matrix(nrow = 0, ncol = 3))
        database = cbind("------","------","------")
        colnames(database) = c("Website", "Login", "Password")
        record = c(Website, Login, Password)
        database = rbind(database, record)
        
        write.aes(database, paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        shinyalert("Success", "You have created new \n Encrypted password ledger !", type = "success")
        
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
                   if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
                     database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
                     if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
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
                     shinyalert("Alert", "This Encrypted ledger does not exist !", type = "error")
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
      if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          
          for_deletion = subset(database, Website == input$website & Login == input$login)
          
          if (nrow(for_deletion) == 0) {
            shinyalert("No matches", "This record does not exist !", type = "info")
            shinyjs::hide("confirmDeleteRecordButton")
            shinyjs::hide("cancelDeleteRecordButton")
            
          }
          else {
            id <- as.numeric(rownames(for_deletion))
            write.aes(database[-id,], paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
            
            shinyalert("Success", "You have deleted this record !", type = "success")
            shinyjs::hide("confirmDeleteRecordButton")
            shinyjs::hide("cancelDeleteRecordButton")
            
          }
          
        }
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
        #shinyjs::hide("showhideMasterPasswordField")
      }
      else {
        shinyalert("Alert", "This Encrypted ledger does not exist !", type = "error")
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
      if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
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
        shinyalert("Alert", "This Encrypted ledger does not exist !", type = "error")
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
      if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
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
            write.aes(database, paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"),key = key)
            
            shinyalert("Success", "You have edited this record !", type = "success")
            shinyjs::hide("confirmEditRecordButton")
            shinyjs::hide("cancelEditRecordButton")
            
            
          }}
        
        
        mode = input$masterPasswordOptions
        if(mode == "Keep") return()
        else updateTextInput(inputId = "masterPassword", value = "")
      }
      else {
        shinyalert("Alert", "This Encrypted ledger does not exist !", type = "error")
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
      if(file.exists(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"))){
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else {
          websites = database$Website
          #websites = websites[2:length(websites)]
          websites[1] = "You can delete and type :)"
          
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
        }
      } else shinyalert("Alert", "This Encrypted ledger does not exist !", type = "error")
      
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
      
      database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
      if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
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
      
      database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
      if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
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
        
        database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
        if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
        else write.aes(database, file, key = key)
      }
    }
  )
  
  #### Remove Duplicates ----
  observeEvent(input$removeDuplicates,{
    
    MasterPassword = input$masterPassword
    
    if (          is_empty_input(MasterPassword)
                  
                  
    ) shinyalert("Alert", "Please fill out all fields: \n Master Password !", type = "error")
    else {
      passphrase <- charToRaw(MasterPassword)
      key <- openssl::sha256(passphrase)
      
      database = read.aes(paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key = key)
      if(ncol(database) != 3) shinyalert("Alert", "Wrong Master Password !\n Please input correct Master Password !", type = "error")
      else {
        database = unique(database)
        write.aes(database, paste0(path,"GybK8jhdwzMtFPwSErC1.ycpt"), key=key)
        
        shinyalert("Success", "You have successfully removed all duplicates !", type = "success")
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
    
    list = subset(word_bank, word_bank$word_length >= input$letterCount[1] & word_bank$word_length <= input$letterCount[2])
    
    index = sample(nrow(list), size = input$wordCount)
    
    username = vector()
    j=1
    for(i in index){
      username[j] = list$word[i]
      j=j+1
    }
    username = stringr::str_to_title(username)
    username <- paste(username, collapse="")  
    
    shinyjs::show(id = "randomUsername")
    shinyjs::show(id = "copyRandomUsername2clipboard")
    shinyjs::show(id = "turnOffUsernameGenerator")
    
    
    output$randomUsername = renderText({
      username = paste0(username,input$appendNum)
      username
      
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
  
  
  #### Turn off Password Generator ----
  observeEvent(input$turnOffUsername,{
    
    shinyjs::hide(id = "randomUsername")
    shinyjs::hide(id = "copyRandomUsername2clipboard")
    shinyjs::hide(id = "turnOffUsernameGenerator")
    
    
  })
  
  #### Password Generator ----
  observeEvent(input$generatePassword,{
    
    set.seed(round(runif(1,-5000,5000)))
    
    A <- LETTERS[1:26]
    A = sample(A, length(A))
    B <- letters[1:26]
    B = sample(B, length(B))
    C <- seq(0,9)
    # C <- c(seq(0,9),seq(0,9))
    C = sample(C, length(C))
    #ascii <- rawToChar(as.raw(0:127), multiple=TRUE)
    #D <-  ascii[grepl('[[:punct:]]', ascii)][c(1:23,25:32)]
    
    # Some special characters are not used as they are hard to read
    D = c("!","#","$","%","&","*","+","-","=","?","@","~","<",">","|",":",";")
    D = sample(D, length(D))
    
    passwordtype = input$randomPasswordType
    if(passwordtype == "Specials"){
      All <- c(A, B, C, D)
      All = sample(All, length(All))
    }else{
      All <- c(A, B, C)
      All = sample(All, length(All))
    }
    set.seed(round(runif(1,-5000,5000)))
    
    get_length = input$passwordLength
    
    pass <- vector(length=get_length)
    
    for (i in 1:get_length){
      pass[i] <- sample(All, 1)
    }
    pass <- paste(pass, collapse="")                            
    
    #output$pw <- renderPrint(noquote(pass))
    
    shinyjs::show(id = "randomPassword")
    shinyjs::show(id = "copyRandomPassword2clipboard")
    shinyjs::show(id = "turnOffPasswordGenerator")
    
    output$randomPassword <- renderText({
      pass
    })
    
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
    shinyjs::hide(id = "randomPassword")
    shinyjs::hide(id = "copyRandomPassword2clipboard")
    shinyjs::hide(id = "turnOffPasswordGenerator")
    
  })
  
}

shinyApp(ui = ui, server = server)
