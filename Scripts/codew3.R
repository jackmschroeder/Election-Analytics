library(tidyverse)
library(knitr)
library(stargazer)
library(ggrepel)

local_fundamentals <- read_csv("./Data/local_fundamentals.csv")
national_fundamentals <- read_csv("./Data/national_fundamentals.csv")
avg <- read_csv("./Data/pollavg_1968-2016.csv")
avg_state <- read_csv("./Data/pollavg_bystate_1968-2016.csv")
econ <- read_csv("./Data/econ.csv")
popvote <- read_csv("./Data/popvote_1948-2016.csv")
polls_16 <- read_csv("./Data/polls_2016.csv")
election_20 <- as.Date("11/3/20", "%m/%d/%Y")
polls_20 <- read_csv("./Data/polls_2020_real.csv") %>% 
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


# Fig 1 - variation in pollster quality (use buckets of grades)
  
polls_20 %>% 
  group_by(pollster) %>% 
  summarize(grade = max(fte_grade_good)) %>% 
  ggplot(aes(x=grade)) +
  geom_histogram(stat="count", fill = "#ec8f9c") +
  scale_x_continuous(breaks = seq(from = 0, to = 2, by = 1),
                     labels = c("Good", "OK", "Not Great")) +
  xlab("FiveThirtyEight Grades") +
  ylab("Count") +
  labs(title = "FiveThirtyEight Pollsters by Grade",
       subtitle = "Many Pollsters Receive Bad Grades (Or None At All)",
       caption = "'Good' = Grade of A/B or above,\n'OK' = Grade of B/C or above,\n'Not Great' = Grade Below B/C or No Rating") +
  theme_bw() + 
  ggsave("./Plots/week3plot1.png")

# Fig 2 - variation between online/live calling (raw polls)

polls_20 %>% 
  filter(!is.na(methodology),
         fte_grade_buckets<7) %>% 
  mutate(method = case_when(methodology %in% c("Automated Phone", "IVR/Live Phone", "IVR/Live Phone/Online", "IVR/Online", "IVR/Text", "IVR/Online/Text", "Text", "Live Phone", "Live Phone/Text", "Live Phone/Online", "Live Phone/Online/Text", "Mail") ~ "Phone",
                            methodology %in% c("Online", "Online/IVR", "Online/Text") ~ "Online")) %>% 
  ggplot(aes(x=fte_grade_good)) +
  geom_histogram(stat="count", fill="steelblue") +
  scale_x_continuous(breaks = seq(from = 0, to = 2, by = 1),
                     labels = c("Good", "OK", "Not Great")) +
  facet_wrap(~method) +
  xlab("FiveThirtyEight Grades") +
  ylab("Count") +
  labs(title = "FiveThirtyEight Grades by Methodology",
       subtitle = "Phone Polls Likelier to Receive Better Grades",
       caption = "'Good' = Grade of A/B or above,\n'OK' = Grade of B/C or above,\n'Not Great' = Grade Below B/C\nUnknown Ratings Filtered Out") +
  theme_bw() + 
  ggsave("./Plots/week3plot2.png")

# Model building time

# Lab data filtered to only include incumbent parties

model_data <- national_fundamentals %>% 
  full_join(avg %>% 
              filter(weeks_left == 10) %>% 
              group_by(year, party) %>% 
              summarize(avg_support_10 = mean(avg_support))) %>% 
  full_join(avg %>% 
              filter(weeks_left < 2) %>% 
              group_by(year, party) %>% 
              summarize(avg_support_2 = mean(avg_support))) %>% 
  filter(!is.na(winner))

# Model 1 - national data, average support 10 weeks out and less than 2 weeks out

mprev <- lm(pv2p ~ unemployment_nat_t + GDP_growth_a + incumbent_party, data=model_data)
summary(mprev)

m10 <- lm(pv2p ~ avg_support_10 + margin_pct_lag_nat + RDI_growth_t + incumbent_party, data=model_data)
summary(m10)

m2 <- lm(pv2p ~ avg_support_2 + margin_pct_lag_nat + RDI_growth_t + incumbent_party, data=model_data)
summary(m2)

# Check for 2020. Feed in incumbency, RDI, and lagged margin

trump_2020 <- data.frame(unemployment_nat_t = 8.4, GDP_growth_a = -5.6, incumbent_party = TRUE, avg_support_2 = 0, RDI_growth_t = 0.005, margin_pct_lag_nat = -1.162)

# Find average support in polls for 10 weeks

trump_support_10 <- polls_20 %>% 
  filter(weeks_left == 10,
         state == "National",
         answer == "Trump",
         fte_grade_buckets<4) %>% 
  summarize(avg_support_10 = mean(pct))

trump_2020 <- cbind(trump_2020, trump_support_10)

# Two week here is variable. Let's look at three cases.

# Where he is now

trump_2020$avg_support_2 <- 43.2

predict(m2, trump_2020)

# Lower support

#trump_2020$avg_support_2 <- 38

#predict(m2, trump_2020)

# 50-50

#trump_2020$avg_support_2 <- 50

#predict(m2, trump_2020)

# Table 1: 10 week and 2 week model

stargazer(m10, m2,
          title = "10-Week and 2-Week Polling Models",
          header = FALSE,
          covariate.labels = c("Average Support (10-Week)", "Average Support (2-Week)", "Lagged National Two-Party Vote Share", "RDI Growth (Term)", "Incumbent Party"),
          dep.var.labels = "Republican Two-Party Vote Share (Nat.)",
          omit.stat = c("f", "rsq"),
          notes.align = "l",
          font.size = "tiny",
          column.sep.width = "1pt")

# Ensemble model - each model worth 1/3

ensemble_pred <- (1/3) * predict(mprev, trump_2020) + (1/3) * predict(m10, trump_2020) + (1/3) * predict(m2, trump_2020)

fundamentals <- as_tibble(data.frame(model = "Fundamentals", prediction = round(predict(mprev, trump_2020), 1), ses = 5.768))
tenweek <- as_tibble(data.frame(model = "Ten-Week", prediction = round(predict(m10, trump_2020), 1), ses = 2.709))
twoweek <- as_tibble(data.frame(model = "Two-Week", prediction = round(predict(m2, trump_2020), 1), ses = 3.154))
ensemble <- as_tibble(data.frame(model = "Ensemble", prediction = round(ensemble_pred, 1), ses = 0))
plot3 <- rbind(fundamentals, tenweek, twoweek, ensemble) %>% 
  ggplot(aes(x=model, y=prediction, color=model, ymin=0, ymax=100)) +
  geom_point(aes(size=0.01)) +
  geom_label_repel(aes(label=prediction), vjust=-5, segment.size=0) +
  geom_errorbar(aes(ymin = (prediction - 1.96*ses), ymax = (prediction + 1.96*ses), width=0.4, alpha=.5)) +
  theme_bw() + 
  theme(legend.position = "none") +
  xlab("Model") +
  ylab("Predicted Republican Two-Party Vote Share") +
  ggtitle("Figure 3: Ensemble and Component Model Predictions",
          subtitle = "With 95% Confidence Intervals") +
  ggsave("./Plots/week3plot3.png")
plot3
