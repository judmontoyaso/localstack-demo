import json

def handler(event, context):
    name = event.get('name', 'Mundo')
    return {
        'statusCode': 200,
        'body': json.dumps({'message': f'Hola, {name}!'})
    }