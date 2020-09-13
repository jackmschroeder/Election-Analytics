# Loading in libraries.

library(tidyverse)

# National dataset - reading in, selecting a single party (republican)
# and creating national margins of victory.

national <- read_csv("Data/popvote_1948-2016.csv") %>% 
  filter(party == "republican") %>%
  mutate(margin_pct_nat = pv2p-50,
         
# Lagged national margin of victory needed to make national swing.

         margin_pct_lag_nat = lag(margin_pct_nat),
         swing_nat = margin_pct_nat - margin_pct_lag_nat)

# State dataset - reading in, mutating into margin and lagged margin.

state <- read_csv("Data/popvote_bystate_1948-2016.csv") %>% 
  mutate(margin_pct = R_pv2p - 50,
         margin_pct_lag = lag(margin_pct),
         swing = margin_pct - margin_pct_lag) %>% 
  
# Adding in national dataset to get national swing/margin.
  
  left_join(., national, by="year")

# Plot 1 - looking at post-1980 national trends in Republican vote.

state %>% 
  filter(year > 1979) %>% 
  ggplot(aes(x=year, y=R_pv2p, color=state)) + 
  geom_line() +

# This one is the national trend - making it larger and smoother.
  
  geom_smooth(aes(y=pv2p), color="black", size=2) + 

# Labels, theme, and taking out the legend for readability.
  
  theme_bw() +
  theme(legend.position = "none") +
  xlab("Year") +
  ylab("Republican Two-Party Vote Share") +
  ggtitle("State-by-State Republican Vote Share since 1980",
          subtitle = "DC a Massive Outlier from National Trend") + 
  
# Save it!
  
  ggsave("./Plots/week1plot1.png")

# Plot 2 - post-1980 margins of victory.

state %>% 
  filter(year > 1979,

# Purple state (Colorado), blue state (NJ), and red state (MS) to show
# differences.

         state == "Colorado" | state == "New Jersey" | state == "Mississippi") %>% 
  ggplot(aes(x=state, y=margin_pct)) + 

# Violin plots look cool! Interesting way to present the trend.

  geom_violin(aes(color=state)) +
  
# Adding jittered points to show the exact margins.
  
  geom_jitter(aes(color=state), width=.1) +

# Setting colors for the types of states.
  
  scale_color_manual(values = c("purple", "red", "blue")) +
  
# Theme, labels, title, save!
  
  theme_bw() + 
  theme(legend.position = "none") +
  xlab("State") +
  ylab("Republican Margin of Victory/Defeat") +
  ggtitle("Margins of Victory since 1980",
          subtitle = "In Purple, Red, and Blue Examples") + 
  ggsave("./Plots/week1plot2.png")
