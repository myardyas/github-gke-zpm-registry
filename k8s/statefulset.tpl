apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: zpm-registry
  namespace: iris
spec:
  serviceName: zpm-registry
  replicas: 1
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: zpm-registry
  template:
    metadata:
      labels:
        app: zpm-registry
    spec:
      initContainers:
      - name: zpm-volume-change-owner-hack
        image: busybox
        command: ["sh", "-c", "chown -R 51773:52773 /opt/zpm/REGISTRY-DATA; chmod g+w /opt/zpm/REGISTRY-DATA"]
        volumeMounts:
        - mountPath: /opt/zpm/REGISTRY-DATA
          name: zpm-registry-volume
      containers:
      - image: DOCKER_REPO_NAME:DOCKER_IMAGE_TAG
        name: zpm-registry
        ports:
        - containerPort: 52773
          name: web
        volumeMounts:
        - mountPath: /opt/zpm/REGISTRY-DATA
          name: zpm-registry-volume
  volumeClaimTemplates:
  - metadata:
      name: zpm-registry-volume
      namespace: iris
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10Gi
