## Post-Election Reflection (11.22.20)

### A Primer

Now that the 2020 election is (mostly) behind us, it’s time to evaluate my model and its components. In this post, I’ll be answering the following questions:

(1) What exactly was my model, again, and how did it do? (The random forest regression performed better than expected, but still room for improvement!)

(2) Is there anything to learn from my alternate specifications? (Previous error is worth considering, but take it with a grain of salt.)

(3) How was my error distributed? (It was more based on party than geography.)

(4) Where did my predictors go wrong, and can I quantitatively test these beliefs? (I have some theories that may be testable.)

With that in mind, let’s proceed to a quick model recap:

### Model Recap

My final model was a random forest regression predicting each party’s two-party voteshare in each state.

*What is a random forest?* It is a regression/classification technique based on decision trees (think: flowcharts). A single decision tree is prone to overfitting the sample data and inaccurately predicting future outcomes. Random forests try to avoid these issues by forming many trees, each with a random sample of the data and only a handful of the predictors. The model averages each tree’s prediction and spits out a final point estimate. Each party had its own model, which predicted a two-party voteshare estimate for each state.

*What did I feed into the model?* Throughout class, we worked with many different sources of data. I ended up with eight predictors: polls (two-week and ten-week state polling averages), fundamentals (annual national GDP growth, annual local state unemployment, presidential approval, and a dummy variable for incumbent party), and lagged variables (2016 national and state voteshares). Since each tree had a random sample of data, each variable had to have complete data. This kept me from using data pre-1980.

*Is the model any good?* Historically, the party models average out to a root mean square error of *3.02 percentage points*. What does this capture? This is the in-sample error of the model. However, due to the random sampling of data within each tree, this number also helps account for out-of-sample error, since each tree only had access to a subset of the overall data.

*What was the prediction?* As the visual below shows, I predicted a healthy Biden victory of 334 electoral votes to Trump’s 204. There were seven states within the historical error (in order of predicted Trump support): Arizona, Florida, North Carolina, Georgia, Ohio, Iowa, and Texas.

![My 2020 Prediction](../Plots/final_pv2p.png)

*How did it do?* Not bad at all. It got three states wrong: Florida, North Carolina, and Georgia. The model missed Florida by more than the historical error (it was 3.9 points off). North Carolina was a bit closer at 2 points off. Surprisingly, Georgia was tied for the fourth-closest state, with the predicted estimate only being off by 0.3 points. Overall, the model had an *RMSE of 2.966*. That number drops to 2.856 when New York is excluded due to incomplete results that currently favor Trump. Either way, the RMSE outperforms the original RMSE of 3.02, which is pretty unexpected for an election said to be hard to predict.

*How does this error look?* I’m glad you asked, since it’s plotted below! One fun outcome: Virginia, with a predicted Trump two-party voteshare of 44.8%, was accurate down to the tenths place! Overall, the model missed low on Trump support, particularly where he was projected to be strongest.

![Simple Model Error](../Plots/simpleerror.png)

Before dissecting this error, though, I want to go over one of the alternate scenarios from my final prediction:

### Scenario Planning

![Prediction with 2016 Error](../Plots/final_error.png)
RMSE 2.911 (2.788 w/o NY), but this got lucky - usually don’t correlate election-to-election

### Sources of Error

Geographically distributed?
![State Model Error](../Plots/errormap20.png)

Partisan distribution?
![Party Model Error](../Plots/boxplot.png)
2 big misses (FL and NC), but GA was only off by 0.4 - one of the closest states

### Correlate Analysis & Tests
# Need hypotheses

Remember importance?
![RF Importance](../Plots/importance.png)

How did correlates do?
![Correlate Error](../Plots/correlates.png)

Polling more specifically - steady then shift
![Polling Avg Error](../Plots/pollavg.png)

### Takeaways/Room for Improvement
