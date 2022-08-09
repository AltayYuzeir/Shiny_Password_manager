<img src="YuCrypt-logo.png" align="right" width=120 height=139 alt="" />

# YuCrypt - Password manager
This is a simple and lightweight Password manager built with R and Shiny.\
The main goal of this app is to enable seemless interaction with your encrypted password database.

# Setup
Option 1: Hosted locally (Recommended)
1. Download all provided files and create a folder "www" where the app.R file is located. Put inside "www" the logo.png for proper visualization.
2. Download the [shinyShortcut](https://cran.r-project.org/web/packages/shinyShortcut/README.html) package and follow the instructions. You will get a standalone .VBS executable file which can be executed without R or RStudio being open.
3. Read the provided in-app user manual at least once :)

Option 2: Hosted online, e.g. shinyapps.io
1. Download all files and create an account in shinyapps.io and follow their instructions furter.
2. Here you will need a persistant data storage solution. One possibilty is to host your database in Dropbox with the help of the [rdrop2](https://cran.r-project.org/web/packages/rdrop2/) package. You can create access keys (tokens) which can allow your Shiny app to read and write files from and to your Dropbox folder.
3. You will need to modify the code a bit. You will need the special functions for reading the encrypted database from Dropbox _drop_read.aes_ by providing the database filename, encryption key and Dropbox access token. Once you have done changes to the database, you create file in the virtual environment with _write.aes_ function and you upload it to Dropbox with _drop_upload_ by providing name and Dropbox token.

# Acknowledgements and my thanks
1. To the creators of the [EncryptDF](https://github.com/UW-L-S-Academic-Information-Management/EncryptDF) package. I have modified their code a bit for our purposes. Thanks to them we have the backbone of the our app - the encrypted password database.
2. To the creators of the [rclipboard](https://github.com/sbihorel/rclipboard/) package. It was really useful for this project with the random username and passwords.
3. To the creator(s) of the [Words](mailto:condwanaland@gmail.com) package. It was especially useful for our random username generator. Nice resource to have.
