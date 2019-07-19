
"""

Isaac Julien
7/11/2019

VQA Service

"""

from models import get_model, get_models, VQAModel

from flask import Flask
from flask_restplus import Resource, Api, fields

# Import Matplotlib
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# Flask app, auth, api:
app = Flask(__name__)
api = Api(app)

# Supported image formats:
image_formats = ['jpeg', 'png']

# Namespace:
ns = api.namespace('VQA Service', description='VQA Service')

# Model for VQA input (image-question pair):
vqa_input = ns.model('vqa_input', {
    'Image': fields.String(required=True),                          # Base64-encoded image
    #'Dimension': fields.List(fields.Integer(), required=True),      # Image dimension (x, y, z)
    #'Format': fields.String(required=True, enum=image_formats),     # Image format (png, jpeg, ...)
    'Question': fields.String(required=True),                       # Question
    'Model': fields.String(required=True)                           # Model ID
})

# Model for VQA response:
vqa_response = ns.model('save_response', {
    'Answer': fields.String(required=True)      # Answer
})


@api.route('/vqa')
class Clips(Resource):

    @ns.expect(vqa_input, validate=True)
    @ns.marshal_with(vqa_response, code=200)
    def post(self):

        print("************************************\n")
        print("Been there.... Done that....")

        # Get the image, question, and model to use:
        image = api.payload['Image']
        question = api.payload['Question']
        model_name = api.payload['Model']

        # ------------------- TEST ----------------------
        # Decode Image Data
        f = open("queryImage.png", "wb")
        f.write(image.decode('base64'))
        f.close()

        # Load and Show Image to Verify
        img = mpimg.imread("queryImage.png")
        plt.imshow(img)

        print("Image: ", image)
        print("Question: ", question)
        print("model_name: ", model_name)
        print("************************************\n")
        # -----------------------------------------------

        # Get the model:
        try:
            model: VQAModel = get_model(model_name)
        except Exception as e:
            return {"Error": "{}".format(e)}, 400

        # Answer using the model:
        answer = model.process(image, question)

        return {"Answer": answer}, 200


@api.route('/models')
class ContextManager(Resource):
    def get(self):
        return {"Models": list(get_models())}, 200


@api.route('/ping')
class ContextManager(Resource):
    def get(self):
        print("Hello World.... Pingggg.....")
        return "ping", 200


if __name__ == '__main__':

    app.run(debug=True, host='0.0.0.0', port=80)
