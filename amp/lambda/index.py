def lambda_handler(event, context):
    # ここにLambda関数の本体を実装する
    print("Event: ", event)
    print("Context: ", context)
    return "Hello from Lambda!"
