# Loading in libraries. Stargazer for table.

library(tidyverse)
library(stargazer)

national_a <- read_csv("./Data/econ.csv") %>% 
  filter(year<2020) %>% 
  group_by(year) %>% 
  summarize(unemployment_nat_a = mean(unemployment),
            RDI_a = mean(RDI_growth),
            inflation_a = mean(inflation),
            stock_a = mean(stock_close),
            GDP_growth_a = mean(GDP_growth_qt))

national_t <- read_csv("./Data/econ.csv") %>% 
  filter(year<2020) %>% 
  mutate(term = trunc((year-1949)/4, 1)) %>% 
  group_by(term) %>% 
  summarize(year = max(year),
            unemployment_nat_t = mean(unemployment),
            RDI_growth_t = mean(RDI_growth),
            inflation_t = mean(inflation),
            stock_t = mean(stock_close),
            GDP_growth_t = mean(GDP_growth_qt))

local_a <- read_csv("./Data/local.csv") %>% 
  rename(year = Year,
         state = `State and area`) %>% 
  filter(year<2020,
         `FIPS Code` < 100) %>% 
  group_by(state, year) %>% 
  summarize(unemployment_loc_a = mean(Unemployed_prce),
            lfpr_loc_a = mean(LaborForce_prct))

local_t <- read_csv("./Data/local.csv") %>% 
  rename(year = Year,
         state = `State and area`) %>% 
  filter(year<2020,
         `FIPS Code` < 100) %>% 
  mutate(term = trunc((year-1949)/4, 1)) %>% 
  group_by(state, term) %>% 
  summarize(year = max(year),
            unemployment_loc_t = mean(Unemployed_prce),
            lfpr_loc_t = mean(LaborForce_prct))

local <- read_csv("./Data/local.csv") %>% 
  select(-X1)

# National popular vote data - same mutations as week 1.
  
national_v <- read_csv("Data/popvote_1948-2016.csv") %>% 
  filter(party == "republican") %>%
  mutate(margin_pct_nat = pv2p-50,
         margin_pct_lag_nat = lag(margin_pct_nat),
         swing_nat = margin_pct_nat - margin_pct_lag_nat)

# Same mutations as week 1 for state popular vote data.

local_v <- read_csv("./Data/popvote_bystate_1948-2016.csv") %>% 
  mutate(margin_pct = R_pv2p - 50,
         margin_pct_lag = lag(margin_pct),
         swing = margin_pct - margin_pct_lag) %>% 
  left_join(., national_v, by="year")

# m1 <- lm(pv2p ~ )