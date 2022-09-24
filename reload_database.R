
reload_database_table = function(Master_Password, data_path){
  path = data_path
  new_datatable = matrix(nrow = 1, ncol = 2)
  new_datatable = data.frame(new_datatable)
  colnames(new_datatable) = c("Profile", "Login")
  MasterPassword = Master_Password
  if(is_empty_input(MasterPassword))
  {
    new_datatable$Profile[1] = "Please provide"
    new_datatable$Login[1] = "Master password !"
    return(new_datatable)
  } else{
    
    passphrase <- charToRaw(MasterPassword)
    key <- openssl::sha256(passphrase)
    if(file.exists(paste0(path,"Database"))){
      database = read.aes(paste0(path,"Database"), key = key)
      if( !all(colnames(database) == c("Profile", "Login", "Password") ) )
      {
        new_datatable$Profile[1] = "Please provide correct"
        new_datatable$Login[1] = "Master password !"
        return(new_datatable)
      } else {
        if(nrow(database) == 1)
        {
          new_datatable$Profile[1] = "No records exist"
          new_datatable$Login[1] = "in the Database !"
          return(new_datatable)
        } else{
          new_datatable2 = database$Profile[2:length(database$Profile)]
          new_datatable3 = database$Login[2:length(database$Login)]
          new_datatable = as.data.frame(cbind(new_datatable2,new_datatable3))
          colnames(new_datatable) = c("Profile", "Login")
          return(new_datatable)
        }
      }
    } else
    {
      new_datatable$Profile[1] = "Encrypted Database"
      new_datatable$Login[1] = "does not exist !"
      return(new_datatable)
    }
  }
}