import json

def lambda_handler(event, context):
    """
    Lambda関数ハンドラー
    API Gatewayからのリクエストを処理し、認証結果を返します。
    """
    print("Event:", event)

    # 認証ロジック（例: 特定のトークンを確認）
    token = event.get("headers", {}).get("Authorization", "")
    
    if token == "valid-token":
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Authorization successful!"
            })
        }
    else:
        return {
            "statusCode": 403,
            "body": json.dumps({
                "message": "Authorization failed."
            })
        }