drop_read.aes = function(filename, key, file, dest = tempdir(), 
                         dtoken = get_dropbox_token(), ...){
  
  require(rdrop2)
  localfile = paste0(dest, "/", basename(filename))
  drop_download(filename, localfile, overwrite = TRUE, dtoken = dtoken)
  
  require(digest)
  dat <- readBin(filename, "raw", n = 1000)
  aes <- AES(key, mode = "ECB")
  raw <- aes$decrypt(dat, raw = TRUE)
  txt <- rawToChar(raw[raw > 0])
  read.csv(text = txt)
}

read.aes = function (filename, key) # from EncryptDF package from GitHub
{
  require(digest)
  dat <- readBin(filename, "raw", n = 1000)
  aes <- AES(key, mode = "ECB")
  raw <- aes$decrypt(dat, raw = TRUE)
  txt <- rawToChar(raw[raw > 0])
  read.csv(text = txt, row.names=NULL)
}


write.aes = function (df, filename, key) # modified from EncryptDF package from GitHub
{
  require(digest)
  zz <- textConnection("out", "w", local = T)
  write.csv(df, zz, row.names = F)
  close(zz)
  out <- paste(out, collapse = "\n")
  raw <- charToRaw(out)
  raw <- c(raw, as.raw(rep(0, 16 - length(raw)%%16)))
  aes <- AES(key, mode = "ECB")
  aes$encrypt(raw)
  writeBin(aes$encrypt(raw), filename)
}

is_empty_input = function(x){
  require(stringr)
  if(x == "" |
     gsub(" ", "", x) == "" |
     stringr::str_replace_all(x,
                              c(
                                "\u000A" = "",
                                "\u0009" = "",
                                "\u0022" = "",
                                "\u000D" = "",
                                " " = ""
                              )) == ""
     ) return(TRUE)
  else return(FALSE)
}
