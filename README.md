# ocm

## install hub

choice `kubeconfig` with hub cluster

```
make install-hub
```

## install agent

choice `kubeconfig` with agent cluster

```
make install-agent
```

## install proxy-agent

choice `kubeconfig` with hub cluster

```
make apply-managedcluster
```

## create agent kubeconfig

choice `kubeconfig` with agent cluster

```
make apply-hub-kubeconfig
```
