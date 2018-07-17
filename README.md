# LiveObjectDetection
This show the example of integrating coreML and vision to detect object on live camera


This i just a demo of live detection of objects using CoreML

VNCore is the Prefix for vision 

CORE ML with Vision Steps :-

- Create Vision model (its optional ,FYI)
- Create Request (with closure)
- Create Request handler
- From request Handler perform request 
- User handler block (from request) to get results as VNClassificationObservation and get result with High confidence
