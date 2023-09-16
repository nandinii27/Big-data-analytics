# Predictive Donor Activation

This repository is for the Donor Re-Activation Campaign Analysis project. In this project, an organization aims to assist non-profit organizations in finding donors for their philanthropic causes. Focus of this project is on developing a predictive model to identify inactive donors who are likely to re-engage with the organization through re-activation campaigns.

## Project Overview

Organization possesses a vast database of candidate donors and wants to launch a re-activation campaign targeting inactive donors. The objective is to convince the CEO & Head of Data Analytics that our predictive model is more effective than random selection. We worked with datasets provided by the organization, containing donor information, donation history, campaign selections, and campaign details.

## Project Goals

1. **Data Cleaning and Exploration:** Begin by cleaning the provided datasets and gaining insights into their content.

2. **Target Definition:** Identify donors from the campaign selections who made donations equal to or greater than €30 as the target for train and test data.

3. **Feature Engineering:** Construct relevant features for modeling using both the donors and gifts datasets. Carefully consider the timeline of information available for training.

4. **Model Building:** Develop predictive models using various algorithms. Compare model performances and assess their interpretability.

5. **Model Evaluation:** Evaluate models using AUC, lift, cumulative gain curves, and cumulative response curves.

6. **Business Case:** Analyze the potential impact of the predictive model on campaign performance. Quantify gains from using the model and determine the number of contacts required for an assumed campaign cost of €0.80 per letter.

7. **Scoring and Presentation:** Score a new dataset of donorIDs using the developed model. Prepare a 10-minute presentation to convince stakeholders of the model's value.

## Datasets Provided

- **donors.csv:** General information about the candidate donor database.
- **gifts.csv:** Information about past donations from candidate donors.
- **selection campaign 6169.csv:** Donors selected for a previous re-activation campaign.
- **selection campaign 7244.csv:** Donors selected for another re-activation campaign.
- **campaigns.csv:** Information about campaigns organized by DSC.

## Output

- Information used for predictions.
- Donor profile analysis.
- Model performance metrics (lift, cumulative gains, cumulative response).
- Business case demonstrating potential gains and required contacts for future campaigns.
- Well-documented Jupyter notebooks used for the project.
- A set of scored DonorIDs with corresponding donation probabilities.
