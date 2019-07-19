"""
Isaac Julien
07/11/2019

Class for Model (abstract), and function for retrieving models by name:




import boto3
client = boto3.client('rekognition')
photo="/Users/isaacjulien/Downloads/downloads/Steve Harvey/2.steve-harvey.jpg"
with open(photo, 'rb') as image:
    response = client.recognize_celebrities(Image={'Bytes': image.read()})
print(response)


"""


import abc


# VQAModel Base Class: #################################################################################################

class VQAModel(abc.ABC):

    @abc.abstractmethod
    def process(self, image, question):
        """
        Process image and question, and return answer:

        :param image:           Base64-encoded image (string)
        :param question:        Question (string)
        :return:                Answer (string)
        """
        pass


# BasicModel: ##########################################################################################################

class BasicModel(VQAModel):
    def process(self, image, question):
        return "I don't know!"

# BasicModel: ##########################################################################################################

class BasicModel(VQAModel):
    def process(self, image, question):
        return "I don't know!"


# Utilities to get models by name: #####################################################################################


MODELS = {
    "basic": BasicModel
}


def get_model(model_name):
    """
    Get a model instance by name, or raise Exception if name is invalid:

    :param model_name:          Name of model
    :return:                    Model
    """
    if model_name not in MODELS:
        raise Exception("Model '{}' does not exist".format(model_name))
    return MODELS.get(model_name)()


def get_models():
    return MODELS.keys()
