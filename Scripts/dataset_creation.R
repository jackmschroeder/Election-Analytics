library(tidyverse)
election_20 <- as.Date("11/3/20", "%m/%d/%Y")
avg <- read_csv("./Data/pollavg_1968-2016.csv")
avg_state <- read_csv("./Data/pollavg_bystate_1968-2016.csv")

# Annual national data

national_a <- read_csv("./Data/econ.csv") %>% 
  filter(year<2020) %>% 
  group_by(year) %>% 
  summarize(unemployment_nat_a = mean(unemployment),
            RDI_growth_a = mean(RDI_growth),
            inflation_a = mean(inflation),
            stock_a = mean(stock_close),
            GDP_growth_a = mean(GDP_growth_qt))

# Term national data

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

# The same for local (state-by-state).

local_a <- read_csv("./Data/local.csv") %>% 
  rename(year = Year,
         state = `State and area`) %>% 
  filter(year<2020) %>% 
  group_by(state, year) %>% 
  summarize(unemployment_loc_a = mean(Unemployed_prce),
            lfpr_loc_a = mean(LaborForce_prct))

local_t <- read_csv("./Data/local.csv") %>% 
  rename(year = Year,
         state = `State and area`) %>% 
  filter(year<2020) %>% 
  mutate(term = trunc((year-1949)/4, 1)) %>% 
  group_by(state, term) %>% 
  summarize(year = max(year),
            unemployment_loc_t = mean(Unemployed_prce),
            lfpr_loc_t = mean(LaborForce_prct))

# National popular vote data - same mutations as week 1.

national_v <- read_csv("Data/popvote_1948-2016.csv") %>% 
  #filter(party == "republican") %>%
  mutate(margin_pct_nat = pv2p-50,
         margin_pct_lag_nat = lag(margin_pct_nat),
         swing_nat = margin_pct_nat - margin_pct_lag_nat)

# Same mutations as week 1 for state popular vote data.

local_v <- read_csv("./Data/popvote_bystate_1948-2016.csv") %>% 
  mutate(margin_pct_r = R_pv2p - 50,
         margin_pct_lag_r = lag(margin_pct_r),
         margin_pct_d = D_pv2p - 50,
         margin_pct_lag_d = lag(margin_pct_d),
         swing_r = margin_pct_r - margin_pct_lag_r,
         swing_d = margin_pct_d - margin_pct_lag_d)

# Master national and local datasets with vote and economic data.

national <- national_v %>% 
  left_join(., national_a, by ="year") %>% 
  left_join(., national_t, by = "year")

local <- local_v %>% 
  left_join(., national_v, by="year") %>% 
  left_join(., national_a, by ="year") %>% 
  left_join(., national_t, by = "year") %>% 
  left_join(., local_a, by = c("year", "state")) %>% 
  left_join(., local_t, by = c("year", "state"))

national %>% 
  write_csv("./Data/national_fundamentals.csv")

local %>% 
  write_csv("./Data/local_fundamentals.csv")

polls_20 <- read_csv("./Data/polls_2020.csv") %>% 
  mutate(fte_grade_buckets = case_when(fte_grade %in% c("A+", "A", "A-") ~ 0,
                                       fte_grade == "A/B" ~ 1,
                                       fte_grade %in% c("B+, B", "B-") ~ 2,
                                       fte_grade == "B/C" ~ 3,
                                       fte_grade %in% c("C+", "C", "C-") ~ 4,
                                       fte_grade == "C/D" ~ 5,
                                       fte_grade == "D-" ~ 6,
                                       TRUE ~ 7),
         fte_grade_good = case_when(fte_grade_buckets < 2 ~ 0,
                                    fte_grade_buckets > 3 ~ 2,
                                    TRUE ~ 1),
         poll_date = as.Date(end_date, "%m/%d/%Y"),
         weeks_left = round(difftime(election_20, poll_date, unit="weeks")))

polls_20$state[is.na(polls_20$state)] <- "National"

polls_20 %>% 
  write_csv("./Data/polls_20.csv")

model_3_data <- national %>% 
  full_join(avg %>% 
              filter(weeks_left == 10) %>% 
              group_by(year, party) %>% 
              summarize(avg_support_10 = mean(avg_support))) %>% 
  full_join(avg %>% 
              filter(weeks_left < 2) %>% 
              group_by(year, party) %>% 
              summarize(avg_support_2 = mean(avg_support))) %>% 
  write_csv("./Data/model_3.csv")

model_input_local <- local %>% 
  full_join(avg_state %>% 
             filter(weeks_left == 10) %>% 
             group_by(year, state, party) %>% 
             summarize(avg_support_10 = mean(avg_poll))) %>% 
  full_join(avg_state %>% 
              filter(weeks_left < 2) %>% 
              group_by(year, state, party) %>% 
              summarize(avg_support_2 = mean(avg_poll))) %>% 
  write_csv("./Data/model_input_local.csv")

# Trump data

trump_2020 <- data.frame(unemployment_nat_t = 8.4, GDP_growth_a = -5.6, incumbent_party = TRUE, avg_support_2 = 0, RDI_growth_t = 0.005, margin_pct_lag_nat = -1.162)

trump_support_10 <- polls_20 %>% 
  filter(weeks_left == 10,
         state == "National",
         answer == "Trump",
         fte_grade_buckets<4) %>% 
  summarize(avg_support_10 = mean(pct))
trump_2020 <- cbind(trump_2020, trump_support_10)
trump_2020$avg_support_2 <- 43.2

trump_2020 %>% 
  write_csv("./Data/trump_2020.csv")
