#### Air War ####
#### Gov 1347: Election Analysis (2020)
#### TFs: Soubhik Barari, Sun Young Park

library(tidyverse)
library(ggplot2)
library(cowplot)  ## easier to customize grids of plots
library(scales)   ## more options for scales (e.g. formatting y axis to be $)
library(geofacet) ## map-shaped grid of ggplots

#####------------------------------------------------------#
##### Read and merge data ####
#####------------------------------------------------------#

pvstate_df   <- read_csv("../datasets/popvote_bystate_1948-2016.csv")
ad_creative  <- read_csv("../datasets/ad_creative_2000-2012.csv")
ad_campaigns <- read_csv("../datasets/ad_campaigns_2000-2012.csv")

#####------------------------------------------------------#
##### Visualization gallery ####
#####------------------------------------------------------#

## Tone and Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  group_by(cycle, party) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, party, ad_tone) %>% summarise(pct=n()*100/first(tot_n)) %>%
  filter(!is.na(ad_tone)) %>%
  ggplot(aes(x = cycle, y = pct, fill = ad_tone, group = party)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(2000, 2012, 4)) +
  ggtitle("Campaign Ads Aired By Tone") +
  scale_fill_manual(values = c("red","orange","gray","darkgreen","white"), name = "tone") +
  xlab("") + ylab("%") +
  facet_wrap(~ party) + theme_minimal() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=15),
        strip.text.x = element_text(size = 20))

## The Purpose of Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  group_by(cycle, party) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, party, ad_purpose) %>% summarise(pct=n()*100/first(tot_n)) %>%
  filter(!is.na(ad_purpose)) %>%
  bind_rows( ##2016 raw data not public yet! This was entered manually
    data.frame(cycle = 2016, ad_purpose = "personal", party = "democrat", pct = 67),
    data.frame(cycle = 2016, ad_purpose = "policy", party = "democrat", pct = 12),
    data.frame(cycle = 2016, ad_purpose = "both", party = "democrat", pct = 21),
    data.frame(cycle = 2016, ad_purpose = "personal", party = "republican", pct = 11),
    data.frame(cycle = 2016, ad_purpose = "policy", party = "republican", pct = 71),
    data.frame(cycle = 2016, ad_purpose = "both", party = "republican", pct = 18)
  ) %>%
  ggplot(aes(x = cycle, y = pct, fill = ad_purpose, group = party)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(breaks = seq(2000, 2016, 4)) +
  # ggtitle("Campaign Ads Aired By Purpose") +
  scale_fill_manual(values = c("grey","red","darkgreen","black","white"), name = "purpose") +
  xlab("") + ylab("%") +
  facet_wrap(~ party) + theme_minimal() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=15),
        strip.text.x = element_text(size = 20))


## The Elections and Their Issues
top_issues <- ad_campaigns %>% 
  left_join(ad_creative) %>%
  filter(!grepl("None|Other", ad_issue)) %>%
  group_by(cycle, ad_issue) %>% summarise(n=n()) %>% top_n(5, n)

### making each plot in a grid to have its own x-axis (issue name)
### is tricky with `facet_wrap`, so we use this package `cowplot`
### which allows us to take a list of separate plots and grid them together
plist <- lapply(c(2000,2004,2008,2012), function(c) {
  top_issues %>% filter(cycle == c) %>% 
    ggplot(aes(x = reorder(ad_issue, n), y = n)) +
    geom_bar(stat = "identity") + coord_flip() + theme_bw() +
    xlab("") + ylab("number ads aired") + ggtitle(paste("Top 5 Ad\nIssues in",c))
  
})
cowplot::plot_grid(plotlist = plist, nrow = 2, ncol = 2, align = "hv")


## Campaign Ads Aired By Issue and Party: 2000
party_issues2000 <- ad_campaigns %>%
  filter(cycle == 2000) %>%
  left_join(ad_creative) %>%
  filter(ad_issue != "None") %>%
  ## this `group_by` is to get our denominator
  group_by(ad_issue) %>% mutate(tot_n=n()) %>% ungroup() %>%
  ## this one is get numerator and calculate % by party
  group_by(ad_issue, party) %>% summarise(p_n=n()*100/first(tot_n)) %>% ungroup() %>%
  ## finally, this one so we can sort the issue names
  ## by D% of issue ad-share instead of alphabetically
  group_by(ad_issue) %>% mutate(Dp_n = ifelse(first(party) == "democrat", first(p_n), 0))

ggplot(party_issues2000, aes(x = reorder(ad_issue, Dp_n), y = p_n, fill = party)) + 
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("blue", "red")) +
  ylab("% of ads on topic from each party") + xlab("issue") + 
  # ggtitle("Campaign Ads Aired by Topic in 2000") +
  coord_flip() + 
  theme_bw()


## Campaign Ads Aired By Issue and Party: 2012
party_issues2012 <- ad_campaigns %>%
  filter(cycle == 2012) %>%
  left_join(ad_creative) %>%
  filter(ad_issue != "None") %>%
  group_by(cycle, ad_issue) %>% mutate(tot_n=n()) %>% ungroup() %>%
  group_by(cycle, ad_issue, party) %>% summarise(p_n=n()*100/first(tot_n)) %>% ungroup() %>%
  group_by(cycle, ad_issue) %>% mutate(Dp_n = ifelse(first(party) == "democrat", first(p_n), 0))

ggplot(party_issues2012, aes(x = reorder(ad_issue, Dp_n), y = p_n, fill = party)) + 
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("blue", "red")) +
  ylab("% of ads on topic from each party") + xlab("issue") +
  # ggtitle("Campaign Ads Aired by Topic in 2012") +
  coord_flip() + 
  theme_bw()


## When to Buy Ads? 
ad_campaigns %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  filter(year %in% c(2000, 2004, 2008, 2012), month > 7) %>%
  group_by(cycle, air_date, party) %>%
  summarise(total_cost = sum(total_cost)) %>%
  ggplot(aes(x=air_date, y=total_cost, color=party)) +
  # scale_x_date(date_labels = "%b, %Y") +
  scale_y_continuous(labels = dollar_format()) +
  scale_color_manual(values = c("blue","red"), name = "") +
  geom_line() + geom_point(size=0.5) +
  facet_wrap(cycle ~ ., scales="free") +
  xlab("") + ylab("ad spend") +
  theme_bw() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=11),
        strip.text.x = element_text(size = 20))


## Tone in Political Ads
ad_campaigns %>%
  left_join(ad_creative) %>%
  filter(ad_tone %in% c("attack", "promote")) %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  filter(year %in% c(2000, 2004, 2008, 2012), month > 7) %>%
  group_by(cycle, air_date, ad_tone) %>%
  summarise(total_cost = sum(n_stations)) %>%
  group_by(cycle, air_date) %>%
  mutate(total_cost = total_cost/sum(total_cost)) %>%
  ungroup() %>%
  ggplot(aes(x=air_date, y=total_cost, fill=ad_tone, color=ad_tone)) +
  # scale_x_date(date_labels = "%b") +
  scale_fill_manual(values = c("purple","green"), name = "ad tone") +
  scale_color_manual(values = c("purple","green"), name = "ad tone") +
  geom_bar(stat = "identity") +
  facet_wrap(cycle ~ ., scales="free") +
  xlab("") + ylab("% of ads bought on day") +
  theme_bw() +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=10),
        strip.text.x = element_text(size = 20))


## The State-level Air War in 2008 (Obama vs. McCain)
ad_campaigns %>%
  mutate(year = as.numeric(substr(air_date, 1, 4))) %>%
  mutate(month = as.numeric(substr(air_date, 6, 7))) %>%
  mutate(state = state.name[match(state, state.abb)]) %>%
  filter(cycle == 2008) %>%
  left_join(pvstate_df %>% filter(year == 2008) %>% select(-year), by="state") %>%
  mutate(winner=ifelse(D_pv2p > R_pv2p, "democrat", "republican")) %>%
  group_by(cycle, state, air_date, party, winner) %>%
  summarise(total_cost = sum(total_cost)) %>%
  filter(!is.na(state)) %>%
  # ggplot(aes(x=air_date, y=log(total_cost+1), color=party)) +
  ggplot(aes(x=party, y=total_cost, fill=party)) +
  geom_bar(stat="identity") +
  geom_rect(aes(fill=winner), xmin=-Inf, xmax=Inf, ymin=46.3*10^6, ymax=52*10^6) +
  facet_geo(~ state, scales="free_x") +
  scale_fill_manual(values = c("blue", "red")) +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6)) +
  xlab("") + ylab("ad spend") +
  theme_bw() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
