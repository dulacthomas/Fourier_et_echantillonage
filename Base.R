
##Programme de visualisation de Fourier dans le cadre de mon stage d'été 2020
##Au CHU de Montpellier

scr_dir <- dirname(sys.frame(1)$ofile)
setwd(scr_dir)

library(ggplot2)
library(shiny)


##Toujours sur 10 sec
plot_basique<- function(input) {
  
  bruit <<- rnorm(1) ##VARIABLE GLOBALE
  

  freq <- input$freq
  nb_echant <- input$echant
  var <- input$varia
  harmo <- input$harmo
  
  echant_glob <- seq(from = 0, to = 1, length.out = 10000)
  echant_1 <- seq(from = 0, to = 1, length.out = nb_echant)
  
  sin_glob <- seq(0, 0, length.out = 10000)
  sin_1    <- seq(0, 0, length.out = nb_echant)
  
  for (i in 0:harmo) {
    
    sin_glob <- sin_glob + sin(2 * pi * freq * (1 + i) * echant_glob + i) * (1 - i*0.1)
    sin_1    <- sin_1    + sin(2 * pi * freq * (1 + i) * echant_1 + i)    * (1 - i*0.1)
  
  }
  
  if (input$bruh) {
    bruit <<- (input$pourcbruit/100) * rnorm(n = nb_echant) ##VARIAbLE GLOBALE
    sin_1 <- bruit + sin_1
  }
  
  df_glob <- data.frame(echant_glob, sin_glob)
  df_1    <- data.frame(echant_1, sin_1)
  
  p <- ggplot() 
  if ("tot" %in% var) {
    p <- p + geom_path(data = df_glob, aes(x  = echant_glob, y = sin_glob), color = "red") }
  if ("echant"  %in% var) {
    if(input$echant_ligne) {p <- p + geom_path(data = df_1, aes( x = echant_1, y = sin_1), color = "black") 
    } else { p <- p + geom_point(data = df_1, aes( x = echant_1, y = sin_1), color = "black") }
  }
  print(p)

  
  
}

plot_fourier <- function(input) {
  
    freq <- input$freq
    echant <- input$echant
    var <- input$varia
    harmo <- input$harmo

    echant_1 <- seq(from = 0, to = 1, length.out = echant)
    sin_1    <- seq(0, 0, length.out = echant)
    
    for (i in 0:harmo) {
      sin_1    <- sin_1    + sin(2 * pi * freq * (1 + i) * echant_1 + i)    * (1 - i*0.1)
    }
    
    if (input$bruh) {
      sin_1 <- bruit + sin_1
    }
    
  temp <- Mod(fft(sin_1))
  
  if (!input$fouriertot) {  
    maxi <- max(temp) 
    temp[temp < maxi*input$pourc/100 ] <- 0
  }
  
  freq <- seq(0, by = 1, length.out = length(temp))
  plot(freq, temp)

}

plot_inv_fourier <- function(input) {
  
  freq <- input$freq
  echant <- input$echant
  harmo <- input$harmo
  
  
  echant_1 <- seq(from = 0, to = 1, length.out = echant)
  sin_1    <- seq(0, 0, length.out = echant)
  for (i in 0:harmo) {
    sin_1    <- sin_1    + sin(2 * pi * freq * (1 + i) * echant_1 + i)    * (1 - i*0.1)
  }
  
  if (input$bruh) {
    sin_1 <- bruit + sin_1
  }
  
  temp <- fft(sin_1)
  mod  <- Mod(temp)
  if (!input$fouriertot) {  
    maxi <- max(mod) 
    temp[mod < maxi*input$pourc/100 ] <- 0
  }

    if(input$add_point) {
    milieu <- round(length(temp)/2)
    temp <- c(temp[1:milieu], rep(0, times = input$add_point_nb), temp[(milieu + 1):length(temp)]) 
  }  
  temp <- Re(fft(temp, inverse = TRUE)) 
  temp <- temp / length(temp)

  
  vec <- (0:(length(temp) - 1 ))/ (length(temp) - 1) 
  
  df <- data.frame(vec, temp)
  p <- ggplot() + geom_line(data = df, aes(x = vec, y = temp))

  print(p)
  
}

plot_harmonique <- function(input) {

  freq <- input$freq
  echant <- input$echant
  harmo <- input$harmo
  
  echant_1 <- seq(from = 0, to = 1, length.out = 10000)
  sin_1   <- data.frame(echant_1)
  
  
  for (i in 0:harmo) {
    sin_1    <- cbind(sin_1, sin(2 * pi * freq * (1 + i) * echant_1 + i)    * (1 - i*0.1))
  }
  noms <- c("Temps", "Fondamentale")
  
  if (harmo > 0) { noms <- c(noms, paste0("Harmonique_", 1:harmo)) }

  names(sin_1) <- noms
  
  couleur <- c("BLACK", "BLUE", "RED", "YELLOW", "BROWN")
    
  p <- ggplot(sin_1)
  
  p <- p + geom_line(aes(x = Temps, y = Fondamentale),  colour = couleur[1])
  
  if (harmo > 0) {
  index <- 1
  for (name in paste0("Harmonique_", 1:harmo)) {
    if (input[[paste0("harmo_", index) ]])  {
      p <- p + geom_line(aes(x = Temps, y = !!sym(name)),  colour = couleur[index + 1]) }
    index <- index + 1
  }
  }
  if (input$bruit_affichage) {
    echant <- seq(from = 0, to = 1, length.out = length(bruit)) 
    df_temp <- data.frame(echant, bruit)
    names(df_temp) <- c("Temps", "Bruit")
    p <- p + geom_point(data = df_temp, aes(x = Temps, y = Bruit, colour  = "PURPLE"))
  }
  
  print(p)

}

plot_sinus <- function(input) {
  
  echant_glob <- seq(from = 0, to = 1, length.out = 10000)
  sin_glob <- input$ampli_sin1 * sin(2 * pi * input$freq_sin1 * echant_glob) 
  sin_glob <- sin_glob + input$ampli_sin2 * sin(2 * pi * input$freq_sin2 * echant_glob) 
  df <- data.frame(echant_glob, sin_glob)
  
  p <- ggplot(df) + aes(x = echant_glob, y = sin_glob) + geom_line()
  print(p)
  return(p)
}

plot_fourier_2 <- function(input) {
  echant_glob <- seq(from = 0, to = 1, length.out = input$nb_p)
  sin_glob <- input$ampli_sin1 * sin(2 * pi * input$freq_sin1 * echant_glob) 
  sin_glob <- sin_glob + input$ampli_sin2 * sin(2 * pi * input$freq_sin2 * echant_glob) 
  
  Modulo_coeff_fourier <- Mod(fft(sin_glob))
  freq <- 0:(input$nb_p - 1)
  df <- data.frame(freq, Modulo_coeff_fourier)
  p <- ggplot(df) + aes(x = freq, y = Modulo_coeff_fourier) + geom_point()
  return(p)
}

runApp(scr_dir)
