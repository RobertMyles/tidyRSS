data("feeds")
x <- list()

for(i in 1:length(feeds$feeds)){
  x[[i]] <- try(tidyfeed(feeds$feeds[[i]]), silent = FALSE)
  if(class(x[[i]]) == "try-error") print(paste0("Failure: ", feeds$feeds[[i]]))
  else print(paste0("Success: ", feeds$feeds[[i]]))
}
