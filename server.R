
library(shiny)
library(dplyr)
library(tidyr)

randomizeGolfers <- function(numdays, numgolfers, groupsize){
  numgroups <- numgolfers %/% groupsize
  if(numgolfers %% groupsize != 0){
    stop("group sizes would be uneven, guess you can't golf")
  }
    
  golferdf <- data.frame(day = sort(rep(1:numdays, numgolfers)),
                         golfer = NA,
                         group = NA)
  g <- 1
  for(i in 1:numdays){
    grps <- sort(rep(1:numgroups, groupsize))
    golferdf[g:(g+numgolfers-1), 'golfer'] <- sample(1:numgolfers,numgolfers)
    golferdf[g:(g+numgolfers-1), 'group'] <- grps
    g <- g + numgolfers
  }
  
  potentialgroups <- mutate(golferdf, daygrp = paste(day, group, sep="_"))
  return(potentialgroups)
}

verifyGolfGroups <- function(potentialgroups){
  g_wrong <- c()
  for(g in 1:length(unique(potentialgroups[['golfer']]))){
    dg <- filter(potentialgroups, golfer == g)[['daygrp']]
    match_grp <- filter(potentialgroups, daygrp %in% dg)
    if(length(which(duplicated(match_grp$golfer))) > 6){
      g_wrong <- c(g_wrong, g)
    }
  }
  return(g)
}

shinyServer(function(input, output) {
  
  formatGolfData <- eventReactive(input$go, {
    
    numgolfers <- input$numgolfers
    groupsize <- input$groupsize
    numdays <- input$numdays
    
    gbad <- 1:2
    x <- 0
    while(length(gbad) > 1){
      potentialgroups <- randomizeGolfers(numdays, numgolfers, groupsize)
      gbad <- verifyGolfGroups(potentialgroups)
      x <- x + 1
      print(x)
    }
    
    golfgroups <- as.data.frame(potentialgroups)
    golfgroups <- select(golfgroups, -daygrp)
    formattedgroups <- spread(golfgroups, day, group)
    names(formattedgroups)[-1] <- paste("Day", names(formattedgroups)[-1])
    return(formattedgroups)
  })

  output$view <- renderTable({
    formatGolfData()
  })
  
  output$title <- renderText({
    "Golf Group Assignments"
  })

})
