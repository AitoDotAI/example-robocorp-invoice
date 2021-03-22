### Aito.ai example: categorise invoices with Robocorp

**Summary:** Example robot that uploads and historic [dataset](https://www.kaggle.com/nikhil1011/predict-product-category-from-given-invoice) of purchase invoice data to Aito, and then reads more new invoices from Google Sheet and assigns them GL Codes based on ML predictions.

**Tools:** Using [Aito.ai](https://aito.ai) for machine learning predictions, and [Robocorp](https://robocorp.com/) Open Source RPA platform.

**Prerequisites and preparations**

You will need to complete the following steps in order to run the robot yourself. Should you need help, there is also a way more detailed description of setting the environment [here](https://aito.document360.io/docs/aito-x-robocorp) with another use case.

*GOOGLE GCP + TARGET SHEET*

1. You'll need to have a Google account and be able to create Sheets. Take a copy of my [example sheet](https://docs.google.com/spreadsheets/d/1egc4-ka4G2R1piztdLWkj2qqflQcuoqxZBHffE3u8k0/edit?usp=sharing) and copy it locally to your Google Drive.
2. Follow the [steps described here](https://robocorp.com/docs/development-guide/google-sheets/interacting-with-google-sheets) to create a GCP Service Account, and the necessary JSON file. I have included an example file. That should be replaced with the real service account file (not EXAMPLE in the name obviously).
3. Add your Google Sheet ID in to vault.json. There is an example file that makes it easy to spot the right place. Just remove the EXAMPLE from the name.

*AITO INSTANCE*

1. Next you'll need an Aito account and intance. Start by creating a free account [here](https://aito.ai/sign-up/).
2. Log in to Aito account, and create an instance. Sandboxes are free. Take a note of your instance URL and read write API key after creation is ready.
3. Add URL and API key to vault.json file. This is the same file where you already added the Google Sheet ID.

Robot tasks:

1. First task is ...

Prerequisites:

Contact: