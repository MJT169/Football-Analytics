# Premier League Midfielder Similarity & Style Clustering

A data analyst project using R to group Premier League midfielders by playing
style and build a "find similar players" scouting tool, using season-level
data from FBref (via the `worldfootballR` package).

## Motivation

Traditional scouting comparisons often lean on reputation or a handful of
headline stats (goals, assists). This project instead uses unsupervised
learning — PCA and k-means clustering — on a broader set of per-90 stats
(touches by pitch zone, ball-carrying, take-ons, progressive passing) to
group midfielders by *style*, then builds a nearest-neighbour function to
find statistically similar players to any named player.

## Data

- **Source**: FBref, accessed via `worldfootballR::load_fb_big5_advanced_season_stats()`
  (pre-scraped snapshot data, used after FBref's live scraping endpoints
  returned HTTP 403 errors)
- **Scope**: Premier League players, single season
- **Stat types combined**: `standard` (goals, assists, progression) and
  `possession` (touches by zone, carries, take-ons)

## Data Cleaning

A meaningful part of this project was handling real-world data messiness:

- **Mid-season transfers**: players who changed clubs appeared as duplicate
  rows (one per club). Resolved by keeping the row with the most minutes
  played per player.
- **Inconsistent player coverage across stat tables**: the `standard` and
  `possession` tables did not share an identical player pool (359 of ~400
  players overlapped). Resolved with an inner join on a unique player URL,
  accepting the smaller but reliable overlapping sample.
- **Small-sample noise in per-90 stats**: players with very low minutes
  produced extreme, misleading per-90 rates (e.g. a single good cameo
  inflating a rate stat). Resolved by raising the minutes threshold to
  ~900 minutes (roughly 10 full matches) before deriving per-90 features.

## Method

1. Filtered to midfielders (`Pos` contains "MF") with ≥900 minutes played
2. Converted 13 raw counting stats to per-90 rates (goals, assists, touches
   by zone, carries, progressive distance, take-ons, progressive passes/receptions)
3. Standardised features (`scale()`) and ran PCA for visualisation
4. Used the elbow method (`factoextra::fviz_nbclust`) to select k = 4 for k-means
5. Built a k-nearest-neighbours function (`FNN::get.knnx`) over the scaled
   feature space to return the N most statistically similar players to any
   named midfielder

## Results

Four style-based clusters emerged:

| Cluster | Profile | Key traits |
|---|---|---|
| 1 | Advanced creators/attackers | Highest goals/assists, most attacking-third and box touches, longest carries, most take-ons |
| 2 | Deep-lying distributors | Highest defensive/midfield-third touches, highest progressive passing, low carrying |
| 3 | Box-to-box/balanced | Moderate across all metrics, no extreme profile |
| 4 | Low-touch/simple operators | Lowest involvement across nearly all metrics |

A PCA scatter plot of the two leading components shows visible separation
between clusters, particularly cluster 1 from the rest along PC1.

## Limitations

- Single-season snapshot — playing style can vary season to season with
  managerial/system changes
- All 13 features are weighted equally in the distance calculation; a
  player who is elite in one or two specific metrics but average elsewhere
  can still land in an unexpected cluster (e.g. a well-known ball-carrier
  landing in a lower-carrying cluster after a season where their measured
  output didn't match their broader reputation)
- Clustering is descriptive, not predictive — it groups past-season output,
  it does not forecast future performance or fit at a new club

## Tools

R, `worldfootballR`, `dplyr`, `tidyr`, `ggplot2`, `factoextra`, `FNN`

## Possible extensions

- Repeat the pipeline for defenders and forwards
- Wrap the similarity function in a Shiny app for an interactive demo
- Compare clusters across multiple seasons to see how players move between
  style groups over time
