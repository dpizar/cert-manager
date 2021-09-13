# cert-manager
CNCF cert-manager dynamic HTTPs demo with Istio. Demo was done using Google Cloud.

## 1. Create GKE cluster
```
gcloud container clusters create cert-manager-demo --enable-network-policy --machine-type=e2-standard-4 --num-nodes=1 --release-channel=stable
```

### 1. a. Authenticate to the cluster
```
gcloud container clusters get-credentials cert-manager-demo --region us-central1
```


## 2. Download and Install Istio(Make sure you have the necessary firewall rules to allow instio be installed)
```
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.11.0
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
```

### 2. a Get the external IP from the Istio ingress gateway
```
kubectl get svc -n istio-system istio-ingressgateway
kubectl label namespace hello istio-injection=enabled
```

### 2. b Set a DNS records to this IP, so the cluster can be accessed from the internet. Use your domain name e.g. diego.cloud-montreal.ca


## 3. Install cert-manager using helm, follow instructions from documentation
```
https://cert-manager.io/docs/installation/helm/
```


## 4. Create 'hello' namespace and label it for istio
```
kubectl create ns hello
kubectl label ns hello istio-injection=enabled
```

### 4. a Install 'hello' sample application for testing cert-manager. We will use this application to get a certificate
```
kubectl apply -n hello -f https://raw.githubusercontent.com/istio/istio/1.11.0/samples/helloworld/helloworld.yaml
```


### cert-manager architecture
![Picture1](https://user-images.githubusercontent.com/10835827/133097485-3ff09286-9c42-4c2d-bef6-d65c3c9d95c2.png)


*Note: Check code in this repository, as well as presentation for more details on these resources.
## 5. Create an Issuer resource, apply it and check it
```
kubectl apply -f issuer.yaml
kubectl get issuer -n istio-system
```


## 6. Create Certificate resource, apply it and see if it was created as well as if the secret was created
```
kubectl apply -f certificate.yaml
kubectl get certificate -n istio-system
kubectl get secret -n istio-system test-certificate
kubectl describe certificate test-certificate -n istio-system
kubectl get secret test-certificate -n istio-system -o yaml
```


## 7. Create Gateway resource and apply it
```
kubectl apply -f gatewayhttps.yaml
```


## 8. Create VirtualService resource to route traffic to backend Kubernetes service 'helloworld'
```
kubectl apply -f virtualservice.yaml
```


*Note: make sure traffic is allowed into your cluster, otherwise create a firewall. Example rule in this repo.
## 9. got to your domain and see if your website has the certificate  
e.g. https://diego.cloud-montreal.ca/hello
