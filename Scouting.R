library(worldfootballR)
library(dplyr)
library(tidyr)

# Pull standard stats for outfield players, Premier League 2025-26
prem_standard <- fb_league_stats(
  country = "ENG", gender = "M", season_end_year = 2026,
  tier = "1st", stat_type = "standard", team_or_player = "player"
)

"worldfootballR" %in% installed.packages()[, "Package"]

ls("package:worldfootballR")[grepl("league|stats", ls("package:worldfootballR"), ignore.case = TRUE)]

?fb_player_season_stats
# or
args(fb_player_season_stats)

args(fb_team_player_stats)
?fb_team_player_stats

league_url <- fb_league_urls(
  country = "ENG", gender = "M",
  season_end_year = 2026, tier = "1st"
)

team_urls <- fb_teams_urls(league_url)
team_urls  # should return 20 team URLs

big5_stats <- load_fb_big5_advanced_season_stats(stat_type = "standard", team_or_player = "player")
