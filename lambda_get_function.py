import boto3
import json

def lambda_handler(event, context):
    # TODO implement
    TABLE_NAME = "jt-cloud-resume-challenge-counter"
    db_client = boto3.client('dynamodb')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(TABLE_NAME)
    
    update = db_client.update_item(
        TableName=TABLE_NAME,
        Key={"id": {"N": "0"}},
        UpdateExpression="ADD visitcount :inc",
        ExpressionAttributeValues={":inc": {"N": "1"}}
    )
    
    getItems = table.get_item(Key={"id": 0})
    itemsObjectOnly = getItems["Item"]
    visitcount = itemsObjectOnly["visitcount"]

    response = {
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Headers": "*",
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        "status_code": 200,
         "body" : {
            "count": visitcount
        }
    }

    return response
  
