# harvest messages in a channel through querying slack's API

# Load packages
library(tidyverse)
library(purrr)

# load the config file that contains the API token
source('CONFIG')

# query API and save all messages to a data frame
url_groupHistory <- 'https://slack.com/api/groups.history'
msgs <- content(GET(str_c(url_groupHistory, "?", "token=", token, "&", "channel=", channel, "&pretty=1")))$messages

# function to turn each nested list from the API response into a tibble
nest2df <- function(x){
  tribble(
    ~user, ~text, ~timestamp, ~reaction,
    x$user,  x$text, x$ts, x$reaction
  )
}

# Apply function to each message in list to turn into a single data frame
msgs_df <- map_df(msgs, nest2df)

# Function that queries the API for user's actual name
getUserRealName <- function(userid, api_token=token){
  # construct the API URL
  userInfoURL <- str_c('https://slack.com/api/users.info?token=', api_token, '&user=', userid, '&pretty=1') 
  
  # pull the user's real name from the API response
  real_name <- content(GET(userInfoURL))$user$real_name
  return(real_name)
}

# get unique user names from ID's as a data frame
realNames <- msgs_df %>% 
  select(user) %>% 
  unique() %>% # select unique IDs so don't have query API for each message
  rowwise() %>% 
  mutate(real_name=getUserRealName(user))

# join real names to the message dataframe
msgs_df_names <- left_join(msgs_df, realNames, by='user') 
msgs_df_names
