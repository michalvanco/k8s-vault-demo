# Kubernetes Vault Demo

This simple application is proving the integration of k8s & vault.

## Prerequisites
Vault and k8s configured by following steps described in https://git.nixaid.com/arno/vault-demo 
or internally in https://confluence.intgdc.com/display/~evgeny.shmarnev/Vault+auth-backend%3A+Kubernetes.

To store value in vault, do following steps:
```
# using vault binary client to write values (vault has to be unsealed)
$ vault write secret/kubernetes/hello value=world

# your policies should be able to access value - update the HCL
$ vault policy-write kubernetes kubernetes-policy.hcl

$ vault policies kubernetes
# Allow tokens to look up their own properties
path "auth/token/lookup-self" {
    capabilities = ["read"]
}

# Allow access to k8s secrets
path "secret/kubernetes/*" {
    capabilities = ["read"]
}

# Update role so that it's able to use kubernetes policy
$ vault write auth/kubernetes/role/demo policies=kubernetes
```

## Build
`$ docker build . -t k8s-vault-demo`

## Publish image
```
$ docker tag k8s-vault-demo <docker-registry>/k8s-vault-demo:1.0
$ docker push <docker-registry>/k8s-vault-demo:1.0
```

## Deploy to k8s
Use following deployment description:
```
apiVersion: v1
kind: Pod
metadata:
  name: k8s-vault-demo
spec:
  serviceAccount: vault-auth
  containers:
  - name: k8s-vault-demo
    image: <docker-registry>/k8s-vault-demo:1.0
    imagePullPolicy: Always
    env:
      - name: VAULT_ADDR
        value: <vault-address-with-port>
```

And then deploy on k8s master via `kubectl create -f k8s-vault-demo.yaml``.

## CI pipeline
TBD
