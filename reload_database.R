
reload_database_table = function(Master_Password, data_path){
  
  path = data_path
  new_datatable = matrix(nrow = 1, ncol = 4)
  new_datatable = data.frame(new_datatable)
  colnames(new_datatable) = c("Account_Type","Profile", "Login", "Password")
  MasterPassword = Master_Password
  if(file.exists(paste0(path,"Database"))){
  
  if(is_empty_input(MasterPassword))
  {
    new_datatable$Account_Type[1] = "Error:"
    new_datatable$Profile[1] = "Please provide"
    new_datatable$Login[1] = "Master password !"
    new_datatable$Password[1] = ""
    return(new_datatable)
  } else{
    
    passphrase <- charToRaw(MasterPassword)
    key <- openssl::sha256(passphrase)
  
      database = read.aes(paste0(path,"Database"), key = key)
      if( !all(colnames(database) == c("Account_Type","Profile", "Login", "Password") ) )
      {
        new_datatable$Account_Type[1] = "Error:"
        new_datatable$Profile[1] = "Please provide correct"
        new_datatable$Login[1] = "Master password !"
        new_datatable$Password[1] = ""
        return(new_datatable)
      } else {
        if(nrow(database) == 1)
        {
          new_datatable$Account_Type[1] = "Error:"
          new_datatable$Profile[1] = "No records exist"
          new_datatable$Login[1] = "in the Database !"
          new_datatable$Password[1] = ""
          return(new_datatable)
        } else{
          new_datatable1 = database$Account_Type[2:length(database$Account_Type)]
          new_datatable2 = database$Profile[2:length(database$Profile)]
          new_datatable3 = database$Login[2:length(database$Login)]
          new_datatable4 = database$Password[2:length(database$Password)]
          new_datatable = as.data.frame(cbind(new_datatable1,new_datatable2,
                                              new_datatable3, new_datatable4))
          colnames(new_datatable) = c("Account_Type","Profile", "Login", "Password")
          return(new_datatable)
        }
      }
    }} else
    {
      new_datatable$Account_Type[1] = "Error:"
      new_datatable$Profile[1] = "Encrypted Database"
      new_datatable$Login[1] = "does not exist !"
      new_datatable$Password[1] = ""
      return(new_datatable)
    }
  
}