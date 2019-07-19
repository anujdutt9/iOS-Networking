
import base64
import requests
import json

# import sys
# sys.path.append('.')
# import app

IMG_FILE = 'test/images/leslie.jpeg'
LOCAL_URL = 'http://localhost:80/vqa'

if __name__ == '__main__':

    with open(IMG_FILE, "rb") as image_file:
        img_64 = str(base64.b64encode(image_file.read()))

    question = "what was his first movie"

    response = requests.post(
        url=LOCAL_URL,
        json={
            'Image': img_64,
            'Question': question,
            'Model': 'v1'
        }
    )

    result = json.loads(response.content)
    print("Response: {}".format(result))

