# Introduction to K8s
## CWIT Conference 2020

Simple Nodejs application connecting to MariaDB and packaged with Docker for deployment in Kubernetes . This application is part of the 'Introduction to K8s' presentation at the Central Wisconsin IT Conference 2020.

### About this project
This project was initially created for a demo. If you see something that could be improved either in the code or this document please feel free to open a pull request.

All my code in this repo is under MIT license, so feel free to use as needed. For external libraries and images used in this repo, please refer to their own licensing terms.

### Pre-requisites
In order to run the project in its entirety, you will need to have :

- A git account (I used [Bitbucket](http://bitbucket.org))
- A docker repository (I used [Docker hub](hub.docker.com))
- [Docker](docker.com) installed in your machine ( I used Docker Desktop on my Mac)
- [Minikube](https://minikube.sigs.k8s.io) installed in your machine

Also, this document refers to the image in docker hub as _bolbeck/cwit2020_. You should change this to your own image name so that it can run under your own docker hub account (otherwise you will not be able to push the image out).

### The Application

The app has two parts:

- **MariaDB database**: based on the official MariaDB image. The DB is initialized to have a test DB and a Test table with some sample dummy data. The initialization is used with the script in the ./MariaDB/init directory. This is run only once and only if the data volume (./MariaDB/Data) is empty


- **Nodejs**: app which is built from the ```Dockerfile``` in the nodeApp directory. The app has two entry points:
    - **Root** ("/") just pulls writes hello world and the hostname
    - **/mariadb** pull data from the test DB in MariaDB and posts the JSON on the browser

Note that the application sends back pre-rendered page back to the client and uses _pug_ as the rendering engine.

#### Bringing the application up

##### Using the Dockerfile

To bring up just the nodejs app:

- Go to the ./nodeApp directory
- Build the app: ``` docker build -t nodewithmariadb_nodewithdb . ```
- Run the container: ``` docker run -p 3000:3000 --env-file ./docker-node.env --name nodewithdbcont nodewithmariadb_nodewithdb ```
- Open ``` localhost:3000 ``` in your browser

Note that this will bring up only the nodejs application and not the DB, so the app will fail if you try to access the second page (```localhost:3000/mariadb```)

##### Using docker-compose

###### Creating the node_modules folder

If this is the **first time** you will try to bring up the application, you will need to create the ```node_modules``` folder since that is not checked into source control.

If you have npm installed in your machine:

``` bash
cd ./nodeApp
npm install
```

If you do not have npm installed in your machine, from the root folder of our repo (where we have the docker-compose file):

``` bash
docker-compose run --rm  nodewithdb bash
npm install
exit
```
The above commands will:

- Start the nodemaria service defined in our docker-compose file and log you  into the console in the container
- In the container, run npm install, which creates the node_modules folder in the container. Since we have a volume mounted in our container to the nodeApp folder in our machine (as defined in our docker-compose file), the node_modules folder gets created in our host machine as well and is ready for use.
- Exit the container and return to our host machine

###### Bring the application up

Use ```docker-compose up``` in the same directory where you have the docker-compose file to bring the application up . It uses a ```docker-compose.env``` file to pass the environment variables to the mariadb service (better than keeping them in the docker-compose.yaml file).


#### Running the Tests

- With the application running, login to the container with:

  `docker exec -it nodewithdbcont 'bash'`

- Run `npm test`
- To exit the container just use `exit`.

The application test scripts were created using _mocha_ and _chai_.

#### Restarting the nodejs container during development

During development, you may want to restart the nodejs container. You can do this with: ```docker restart nodewithdbcont```

Alternatively you can install something like nodemon in your image to monitor for changes in the file system.

#### Bring application down

Use ```docker-compose down``` in the same directory where you have the docker-compose file to bring the application down.

### Tag and push image manually

To push this the node image to docker hub, we will first need to tag it properly, based in the docker hub account id. we can also give it a proper tag so that we can keep a history.

- login to docker hub, tag image and push to docker hub:

```bash
docker login --username <dockerUserId>
docker tag nodewithmariadb_nodemaria <dockerUserId>/simplenodemaria
docker push <dockerUserId>/simplenodemaria:latest
```

**Note** that you will need to change the name of the image to match your own docker hub account

#### Pushing to Minikube

##### K8s Manifests

The K8s manifests can be found in the `./Kubernetes` folder. they were created using Kompose and then tweaked to match the needs of the demo.

Kompose out of the box may not create exactly what you need, but gets you 80% - 90% there. The final modified files are in the Kubernetes folder already, but you could recreate the original output from Kompose using:

``` bash
mkdir KubernetesOrig
cd KubernetesOrig
kompose --file docker-compose.yml convert
```

##### Push to Minikube

For individual manifests execute

```kubectl apply -f <path/filename.yaml>```

For all the manifests at once:

```kubectl apply -f <Foldername>```

Similarly to delete resources created by the manifests:

```kubectl delete -f <path/filename.yaml>```
or
```kubectl delete -f <Foldername>```

To see how the resources spin or down, use the dashboard
```minikube dashboard```

To find the url where the application is running:
```minikube service list```
