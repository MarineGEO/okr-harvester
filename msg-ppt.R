# create a powerpoint slide deck from OKR dataframe with one slide per message

library(officer)
library(tidyverse)
library(purrr)

# create new presentation
prez <- read_pptx()

# function to add slide with OKR as title
addOKR <- function(okr, contributor, presentation=prez){
  presentation <- presentation %>% 
    add_slide(layout = "Title Slide", master = "Office Theme") %>%
    ph_with_text(type = "ctrTitle", str = okr) %>% 
    ph_with_text(type = "dt", str = contributor ) # footer
}

# map over items in data.frame and add to presentation
# walk through the slack message dataframe and add messages as individual slides
walk2(msgs_df_names$text, msgs_df_names$user, addOKR)

print(prez, target="OKR-Slack.pptx")
