
# In addition to the Host header and the request path, ingress rules can also use other HTTP request information to determine how to route traffic to backend services. Some of the commonly used request information include:
# HTTP headers: Ingress rules can use any HTTP header in the request to route traffic to the appropriate backend service. For example, you could use a custom HTTP header to route traffic to a specific backend service based on some application-specific logic.
# HTTP methods: Ingress rules can match HTTP requests based on the HTTP method used, such as GET, POST, PUT, or DELETE. This can be useful if you want to route traffic to different backend services based on the type of HTTP request.
# Query parameters: Ingress rules can also match on query parameters in the request URL. This can be useful if you want to route traffic to different backend services based on the value of a specific query parameter.
# TLS information: Ingress rules can match on the TLS information in the request, such as the SNI (Server Name Indication) field in the TLS handshake. This can be useful if you want to route traffic to different backend services based on the domain name in the TLS certificate.
# Here's an example ingress rule that uses HTTP headers to route traffic to different backend services:
# In this example, the headers field is used to route traffic to different backend services based on the value of the x-backend HTTP header in the request. Requests with the x-backend: api header will be routed to the api-service backend Service, while requests with the x-backend: web header will be routed to the web-service backend Service.
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: www.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
        headers:
          x-backend: api
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
        headers:
          x-backend: web

# Sure! Here's a more comprehensive example of an Ingress rule that uses multiple HTTP request parameters to route traffic to different backend services
# In this example:
# The Host field is set to example.com, so this Ingress rule will only apply to requests that have the Host header set to example.com.
# There are three different path rules defined, each of which routes traffic to a different backend service based on the request path and other request parameters:
# Requests that match the path /api with an x-backend: api header will be routed to the api-service backend Service. The pathRewrite field is used to rewrite the path from /api to /v1 before it is sent to the backend service.
# Requests that match the path /web with an x-backend: web header will be routed to the web-service backend Service. The pathRewrite field is used to rewrite the path from /web to / before it is sent to the backend service.
# Requests that match the path /blog with a User-Agent header that contains the string Googlebot and an Accept-Language header that contains the string en will be routed to the blog-service backend Service.
# The pathType field is set to Prefix for all three path rules, which means that requests that start with the specified path will be matched (e.g. /api and /api/foo will both match the first path rule).
# The httpHeaders field is used to match on specific HTTP headers in the request. In this case, the User-Agent and Accept-Language headers are used to match requests that are made by Googlebot and have an Accept-Language value of en, respectively. The op field is used to specify the type of matching to be performed on the header value (e.g. Equal, Contains, etc.).
# This is just one example of how Ingress rules can be used to route traffic to different backend services based on HTTP request parameters. In general, Ingress rules provide a lot of flexibility and can be customized to suit a wide range of use cases.

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
        pathRewrite:
          - path: /api
            replacement: /v1
        headers:
          x-backend: api
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
        pathRewrite:
          - path: /web
            replacement: /
        headers:
          x-backend: web
      - path: /blog
        pathType: Prefix
        backend:
          service:
            name: blog-service
            port:
              number: 80
        headers:
          x-backend: blog
        httpHeaders:
          - name: User-Agent
            value: "Googlebot"
            op: Equal
          - name: Accept-Language
            value: "en"
            op: Contains
