allRd <- list.files("./man")
for (i in allRd) { 


Rd <- file.path(paste0("C:/Users/Charles Watt/Desktop/UCONN RA/msDiaLogue/man/", i))

outfile <- paste0("help_files/", substr(i, 1, nchar(i)-3)  ,".html")

browseURL(Rd2HTML(Rd, outfile, package = "msDiaLogue",
                  stages = c("install", "render")))

}

