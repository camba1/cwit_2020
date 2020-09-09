# App
start:
	docker-compose up
stop:
	docker-compose down
#K8s
manifests:
	kompose --file ./../docker-compose.yml convert
apply:
	kubectl apply -f ./Kubernetes
delete:
	kubectl delete -f Kubernetes/
# minikube
mkstart:
	minikube start
mkstop:
	minikube stop
mkservices:
	minikube service list
mkdashboard:
	minikube dashboard
