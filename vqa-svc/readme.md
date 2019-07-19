
# VQA Service


## About

This is a Flask service for VQA (visual question answering).

The inputs are:
* An image (as a base-64 string),
* A question (as a string), and
* A model ID.

The model ID parameter exists so that we can try out a bunch of different models on the server side and
quickly switch between them on the client (e.g., iOS app).

The returned response is an answer, as text.


## Usage:


### Python (requests):

```
import base64
import requests
import json
    
with open(IMG_FILE, "rb") as image_file:
    img_64 = str(base64.b64encode(image_file.read()))
    
response = requests.post(
    url="http://localhost:80/vqa",
    json={
        'Image': img_64,
        'Question': "what what this actor's first movie?",
        'Model': 'v1'
    }
)
    
result = json.loads(response.content)
print("Response: {}".format(result))

```

```
Response: {'Answer': '...'}
```

### cURL:

```
curl -X POST -H "Content-Type: application/json" http://$HOST:$PORT/vqa -d '{"Image": "abc", "Question": "cde", "Model": "def"}'
```
```
{'Answer': '...'}
```

Also:

```
curl -X POST -H "Content-Type: application/json" http://$HOST:$PORT/models
```
```
{"Models": ["basic"]}
```

## Python version:

3.6.1


## Configuration:

* Configure AWS:
    * `aws configure`
* [Set up aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html):
    * Install: `curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/darwin/amd64/aws-iam-authenticator`
    * Set permissions: `chmod +x ./aws-iam-authenticator`
    * Copy binary to HOME/bin/: `mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH`
    * Add to path: `export PATH=$HOME/bin:$PATH`
    * Verify: `aws-iam-authenticator help`
* Create kubeconfig file:
    * Create in default location: `aws eks --region <region> update-kubeconfig --name <namespace>`
    * Add to path: `export KUBECONFIG=$HOME/.kube/config`

## Deployment


* Set aws-iam-authenticator path:
    * `export PATH=$HOME/bin:$PATH`
* Set kubeconfig path:
    * `export KUBECONFIG=$HOME/.kube/config`
* Check that we're connected to the correct AWS cluster:
    * `kubectl cluster-info`
    * `kubectl get svc`
* Build new docker image and push to ECR:
    * `./build-K8s.sh`
* Delete old deployment:
    * `kubectl delete deployment vqa-svc`
* Start service:
    * `kubectl apply -f deploy/deployment.yaml`
    * `kubectl apply -f deploy/service.yaml`
* Test:
    * `curl -u clp:cortex -X GET http://a656aa9fd774511e9b0961272e494ff4-1292006208.us-east-1.elb.amazonaws.com:8080/context/ping` (should get "ping")
    * `curl -X GET http://a656aa9fd774511e9b0961272e494ff4-1292006208.us-east-1.elb.amazonaws.com:8080/context/ping` (should get "unauthorized access")


## Testing:

Set k8s info:

`
HOST=ad8b97512a3f511e9aa51023ebee7912-15301151.us-east-1.elb.amazonaws.com
`

`
PORT=8080
`

Or local info:

`
HOST=localhost
`

`
PORT=80
`

Test */ping*:

`
curl -X GET http://$HOST:$PORT/ping
`

Test */models*:

`
curl -X GET http://$HOST:$PORT/models
`

Test */vqa*:

`
curl -X POST -H "Content-Type: application/json" http://$HOST:$PORT/vqa \
-d '{"Image": "abc", "Dimension": [10, 20, 3], "Format": "jpeg", "Question": "cde", "Model": "basic"}'
`


## AWS/K8s reference:

* Log in to ECR:
    * `aws ecr get-login --no-include-email`
* See all services, pods, ...:
    * `kubectl get all`
* Check service status:
    * `kubectl get pods -n <namespace>`
* See service logs:
    * `kubectl logs <pod-name> -n <namespace>`
* See service pod info:
    * `kubectl describe pod <pod-name> -n <namespace>`
* Delete service:
    * `kubectl delete deployment <app-name> -n <namespace>`
* Restart service:
    * `kubectl apply -f /path/to/deployment_config.yaml`
