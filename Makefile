# App
start:
	docker-compose up
stop:
	docker-compose down
#DockerHub
pushtohub:
	docker-compose build nodewithdb
	docker tag cwit_2020_nodewithdb bolbeck/nodewithdb
	docker push bolbeck/nodewithdb

# minikube
mkstart:
	minikube start
mkstop:
	minikube stop
mkservices:
	minikube service list
mkservice:
	minikube service nodewithdb
mkdashboard:
	minikube dashboard

#K8s
#Reference : https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#wait
k8version:
	kubectl version --short
k8runpod:
	kubectl run mariadb --image=mariadb --port=3306  --dry-run=client -o yaml
k8createDeploy:
	kubectl create deployment --image=mariadb mariadb --dry-run=client -o yaml
k8get:
	kubectl get ${RESOURCENAME}
k8createService:
	kubectl create service nodeport redis --tcp=6379:6379 --dry-run=client -o yaml
k8manifests:
	kompose --file ./../docker-compose.yml convert
k8apply:
	kubectl apply -f ./Kubernetes
k8delete:
	kubectl delete -f Kubernetes/
k8logs:
	kubectl logs ${PODNAME} $(CONTAINERNAME)
K8describe:
	kubectl describe pod/${PODNAME}
k8restartdeployment:
	kubectl rollout restart deployment ${DEPLOYMENTNAME}
k8rolloutHistory:
	kubectl rollout history deployment ${DEPLOYMENTNAME}
k8rolloutHistoryDetail:
	kubectl rollout history deployment ${DEPLOYMENTNAME} --revision=${RevisionNumber}
K8undorollout:
	kubectl rollout undo deployment ${DEPLOYMENTNAME} --to-revision=${RevisionNumber}
k8diff:
	kubectl diff -f ${FILENAME}
K8secret:
	kubectl get secret nodewithdb-secret -o yaml

# Kustommize
# Refernce: https://kubectl.docs.kubernetes.io/pages/reference/kustomize.html#bases
# 					https://kubectl.docs.kubernetes.io/pages/app_customization/introduction.html
kusBuild:
	kubectl kustomize KubernetesKustomize/${KUSTOMIZEDIR}
kusApply:
	kubectl apply -k KubernetesKustomize/${KUSTOMIZEDIR}
