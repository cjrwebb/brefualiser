
# Load required libraries

library(shiny)
library(bs4Dash)
library(tidyverse)
library(plotly)

#' The global.R file in a Shiny app contains any global functions or datasets
#' required in the use of an app. Creating functions for common tasks used
#' in the server.R file can often help keep things neat and tidy.

#' In this case, I am using a dataset containing a summary of random effects 
#' from a Bayesian distributed lag model. I also need the average fixed effect
#' which I'll just assign to an object in the environment.

# Random effects posterior summary dataset
re_dat <- read_csv("data/spend_REs_LRPs.csv")

# long run proposensity effect for spending residuals (from trends)
lrp_feff <- -0.1800059

# I also want to backtransform my model estimates, so need the standard deviation
# from my scaled residuals in the model. I also want to make the coefficients
# equate to a £100 per child change in expenditure
sd_cla_resid <- 3.899281
sd_spend_resid <- 32.99546/100

rev_std_b <- function(b, s_y, s_x) {b * (s_y / s_x)}

#' I want to visualise the random effects as a caterpillar plot, but
#' crucially I want the user to be able to select a specific local authority
#' to highlight so that it is easier for them to find their place of 
#' interest.
#' 
#' For this, I'm going to write a custom plotting function that draws
#' either a caterpillar plot with no highlighting if the user does not
#' select any local authority, or a caterpillar plot with highlighting
#' if the user does specify a vector of local authorities


draw_spend_res <- function(la_select = NULL) {
  
  if (is.null(la_select)) {
  
  spe_combined_plot <- spend_res_combined_sum %>%
    mutate(rank_cspend = rank(combined_spend_resid_median)) %>%
    ggplot() +
    geom_hline(yintercept = rev_std_b(c_spend_eff, sd_cla_resid, sd_spend_resid)) +
    geom_segment(aes(x = rank_cspend, xend = rank_cspend,
                     y = rev_std_b(combined_spend_resid_q89_lb + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                     yend = rev_std_b(combined_spend_resid_q89_ub + c_spend_eff, sd_cla_resid, sd_spend_resid))) +
    geom_point(aes(x = rank_cspend, 
                   y = rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                   text = paste0(la_name, ": ", round(rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 2)))) +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "transparent"), panel.background = element_rect("transparent")) +
    ylab(HTML("Predicted change in CLA starts per 10,000 residual for a £100 increase\nabove LA trend in preventative spending, sustained for 2 years")) +
    xlab("Rank of effect")
  
  return(ggplotly(spe_combined_plot, tooltip = "text"))
  
  } else {
    
    spe_combined_plot <- spend_res_combined_sum %>%
      mutate(rank_cspend = rank(combined_spend_resid_median)) %>%
      ggplot() +
      geom_hline(yintercept = rev_std_b(c_spend_eff, sd_cla_resid, sd_spend_resid) ) +
      geom_segment(aes(x = rank_cspend, xend = rank_cspend,
                       y = rev_std_b(combined_spend_resid_q89_lb + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                       yend = rev_std_b(combined_spend_resid_q89_ub + c_spend_eff, sd_cla_resid, sd_spend_resid))) +
      geom_point(aes(x = rank_cspend, y = rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                     text = paste0(la_name, ": ", round(rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 2)))) +
      geom_segment(data = . %>% filter(la_name %in% la_select),
                     aes(x = rank_cspend, xend = rank_cspend,
                     y = rev_std_b(combined_spend_resid_q89_lb + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                     yend = rev_std_b(combined_spend_resid_q89_ub + c_spend_eff, sd_cla_resid, sd_spend_resid)), col = "turquoise") +
      geom_point(data = . %>% filter(la_name %in% la_select),
                 aes(x = rank_cspend, 
                     y = rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 
                     text = paste0(la_name, ": ", round(rev_std_b(combined_spend_resid_median + c_spend_eff, sd_cla_resid, sd_spend_resid), 2))), col = "turquoise") +
      theme_minimal() +
      theme(plot.background = element_rect(fill = "transparent"), panel.background = element_rect("transparent")) +
      ylab(HTML("Predicted change in CLA starts per 10,000 residual for a £100 increase\nabove LA trend in preventative spending, sustained for 2 years")) +
      xlab("Rank of effect")
    
    return(ggplotly(spe_combined_plot, tooltip = "text"))
    
  }
  
}


# Test the function
#draw_spend_res() # without any selection
#draw_spend_res("Sheffield") # with one selection
#draw_spend_res(c("Sheffield", "Camden", "Torbay")) # with multiple collections

# I will also need an object which is a list of local authorities for a user to select
# from. I can get this from the data:

la_select <- sort(re_dat$la_name)





