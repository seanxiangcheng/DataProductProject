
library(shiny)
library(ggplot2)

shinyServer(function(input, output){
  
  randomdata <- reactive({  
    rawRanData <- cbind(X = rnorm(1000), Y = rnorm(1000))
    genCorr <- runif(1, -1, 1)
    
    mat <- diag(1, 2, 2)
    delta <- row(mat) - col(mat)
    mat[delta != 0] <- genCorr
    randomdata <- data.frame(rawRanData %*% chol(mat))
    names(randomdata) <- c("X", "Y")
    
    return(randomdata)
  })
  
  corData <- reactive({
    corData <- cor(randomdata())[1,2]
    return(as.numeric(corData))
  })

  
  output$plot <- renderPlot({
    if(input$NewPlot == 0){
      p <- ggplot(randomdata(), aes(x = X, y = Y))
      p <- p + theme_bw(base_size = 20) + geom_point()
      
      if(input$bestfit == TRUE){
        p <- p + stat_smooth(data = randomdata(), method = lm, se = FALSE, size = 1)
      }
      print(p)
    }
    else if(input$NewPlot != 0){
      p <- ggplot(randomdata(), aes(x = X, y = Y))
      p <- p + theme_bw(base_size = 24) + geom_point()
      if(input$bestfit == TRUE){
        p <- p + stat_smooth(data = randomdata(), method = lm, se = FALSE, size = 1)
      }
      print(p)
      
    }
    
  })
  output$coreff <- renderPrint({
    
    if(input$submit == 0){
      cat('<<--- Enter your Guess in the box to the left!\n')
    }
    isolate({
        if(((input$guess > corData() - .03 & input$guess < corData() + .03))) {
          cat('   Good job!\n', '  Correlation = ', round(corData(), 2))
        } else if(corData()*input$guess<0 & input$submit!=0) {
          cat('Watch out! Wrong sign! Try Again!')
        } else if(abs(input$guess)>1 & input$submit!=0){
          cat('Are you re-inventing correlation?! :) The number should be between -1 and 1 !!!')
        } 
        else{ if((corData() > 0 & input$guess < corData() - .03 & input$submit != 0) |
                   (corData() < 0 & input$guess > corData() - .03 & input$submit != 0)){
          cat('You underestimated the correlation! Try Again!')
        }  else {  if((corData() > 0 & input$guess > corData() + .03 & input$guess != 0) |
                      (corData() < 0 & input$guess < corData() + .03 & input$guess != 0)){ 
          cat('You overestimated the correlation! Try Again!')
        }}}
        
    })
  })

})