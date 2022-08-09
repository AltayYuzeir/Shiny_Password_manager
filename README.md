<img src="YuCrypt-logo.png" align="right" width=120 height=139 alt="" />

# YuCrypt - Password manager

This is a simple and lightweight Password manager built with R and Shiny.\
The main goal of this app is to enable seemless interaction with your encrypted password ladger.\

# Setup
Option 1: Locally\
Step 1. Download all provided files.\
Step 2. Download the [shinyShortcut](https://cran.r-project.org/web/packages/shinyShortcut/README.html) package and follow the instructions. You will get a standalone .vbs executable file which can be executed without R or RStudio being open.\

Option 2: Hosted online, e.g. shinyapps.io\
Step 1: Download all files and create an account in shinyapps.io and follow their instructions furter.\
Step 2: Here you will need a persistant data storage solution. One possibilty is to host your ledger in Dropbox with the help of the [rdrop2](https://cran.r-project.org/web/packages/rdrop2/) package. You can create access keys (tokens) which can allow your Shiny app to read and write files from and to your Dropbox folder.
