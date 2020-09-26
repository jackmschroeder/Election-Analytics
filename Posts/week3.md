## The Economy (9.19.20)

### A Primer

This week's focus was *polling*. Amanda Cox of [The Upshot](https://www.nytimes.com/section/upshot) visited lecture and gave insightful comments on the state of polling in the age of Covid. In lab, we learned more about polls as they relate to predicting electoral outcomes.

We were given a few datasets to help with this week's lab. Two included polling averages in presidential elections dating back to 1968 (national and by state). We also received raw polling data for the 2016 election and for the current race. This dataset included **FiveThirtyEight**'s pollster ratings, which evaluate firms based on both historical accuracy and statistical rigor.

Finally, a new concept in lab was ensemble models. Essentially, these models take predictions from a multitude of other models and weigh them accordingly.

With all of this in mind, I wanted to answer four questions with this week's blog post:

(1) Are the pollster ratings evenly distributed? (It's more of a normal distribution, albeit with a lot of firms not yet rated.)

(2) Do these ratings vary by methodology? (Phone polls are generally viewed as higher quality.)

(3) Can I update my models to include polling averages? (Yes, and this helps greatly in predictions.)

(4) Lastly, what would my own ensemble model predict for this year's election? (Biden winning in a landslide.)

### Pollster Ratings

Each poll within the dataset of 2020 polls has its own rating from FiveThirtyEight. After filtering for general election polls and creating buckets of pollster ratings ("Good", "OK", and "Not Great"), I created a simple visualization of pollsters and their ratings.

![FiveThirtyEight Pollster Ratings](../Plots/week3plot1.png)

There are three takeaways from this histogram:

(1) Only a select number of pollsters (far less than one-third) qualify for a "Good" rating (above a B+).

(2) There are many "Not Great" pollsters. This is mainly due to pollsters without ratings. Going forward, I will filter them out before making visualizations. For this historgram, however, including them helps make clear that there are a relatively small number of trusted pollsters.

(3) With these in mind, it becomes clear that FiveThirtyEight's intentions with pollster ratings is for more of a *normal-looking distribution* instead of ratings evenly distributed across grades. This makes sense from a lot of angles, specifically in rewarding rigorous pollsters.

To test this, I created the plot below.

![Pollster Ratings by Methodology](../Plots/week3plot1a.png)

FiveThirtyEight's most common rating (by far) is a B/C.

### Methodology

![Pollster Ratings by Methodology](../Plots/week3plot2.png)

A nice extension of this work would be to see if *national and state pollsters differ* in rating or methodology. This may be worth looking into next week.

### Model Building

![Ten-Week and Two-Week Polling Model Results](../Plots/week3table1.png)

### Ensemble Model

![Ensemble Model Predictions](../Plots/week3plot3.png)