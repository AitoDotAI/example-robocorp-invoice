*** Settings ***
Variables       variables.py
Library         RPA.Cloud.Google
Library         RPA.HTTP
Library         AitoRFHelper
Library         Collections
Library         aito.api
Library         aito.client.AitoClient    ${AITO_API_URL}    ${AITO_API_KEY}    False    WITH NAME    aito_client
Suite Setup     Init Sheets Client    service_account.json

*** Variables ***
${trainingFile}         invoice_train.csv
${tableName}            roboc_invoices
${predictField}         GL_Code
${threshold}            0.8
${SHEET_RANGE}          Sheet1!A2:E51
${WRITE_RANGE}          Sheet1!F
${row_nr}               2
${increment}            1

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

*** Keywords ***
Make List
    [Arguments]     ${feature}    ${confidence}
    ${result}=      BuiltIn.Evaluate        ${confidence} <= ${threshold}
    ${list}=        Create List             ${feature}          ${confidence}       ${result}
    [Return]        ${list}      

*** Keywords ***
Predict GL With Aito
    [Arguments]     ${client}     ${predictQuery}        ${inputData}
    FOR    ${inputRow}    IN    @{inputData["values"]}
        &{result}=       Predict Row     ${client}       ${inputRow}    ${predictQuery}
        ${values}=       Make List       ${result}[feature]      ${result}[confidence]
        ${write_row}=    Catenate        SEPARATOR=      ${WRITE_RANGE}      ${row_nr} 
        Insert Values    ${G_SHEET_ID}     ${write_row}    ${values}
        ${row_nr}=       BuiltIn.Evaluate        ${row_nr} + ${increment}  
    END

*** Tasks ***
Upload data
    Download Sample Data
    ${client}    Get Library Instance    aito_client
    Upload Training Data    ${client}    ${trainingFile}    ${tableName}


*** Tasks ***
Label invoices
    ${spreadsheet_content}=    Get Values
    ...    ${G_SHEET_ID}
    ...    ${SHEET_RANGE}
    ${client}    Get Library Instance    aito_client
    ${predictQuery}    ${evaluateQuery}=    Quick Predict And Evaluate    ${client}    ${table_name}     ${predictField}
    Predict GL With Aito     ${client}    ${predictQuery}    ${spreadsheet_content}   
