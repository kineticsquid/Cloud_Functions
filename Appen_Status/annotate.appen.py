
import datetime

def main(request_input):

    print("Input:")
    print(request_input)

    if request_input.get('action') == 'test':
        print("Testing...")

    return_result = "Status here"
    print(return_result)
    return {"statusCode": 200, "body": return_result}


if __name__ == '__main__':
    today = datetime.datetime.now().toordinal()
    main({"action": "test",
          "foo": "bar"})
