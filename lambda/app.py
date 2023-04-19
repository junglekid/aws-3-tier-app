'''
Lamdba Function to get shirt color and to add new shirt color
'''

import os
import json
import boto3
from boto3.dynamodb.conditions import Key
import random

dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMODB_TABLE"]
table = dynamodb.Table(table_name)


def get_shirt_colors(table):
    response = table.scan(ProjectionExpression="Color")

    return [item["Color"] for item in response["Items"]]

def color_exists(table, color):
    response = table.query(
        KeyConditionExpression='Color = :color',
        ExpressionAttributeValues={
            ':color': color
        }
    )

    return 'Items' in response and len(response['Items']) > 0


def lambda_handler(event, context):
    path = event['path']

    if path == '/get-shirt-color': 
        colors = get_shirt_colors(table)
        random_shirt_color = random.choice(colors)

        response = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
            },
            "body": json.dumps({
                "message": f"You should wear a {random_shirt_color} shirt today.",
            }),
        }
    
        return response
        
    elif path == '/add-shirt-color':
        body = json.loads(event['body'])
        color = body['color']
        
        if not color_exists(table, color):
            table.put_item(
                Item={
                    'Color': color
                }
            )

            response = {
                "statusCode": 200,
                "headers": {
                    "Content-Type": "application/json",
                },
                "body": json.dumps({
                    "message": f"Successfully added shirt color {color}.",
            }),
        }
        
        else:
            response = {
                "statusCode": 409,
                "headers": {
                    "Content-Type": "application/json",
                },
                "body": json.dumps({
                "message": f"Color '{color}' already exists in the table.",
            }),
        }

        return response
    
    else:
        response = {
                "statusCode": 404,
                "headers": {
                    "Content-Type": "application/json",
                },
                "body": json.dumps({
                "message": f"Not found",
            }),
        }

        return response
