*** Settings ***
Variables       variables.py
Library         RPA.Cloud.Google
Library         RPA.HTTP
Library         AitoRFHelper
Library         Collections
Library         Dialogs
Library         aito.api
Library         aito.client.AitoClient    ${AITO_API_URL}    ${AITO_API_KEY}    False    WITH NAME    aito_client
Suite Setup     Init Sheets Client    service_account.json

*** Variables ***
${trainingFile}         invoice_train.csv
${tableName}            roboc_invoices
${predictField}         GL_Code
${threshold}            0.8
${SHEET_RANGE}          Sheet1!A2:H51

*** Keywords ***
Download Sample Data
    Download    https://aitoai-public.s3.eu-central-1.amazonaws.com/datasets/invoice_train.csv    overwrite=True

*** Keywords ***
Upload Training Data
    [Arguments]    ${client}    ${filePath}    ${tableName}
    ${schema}=        Get Schema
    ${entryData}=     Format CSV To Json    ${client}    ${filePath}    ${tableName}
    ${tableExists}    Check Table Exists    client=${client}    table_name=${table_name}
    Run Keyword Unless    ${tableExists}    Create Table    client=${client}    table_name=${tableName}     schema=${schema}
    Run Keyword Unless    ${tableExists}    aito.api.Upload Entries    ${client}    ${tableName}    ${entryData}

*** Tasks ***
Upload data
    Download Sample Data
    ${client}    Get Library Instance    aito_client
    Upload Training Data    ${client}    ${trainingFile}    ${tableName}


*** Tasks ***
Label invoices
    ${client}    Get Library Instance    aito_client
    ${predictQuery}    ${evaluateQuery}=    Quick Predict And Evaluate    ${client}    ${table_name}     ${predictField}
    ${sheet}=    Get Values     ${G_SHEET_ID}      ${SHEET_RANGE}
    ${values}    Set Variable    ${sheet}[values][0:]
    FOR    ${row}    IN    @{values}
        &{aitoresult}=    Predict Row       ${client}       ${row}    ${predictQuery}
        ${review}=        BuiltIn.Evaluate  ${aitoresult}[confidence] <= ${threshold}
        Append To List    ${row}     ${aitoresult}[feature] 
        Append To List    ${row}     ${aitoresult}[confidence]
        Append To List    ${row}     ${review}
    END
    ${response}=    Update Values    ${G_SHEET_ID}    ${SHEET_RANGE}    ${sheet}[values]
    Log Many    ${response}
