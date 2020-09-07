# k8s-debug-pod
A docker image with tools and utils for debugging things in a k8s cluster

## Usage
To spin up a temp pod run something similar to the following:

```
kubectl run --generator=run-pod/v1 my-shell --rm -i --tty --image quay.io/givanov/debug:v1.0.0
```

If you want, you can create an alias in your .bashrc file for quick access:

```
alias debugshell=kubectl run --generator=run-pod/v1 my-shell --rm -i --tty --image quay.io/givanov/debug:v1.0.0
```