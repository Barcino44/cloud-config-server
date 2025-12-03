# 🛠️ Cloud Config – E-Commerce Microservices Platform

Este repositorio contiene la configuración centralizada del ecosistema de microservicios del proyecto My-Ecommerce, utilizada por el Spring Cloud Config Server desplegado en Kubernetes.
Su función es proporcionar parámetros externos, versionados y actualizables sin necesidad de reconstruir las imágenes de los servicios.

## 📌 Arquitectura relacionada

* El Config Server forma parte de una plataforma basada en:

* Kubernetes (Minikube / cluster real)

* Istio / NGINX Ingress Controller (gateway.local)

* Spring Boot + Spring Cloud Netflix (Eureka, Gateway)

* Blue-Green & Canary deployments

* Prometheus, Grafana, Jaeger,  Zipkin

* Helm Charts para cada microservicio

Cada microservicio obtiene su configuración remota mediante:

spring:
  config:
    import: `` "optional:configserver:http://my-ecommerce-cloud-config:9296/" ``

## 📁 Estructura del repositorio

````
favourite-service.yml
favourite-service-dev.yml
favourite-service-stage.yml
favourite-service-prod.yml

order-service.yml
order-service-dev.yml
order-service-stage.yml
order-service-prod.yml

payment-service.yml
payment-service-dev.yml
payment-service-stage.yml
payment-service-prod.yml

product-service.yml
product-service-dev.yml
product-service-stage.yml
product-service-prod.yml

proxy-client.yml
proxy-client-dev.yml
proxy-client-stage.yml
proxy-client-prod.yml

service-discovery.yml
service-discovery-dev.yml
service-discovery-prod.yml
 README.md
````

🚀 Recuperar la configuración desde Kubernetes, usando curl.

````
curl http://my-ecommerce-cloud-config:9296/order-service/dev
````
Ejemplo típico de salida:

````
{
  "name": "order-service",
  "profiles": ["dev"],
  "propertySources": [...]
}
````
