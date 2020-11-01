## Final Prediction (11.1.20)

### A Primer

The election is days away, and the time has come to unveil my final model. This was an intensive process - many iterations of data wrangling, models, graphics, scenarios, etc. I had a few questions in mind going into this final exercise:

(1) Who will win the election? (Likely Biden.)

(2) Can I create a model similar to the binomial logit used in class? (Not a good one.)

(3) Is there another way for me to model without resorting to simple linear regression? (Yes.)

(4) Do I have faith in this model? (Yes.)

(5) Are there other scenarios I can use to test my assumptions? (A bunch.)

With that in mind, the roadmap is as follows:

(i) Outline my modeling process,
(ii) Justify my decisions,
(iii) Give my final prediction,
(iv) Detail alternate scenarios,
and (v) Conclude.

### Initial Attempts

[Earlier this fall](../Posts/week5.md), I tried and failed to create state-based models that could predict 2020 in a reasonable way. Even when I was able to code the binomial process, I found that my model was way too bullish on Biden’s prospects when translated into margins of victory, so I decided to go descriptive for that week’s blog post and move on.

I always intended on coming back to this, though, and I did for a few days earlier this week. I ran into a few problems:

(1) My base linear model was overfitting and spitting out landslide results.

(2) I was still having trouble looping the binomial logit for each state.

(3) While I understood how the model introduced uncertainty in turnout by drawing off a binomial distribution, I wasn’t sure how to improve what had already been done in section.

Overall, I wanted to see if there was another way to model the election that improved on the faults of simple linear regression. Since it seemed like the rest of the class was building relatively similar models, I thought it could be useful to approach the task differently. This brought me to random forests.

### My Solution: Random Forests

I was first introduced to random forests by my TF in Prof. Chetty’s Ec 1152 class my sophomore spring. The concept builds off of decision trees, which should sound familiar. Let’s say you wanted to figure out what fruit I was holding. You could ask me whether it was red. That question (or rather the outcome of that test) is a node on this tree, and each branch corresponds to each potential outcome. On the red branch, you may ask if the fruit is used to make cider, since you already know it’s red. On the not red branch, your best guess may be to ask another color question to help narrow things down. There are different ways to structure the tree’s nodes and choose which variables (color, size, etc.) to ask about, but the general concept is simple.

The problem with using a single tree is that it’s liable to overfitting. A tree could be constructed to perfectly fit the data if the number of nodes is unrestricted. Trees on their own are also very sensitive to noisy data.

Random forests help by increasing the number of trees (hence the name). Each individual decision tree is trained on a different sample of data and uses a random subset of predictors (to decrease overfitting), increasing the diversity of the whole. The outcome in question is determined by averaging the results of all of these decision trees. This method is particularly useful for state models (instead of a national model) because of the increased amount of data, which allows trees to use a wide variety of samples and predictors.

With that in mind, I decided to try it out on the election data I’ve compiled. Since the technique randomly selects predictors, I eliminated any other outcome variables in my dataset, which wouldn’t be useful in predicting 2020 outcomes anyway. I justified the inclusion of each variable by only selecting those I had used before in previous models. The one variable I added was presidential approval, and that was because I assumed that the random forest procedure would benefit from having an additional predictor to use. I created separate models for each party, both with the same formula:

$$ State Two-Party Popular Vote Share ~ Lagged State 2P Voteshare + Lagged National 2P Voteshare + (Within) 2-week Polling Support + (Up to) 10-week Polling Support + Annual GDP Growth + Annual Local Unemployment + Presidential Approval + Incumbent Party $$

Since random forest regression is itself an ensemble model, I can’t display coefficients for the model. Also, I did not specify the weights for each tree because that would defeat the purpose. Instead, I can visualize the 

An interesting feature of random forest models is that you can easily visualize the relative importance of each variable. These values are all relative - you shouldn’t compare these across models - but they provide insight into which variables factor more into the prediction. The results for my models are below:

![Relative Variable Importance](../Plots/importance.png)

As expected (and seen before), lagged vote share, 2-week support, and 10-week support factor the heaviest into the model’s performance. I’m not worried that economic factors lag behind because it is a strange year for the economy and generally speaking, other models tend to put less weight on economic fundamentals as the election nears (such as Silver 2020).

### Model Comparison

There were a bunch of other ways to specify the model that also made sense. I used two-party voteshare as the outcome variable, but using the unscaled voteshare was also a possibility. I also created models that predicted overall votes per party, models based on incumbency rather than party, and a unitary model to predict two-party voteshare for both candidates.

I used a familiar metric (root mean square error) to compare the models, which the table below visualizes:

![RMSE of Potential Models](../Plots/rmse.png)

A few takeaways:

(1) The main goal was to beat the original linear state-based model, which all of the specifications did.

(2) The incumbency-based and raw vote models didn’t perform great relative to the other models. The unitary model was competitive, but three of the specifications beat it, and conceptually, it makes more sense to individually model for each candidate.

(3) The incumbency-based models didn’t perform great relative to the other models, but the unscaled popular vote models had a better RMSE than two-party models. Why, then, did I choose the two-party model?

It boils down to the nature of the 2020 race. Unscaled popular vote total would be very useful if we expected to see a spoiler candidate. With respect to Jo Jorgensen, third parties don’t seem to be a major factor in the race.

Another use could be to model undecided voters. I initially thought that using unscaled voteshares could shed light on undecided voters. I was wrong for two reasons. First, Jacobson (2020) notes that the number of undecided voters is particularly low in this race. Second, even if I wanted to gauge differential values in undecided voters, it would be better to do that with a predictor rather than the outcome variable. Indeed, as the graph below shows, my model can help with this by having two separate polling averages at different points in the race. Since the number of unaligned poll respondents (undecided voters or third-party voters) goes down dramatically over the course of campaigning, I felt confident in using two-party voteshares to curtail the influence of outlier elections like 1992.

![Undecided Voter Trends](../Plots/undecided.png)

### 2020 Prediction

Before getting into model comparisons, validation, and scenarios, though, here are the results of 

I’m predicting a Biden victory

![My 2020 Prediction](../Plots/final_pv2p.png)

### References

Allcott, H., et al. (2020). "Polarization and public health: Partisan differences in social distancing during the coronavirus pandemic." *Journal of Public Economics* 191. November 2020. Accessed online.

*The Atlantic*. (2020). "The COVID Tracking Project." Updated October 23, 2020. Accessed online.

Vavreck, L. and Warshaw, C. (2020, September 18). "How local Covid deaths are affecting vote choice." *The New York Times.* Accessed online.
