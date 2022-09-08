style = paste0("color:white;margin-left:0em;")

user_manual =  HTML(
  
  paste(
    tags$em(tags$b(
      span("User manual:", style = style)
    )),
    tags$em(
      span("1. Input Your Master Password to access the encrypted Database. Master Password is needed for every operation!", style = style)
    ),
    tags$em(
      span("2. You can Keep the Master Passward continuously, or Clear it after every operation.", style = style)
    ),
    tags$em(
      span("3. Encrypeted database will be created together with the first Record you provide.", style = style)
    ),
    tags$em(
      span("4. You can Edit a Record by providing Website and Login. You select Record to be edited and press Edit. You can change Website, Login and Password and then you need to Confirm the Edit procedure.", style = style)
    ),
    tags$em(
      span("5. You can Delete a Record by providing Website and Login. You need to confirm the Delete procedure.", style = style)
    ),
    tags$em(
      span("6. You can Search for Website in the Database. You can Delete and Type inside the Search field.", style = style)
    ),
    tags$em(
      span("7. You can Search for Logins of the chosen Website.", style = style)
    ),
    tags$em(
      span("8. You can Load the Record to visualize the Password.", style = style)
    ),
    tags$em(
      span("9. You can Close the Search section afterwards.", style = style)
    ),
    tags$em(
      span("10. You can Download the Encrypted Database.", style = style)
    ),
    tags$em(
      span("11. You can Remove the Duplicates from the Encrypted Database.", style = style)
    ),
    tags$em(
      span("12. You can use the Random Username Generator and the Random Password Generator to help you out.", style = style)
    ),
    tags$em(
      span("13. You can Generate many different Usernames and add Number at the end if you desire.", style = style)
    ),
    tags$em(
      span("14. You can Generate Passwords only with Letters and Numbers, or it can also contain Special characters.", style = style)
    ),
    tags$em(
      span("15. ALL Password Fields are displayed in a special font to improve readability between symbols such 0 (digit zero) and O (upper case o), and I (upper case i) and l (lower case L).", style = style)
    ),
    tags$em(
      span("16. You will need to Reload the Database Table upon Saving, Editing, Deleting or Removing duplicates.", style = style)
    ),
    sep = "<br/>"
  )
)
