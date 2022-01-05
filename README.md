# Nashville_STR_effects
Repo for Midcourse project
Executive Summary
This section provides an overview to the project. It should briefly touch on the motivation, data question, data to be used, along with any known assumptions and challenges.
Short term rentals (STR) have become pervasive in neighborhoods across the metro Nashville area. Some neighborhoods have been more accepting of STRs than others. Many communities may see them as party houses and nuisances while others welcome the tourism dollars they bring to the city or the opportunity for people to make money off their home as a second source of income. I’m curious what actions people take to try to slow the influx of STRs into their neighborhood and if they could be using code violations as a means to that end.
Motivation
Here you will go into more detail about why you have chosen this project.
To understand the impact of STRs on longterm homeowners.
We will analyze the impact of STRs on factors outside of housing prices. The factors we will be considering are the locations of STRs and the occurrences of codes violations. Questions to assess:
• How have STRs impacted the home-owning experience in Nashville neighborhoods?
• Are STRs properties or long term homeowners receiving more violations? • Are some neighborhoods more impacted than others?
Data Question
Present your question. Feel free to include any research/articles that are relevant or show where others have attempted to answer this question.
h$ps://fox17.com/news/local/short-term-rentals-causing-long-term-problems-for-some- nashville-neighborhoods-travel-airbnb-nashville-tennessee h$ps://www.newschannel5.com/news/on-the-rise/short-term-rental-rule-violators-iden@fied- by-metro-codes
   •
•
• •
•
Are STR owners calling codes on their neighbors more often than their neighbors are calling codes on the STRs?
• A STR is a business, it’s in that business’ interest for the surrounding neighborhood to look nice so they can charge more for their rental.
When STRs accumulate in a neighborhood, is there are positive correlation between the number of STRs and the rate of property violation reports?
What are the property violations specifically?
Do these neighborhoods also undergo rapid property value increases from affordable to unaffordable for the average buyer or current owner?
Do they contribute to gentrification or are they a byproduct of it.

Minimum Viable Product (MVP)
Define your MVP. This should be a description of the functionality of your app, what visualizations will be included, who the intended audience is, etc.
Maps of STRs and property violations.
• Correlation between density of STRs and number of property violations.
Scrolling through neighborhoods:
• Double bar graph of STRs and violations by year from 2015-2021
with a slider for each Nashville neighborhood(zip code, or council district, or
school district).
• Or the reverse, slider for the year, neighborhood’s short term
rentals and property violations with a bar graph of the # of STRs
and code violations for each neighborhood (12South, Wedgewood, Music Row
etc.)
A map that can be swapped between STR permit violations or nuisance violations at STRs, and violations associated with “broken window” type enforcement to see if those violations are clustered around STRs.
Schedule (through 1/22/2022)
1. Get the Data (1/4/2022)
2. Clean & Explore the Data (1/8/2022)
3. Create Presentation and Shiny App (1/15/2022)
4. Internal Demos (1/18/2022)
5. Midcourse Project Presentations (1/22/2022)
Data Sources
• Zillow Data: h$ps://www.zillow.com/research/data/
• h$ps://data.nashville.gov/Business-Development-Housing/Property-Standards-
Viola@ons/479w-kw2x
• h$ps://data.nashville.gov/Licenses-Permits/Residen@al-Short-Term-Rental-Permits/
2z82-v8pm
• A crime dataset filtered for crimes near STRs.
Known Issues and Challenges
Explain any anticipated challenges with your project, and your plan for managing them.
• STRs operating without a permit would result in undercounting the STRs.

• They could also be an anchor point to see if the non-permitted STRs are the source of the violations.
• Property value increases lead to more violations being reported outside of STRs effects or a confounding factor.
I can merge datasets of STRs and code violations on those properties because both data sets have address columns to determine instances of people calling codes on the STR. It may be difficult to quantify the reverse. I could possible put a radius around the STR and only include codes violations that are within that STR. Some neighborhoods are likely to have overlap between many STRs in close proximity.
