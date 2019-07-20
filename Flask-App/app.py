# Import Dependencies
import base64
from flask import Flask, jsonify
from flask_restplus import Resource, Api, fields

# Array defining Versions/Names of ML Models
models = ['v1.1', 'v1.2']

# Flask app, auth, api:
app = Flask(__name__)
api = Api(app)

# Namespace:
ns = api.namespace('Flask Service', description='Flask Service')

# ML Model Input: Image, Model Version
model_input = ns.model('model_input', {
    'Image': fields.String(required=True),                          # Base64-encoded image
    'Model_Version': fields.String(required=True)                   # Model ID
})

# ML Model Response: Answer
model_response = ns.model('model_response', {
    'Answer': fields.String(required=True)                          # Answer
})


# Function to get all Versions of ML Model Available
@api.route('/models', methods=['GET'])
class ModelManager(Resource):
    def get(self):
        response = jsonify({"models": str(models)})
        response.status_code = 200
        return response


# Sample function to test REST API calls
@api.route('/ping', methods=['GET', 'POST'])
class TestManager(Resource):
    def get(self):
        response = jsonify({"ping": "Hello World..."})
        response.status_code = 200
        return response


@api.route('/predict', methods=['POST'])
class ModelManager(Resource):
    @ns.expect(model_input, validate=True)
    @ns.marshal_with(model_response, code=200)
    def post(self):
        # Get the image, question, and model to use:
        image = api.payload['Image']
        model_name = api.payload['Model_Version']

        # Decode Image Data
        img = base64.b64decode(image)

        # Save Decoded Image
        f = open("image.jpg", "wb")
        f.write(img)
        f.close()

        return {"Answer": str(model_name)}, 200


# Main
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)