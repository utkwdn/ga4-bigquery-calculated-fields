# GA4 BigQuery Calculated Fields for Looker Studio

This repository contains a collection of SQL statements used to create custom GA4 dimensions and metrics in Looker Studio using Google Analytics 4 (GA4) data from BigQuery. These calculated fields are meant to cover the most common GA4 metrics used for web performance reporting, campaign tracking, and audience analysis for web analytics use cases.

***

## USAGE INSTRUCTIONS 

Prerequisite: You must have a Google Cloud Console account with a billing-enabled project. 
A GA4 property should already be connected to your BigQuery instance within your
project in Google Cloud Console. 

Using GA4 BigQuery Calculated Fields in Looker Studio
1. Connect to the BigQuery data source in your Looker Studio report. 
2. Select the project and dataset where you want to pull data from BigQuery. 
3. Open the Data panel within the table or chart that you want to use GA4 BigQuery data.
4. Click the "Add a field" button > Add calculated field.
5. Type in the appropriate field name for the dimension or metric.
6. Copy and paste the SQL statement into the formula field.
7. Click Done. 

The calculated field should now populate as a dimension or metric that you can use in the 
Properties panel of your Looker Studio report. 

## NOTES

Using the correct aggregation method for metrics in scorecards, charts, and tables in Looker 
Studio will result in the most accurate data using GA4 BigQuery data.

Metrics requiring the COUNT aggregation method:
- Views

Metrics requiring the COUNT DISTINCT aggregation method:
- Form Submissions
- Sessions

