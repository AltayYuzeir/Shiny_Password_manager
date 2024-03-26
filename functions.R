read.aes = function (filename, key) # from EncryptDF package from GitHub
{
  require(digest)
  dat <- readBin(filename, "raw", n = 1000)
  aes <- AES(key, mode = "ECB")
  raw <- aes$decrypt(dat, raw = TRUE)
  txt <- rawToChar(raw[raw > 0])
  read.csv(text = txt, row.names=NULL)
}


write.aes = function (data, filename, key) # modified from EncryptDF package from GitHub
{
  require(digest)
  tmp <- textConnection("out", "w", local = T)
  write.csv(data, tmp, row.names = F)
  close(tmp)
  out <- paste(out, collapse = "\n")
  raw <- charToRaw(out)
  raw <- c(raw, as.raw(rep(0, 16 - length(raw)%%16)))
  aes <- AES(key, mode = "ECB")
  aes$encrypt(raw)
  writeBin(aes$encrypt(raw), filename)
}

is_empty_input = function(data){
  require(stringr)
  if(data == "" |
     gsub(" ", "", data) == "" |
     stringr::str_replace_all(data,
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

username_generator = function(letter_count, word_count){
  word_bank = words::words
  list = subset(word_bank, word_bank$word_length >= letter_count[1] & word_bank$word_length <= letter_count[2])
  
  index = sample(nrow(list), size = word_count)
  
  username = vector()
  j=1
  for(i in index){
    username[j] = list$word[i]
    j=j+1
  }
  username = stringr::str_to_title(username)
  username <- paste(username, collapse="")  
  return(username)
}

password_generator = function(password_type, password_length){
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
  
  passwordtype = password_type
  if(passwordtype == "Specials"){
    All <- c(A, B, C, D)
    All = sample(All, length(All))
  }else{
    All <- c(A, B, C)
    All = sample(All, length(All))
  }
  set.seed(round(runif(1,-5000,5000)))
  
  get_length = password_length
  
  pass <- vector(length=get_length)
  
  for (i in 1:get_length){
    pass[i] <- sample(All, 1)
  }
  pass <- paste(pass, collapse="")        
  
  return(pass)
}