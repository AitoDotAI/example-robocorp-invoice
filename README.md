## Aito.ai example: categorise invoices with Robocorp

**Summary:** Example robot that uploads and historic [dataset](https://www.kaggle.com/nikhil1011/predict-product-category-from-given-invoice) of purchase invoice data to Aito, and then reads more new invoices from Google Sheet and assigns them GL Codes based on ML predictions.

**Tools:** Using [Aito.ai](https://aito.ai) for machine learning predictions, and [Robocorp](https://robocorp.com/) Open Source RPA platform.

[![Here's a fancy screencast video](https://img.youtube.com/vi/tjWVnskjBlg/0.jpg)](http://www.youtube.com/watch?v=tjWVnskjBlg)

### Prerequisites and preparations

You will need to complete the following steps in order to run the robot yourself. Should you need help, there is also a way more detailed description of setting the environment [here](https://aito.document360.io/docs/aito-x-robocorp) with another use case.

*GOOGLE GCP + TARGET SHEET*

1. You'll need to have a Google account and be able to create Sheets. Take a copy of my [example sheet](https://docs.google.com/spreadsheets/d/1egc4-ka4G2R1piztdLWkj2qqflQcuoqxZBHffE3u8k0/edit?usp=sharing) and copy it locally to your Google Drive.
2. Follow the [steps described here](https://robocorp.com/docs/development-guide/google-sheets/interacting-with-google-sheets) to create a GCP Service Account, and the necessary JSON file. I have included an example file. That should be replaced with the real service account file (not EXAMPLE in the name obviously).
3. Add your Google Sheet ID in to `vault.json`. There is an example file that makes it easy to spot the right place. Just remove the EXAMPLE from the name.

*AITO INSTANCE*

1. Next you'll need an Aito account and intance. Start by creating a free account [here](https://aito.ai/sign-up/).
2. Log in to Aito account, and create an instance. Sandboxes are free. Take a note of your instance URL and read write API key after creation is ready.
3. Add URL and API key to `vault.json` file. This is the same file where you already added the Google Sheet ID.

### What does it do

The robot is split in to two main files: `tasks.robot` and `AitoRFHelper.py`. Former takes care of the main workflow in two tasks as described below. The latter serves as a helper and does things like Aito schema creation, and predictions that are just easier in Python.

1. First task is **Upload data** that pulls the dataset from our public S3 bucket. If the table does not yet exist in your Aito instance, it will upload the data in.
2. Second task is **Label invoices** which will read the Google Sheet file row by row, and make a prediction using Aito, and then fill in the results for each row. The filled values are the predicted GL code ("feature"), the confidence, and either FALSE or TRUE if the row needs a manual review, based on the set confidence `${threshold}`.

NOTE: GCP has ratelimits especially for Sheet write operations. If you are getting errors, start by checking what rate limits apply to you. Add a sleep in Keyword `Predict GL With Aito` for-loop if the per minute rates are exceeded.

**Contact:** Best way to reach us is through our [Slack group](https://aito.ai/join-slack/). Feeback would be awesome! <3