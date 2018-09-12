# OKR Harvester

Pulls messages from a private slack channel and creates a powerpoint slide deck.

## Set up 

Slack API token and channel ID must be set in the `CONFIG` file. See `CONFIG-EXAMPLE` for an example.

Run `msg-harvester.R` to pull all slack messages from a private channel into a R data frame. Then, run `msg-ppt.R` to turn each row in the data frame into a powerpoint slide for printing. 

## Requirements
 - R
 - Slack API Token
 - tidyverse
 - purrr
 - officer