## Post-Election Narrative (12.8.20)

### A Primer

2020 is almost over. The people have voted, the models have been reflected upon, but there’s still time to evaluate some common post-election narratives. This cycle was full of hot takes from both sides preceding and in the immediate aftermath of the election. I plan on tackling one of these narratives: that pollsters and modelers **failed to “learn” from 2016** and **got the** *same* **things wrong**.

In the post below, I’ll:

(1) Elaborate on the take,
(2) Craft some testable implications of the narrative,
(3) Gather some data to test that implication,
(4) Explain what the tests *won’t* do,
5) Test that narrative,
And (6) present conclusions.

### The Take

Many observers of the 2020 election felt cheated by the coverage that dominated news cycles beforehand. To these people, Biden seemed like a sure thing, and the Democrats were likely to dominate congressional races as well. Reality disappointed.

Even though most data journalists advised caution (like some had before 2016), there was a collective outpouring of blame toward the analytics industry for failing to anticipate a close election. Some of these broadsides accused quantitatively-focused writers of failing to see what was happening “on the ground.” Others were more forceful, asserting that high poll numbers were tantamount to voter suppression.

Generally, though, it appeared that analytics *failed to “learn” from 2016*. Four years ago, many were stunned by President Trump’s electoral college victory. Pollsters and modelers claimed to have accounted for some of that error going forward by weighing by education and emphasizing uncertainty in forecasts. However, for many, 2020 was evidence that those fixes didn’t work. For these people, **the polls got the same things wrong again**.

This narrative is important to test because it is a *basic indicator of trust* in election analytics. If it appears that the polls were similarly wrong in 2020 as they were in 2016, trust in polling and modeling will decrease. The tangible impact of this could be in **lower poll response rates**. People may be less likely to devote time to answering opinionnaires if they believe the industry is fundamentally flawed. As a result, preliminary analyses like this will be **vital** for data-focused political junkies going forward.

### Testable Implications

How can the narrative be evaluated *empirically*? There are many ways to construct an analysis here, but I will focus on the following four methods, making sure to add **historical backtesting** when necessary to see if trends hold up with other recent elections:

(1) **Error correlation**: If the take is true, it implies that 2020 error should be correlated with 2016 error. Polls should have gotten states wrong in similar ways between cycles.

(2) **Regression significance**: If the narrative holds, 2016 polling error should help explain 2020 results. I’ll regress 2020 outcomes on polling averages and include past cycle polling error to see if it boosts explanatory power and is significantly correlated with the outcome variable. I’ll also go a step deeper and incorporate my pre-election prediction model.

(3) **Model adjustments**: This focuses more on modelers getting the same things wrong - if that’s the case, we should expect FiveThirtyEight’s adjusted polling averages to be similarly wrong as their 2016 adjusted averages. At a more fundamental level, I’ll also test whether adjusted poll averages outperform raw averages.

(4) **Time sensitivity**: Herding was seen to be a major problem in 2016, and if the take is correct, polls within two weeks of the election may overestimate the perceived leader. I’ll test whether polling averages two weeks out were more reliable in both elections than the averages on Election Day.

### Data

To answer these questions, I’m relying on a relatively spartan array of datasets. The bedrock of this will be statewide popular vote totals this century (all used previously in this class). I’ll augment that data with presidential polling averages (and adjusted averages) from *FiveThirtyEight*. I was tempted to look toward RealClearPolitics for their poll averages, but it makes more sense to compare apples to apples and use only the polls that FiveThirtyEight incorporated into their raw and adjusted averages. The overall combination of data will allow me to calculate polling error on the state level for each state from 2000 onwards.

### Limitations

For transparency, here is what these tests cannot show:

(1) *Causality* and what *actually* went wrong for pollsters in both cycles. Causality would require a much more rigorous approach and more in-depth data. Determining pollster mistakes would necessitate individually analyzing methodologies from each pollster and making a determination of whether weights were rigorous or arbitrary, then extending those findings into results-based analyses. I found it easier and more justified to use the polling averages because they represent the industry as a whole and because I expect the average voter to intuitively focus on the average as opposed to individual firms.

(2) Polling error in *down-ballot races*. There’s been a lot of the polls dramatically overestimating Democrats’ chances in key Senate races. A few notable House races were seemingly missed as well. I lack the data to properly analyze this, since I’m focusing on state-level polls and results on the presidential election.

(3) Which *demographics* polling had the most trouble with. It’s tempting to take these state-level analyses and try to correlate them with state-level demographics, but this would fall under the ecological fallacy. Demographic error is a very important question, though, and many people are likely working on it as you read this.

(4) Whether data journalists have *actually* utilized language surrounding uncertainty in their forecasts since 2016. Text analysis would be useful here, but I don’t have access to an “uncertainty corpus” or a dataset of prominent data-viz articles from 2016 and 2020.

(5) And much, much more. One of the major takeaways from this class has been to avoid large proclamations in favor of nuanced and rigorous positions. I’ll try not to fall victim to this: the work below is a *preliminary* analysis of the election.

### The Tests

#### Error Correlation

#### Regression Significance

#### Model Adjustments

#### Time Sensitivity

### Conclusions

### References

Druke, G. and Silver, N. (2020, Nov. 12). “How the pandemic might have affected the polls in 2020.” *FiveThirtyEight*. Accessed online.

Jacobson, L. (2020, Nov. 1). "Why is 2020 not like 2016? Fewer undecideds, for one." *The Tampa Bay Times*. Accessed online.

Rodden, J. (2019). *Why cities lose: The deep roots of the urban-rural political divide.* Basic Books.

Silver, N. (2020, Oct. 31). "Trump can still win, but the polls would have to be off by way more than in 2016." *FiveThirtyEight*. Accessed online.