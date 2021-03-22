# +
import pandas
from aito.client import AitoClient
from aito.schema import AitoTableSchema
import aito.api as aito_api
from aito.utils.data_frame_handler import DataFrameHandler


def format_csv_to_json(
        aito_client,
        file_path,
        table_name,
        schema=None
        ):
    """ Format CSV file to JSON """
    # If schema is not given expect to get it from Aito
    if not schema:
        schema = {
            "type": "table",
            "columns": {
                "GL_Code": {
                  "type": "String",
                  "nullable": False
                },
                "Inv_Amt": {
                  "type": "Decimal",
                  "nullable": False
                },
                "Inv_Id": {
                  "type": "Int",
                  "nullable": False
                },
                "Item_Description": {
                  "type": "Text",
                  "nullable": False,
                  "analyzer": "english"
                },
                "Product_Category": {
                  "type": "String",
                  "nullable": False
                },
                "Vendor_Code": {
                  "type": "String",
                  "nullable": False
                }
              }
            }

    # Convert the data to be in correct data types by using the schema
    file_df = pandas.read_csv(file_path)
    data_frame_handler = DataFrameHandler()
    converted_file_df = data_frame_handler.convert_df_using_aito_table_schema(
          df=file_df,
          table_schema=schema
        )

    # Modify NA values to be None
    converted_file_df = converted_file_df.where(
        pandas.notnull(converted_file_df), None)

    return converted_file_df.to_dict(orient="records")


def get_schema():
    schema = {
        "type": "table",
        "columns": {
            "GL_Code": {
              "type": "String",
              "nullable": False
            },
            "Inv_Amt": {
              "type": "Decimal",
              "nullable": False
            },
            "Inv_Id": {
              "type": "Int",
              "nullable": False
            },
            "Item_Description": {
              "type": "Text",
              "nullable": False,
              "analyzer": "english"
            },
            "Product_Category": {
              "type": "String",
              "nullable": False
            },
            "Vendor_Code": {
              "type": "String",
              "nullable": False
            }
          }
        }
    return schema

def predict_row(aito_client, data, predict_query):
    """ Use Aito predict endpoint to predict a result for
    the given field for a data row.
    """
    # Use other columns than the field to be predicted to define
    # the where clause of the query
    where = {
        "Vendor_Code": data[1],
        "Inv_Amt": data[2],
        "Item_Description": data[3],
        "Product_Category": data[4]
    }

    predict_query["where"] = where

    # Send query to Aito predict endpoint
    result = aito_api.predict(
        client=aito_client,
        query=predict_query
        )

    return {
        "feature": result["hits"][0]["feature"],
        "confidence": result["hits"][0]["$p"]
        }
