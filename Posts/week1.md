---
layout: page
title: "Week 1: Introduction (9.12.20)"
permalink: /Posts/Week1
---

## Introduction (9.12.20)

### A Primer

This week, I worked with two bare-bones datasets. One relayed national popular vote totals in presidential elections, and the other contained state-by-state totals of the same information. For the below content, I focused on outcomes in the last 40 years, starting with the 1980 election.

These datasets lack predictive power because electoral outcomes are not wholly dependent on prior outcomes. Instead, I will create a predictive model in later weeks using a diverse set of benchmarks and indicators.

As a result, this week is focused on *data exploration*. Namely, I set out to analyze any simple trends hidden within these CSV files and plot them with the `ggplot` library.

### National Vote Share Trends

I first observed general variations in the national vote share between the two major parties (Republican and Democrat). Uniquely, most Americans internalize the results of elections through Electoral College votes, since they decide the winner. The general public largely disregards the popular vote, which can mask discrepencies between the two outcomes.

The current data only focus on the popular vote, so I am undergoing a descriptive analysis to answer two questions.

(1) Do vote shares vary much from election to election?

(2) Which state is the largest outlier in two-party vote share versus the national trend?

To answer these questions, I cleaned both datasets and added variables for vote margin and vote swing. I then graphed Republican two-party vote share versus year for each state. I also added a national trendline to accentuate the average.

![National Vote Share Trends](../Plots/week1plot1.png)

This visualization yields three distinct conclusions:

First, although certain states have deviated from a split two-party vote share in certain electoral cycles, **"landslide" electoral victories like Reagan in 1984** (where he lost one state and Washington, DC) **do not carry nearly the same magnitude in terms of the popular vote.** So, to answer question 1, vote shares do not vary nearly as much as previously thought.

Second, **elections are getting closer.**

There are two extensions for this visualization that will be improved upon in the next few weeks: (1) x-axis breaks corresponding to election years and (2) a horizontal line at 50%, signifying an even split in the two-party vote share. These should improve the graph's readability and allow the reader to more easily garner its conclusions. Another extension for the next few weeks is to plot national popular vote share versus electoral vote share, which could lead to some interesting visualizations.

### Blue, Red, and Purple: Intrastate Trends