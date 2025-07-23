**About the Application**

This project is based on a simple Go application that renders an "About Me" page.

I focused on implementing and integrating various DevOps and CI/CD tools. The goal was to automate the entire software delivery lifecycle — including build, test, deployment, and delivery — to simulate a production-grade DevOps workflow.

How It Looks:



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


** **

**1. Containerizing the Project with a Multi-stage Dockerfile**

 

- First, I wrote a multi-stage Dockerfile.

- Stage 1: Used to build the image and download dependencies.

- Stage 2: Used a distroless image as the base image for better security and reduced image size.

- Copied the compiled binary from Stage 1 to Stage 2, exposed the required port, and ran the application.

 

Issue 1 – Docker Setup

- Initially thought of using an AWS EC2 VM, but it required a minimum of t2.medium or larger, which is paid. (later used m5.larg)

- Then installed Docker Desktop, but it was extremely RAM-intensive. Ended up adding 8GB more RAM.

- Modified the .wslconfig file to put a cap on the resources being used by Docker's backend process.

- Eventually installed Docker through WSL (Ubuntu) for better control and efficiency.

 

Built the image using:

sudo docker build -t adityarrudola/go-web-app .

 

Issue 2 - Docker Build Issue – Go Version Mismatch

 

- Faced an issue because the base image in Dockerfile was using golang:1.21, while my application uses 1.22.5.

- Fixed it by changing the Go version in the Dockerfile to 1.22.5.

 

Ran the container using:

sudo docker run -p 8080:8080 -it adityarrudola/go-web-app:v1

(Port mapping from container port 8080 to host port 8080)

 

Before step 2, I had to push the image to Docker Hub:

sudo docker login       	( to create a repo for image )

sudo docker push adityarrudola/go-web-app:v1                     	(push the image to the registry)

 

**2. Kubernetes Setup with EKS Cluster (setting up Kubernetes cluster for deployment of application (EKS-Cluster) and also configure it)**

 

- Created Kubernetes manifests for deployment.yaml, service.yaml, and ingress.yaml under k8s/manifests.

 

To validate the manifests, I set up a Kubernetes cluster on AWS (EKS):

 

- Installed kubectl and eksctl.

- Created the cluster using:

eksctl create cluster --name demo-cluster --region ap-south-1

- Used aws configure to authenticate via AWS CLI.

 

 

POD created



<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image2.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image2.png "image_tooltip")


 

Applied the manifests using:



<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image3.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image3.png "image_tooltip")


kubectl apply -f k8s/manifests/deployment.yaml



<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image4.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image4.png "image_tooltip")


 

kubectl apply -f k8s/manifests/service.yaml



<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image5.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image5.png "image_tooltip")


 \
 kubectl apply -f k8s/manifests/ingress.yaml



<p id="gdcalert6" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image6.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert7">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image6.png "image_tooltip")


 

 

-Now we needed ingress controller to assign the address for the ingress resource

-After this I will used the ip address to map it to the domain name in my ect host

 

Edited the type of service from cluster ip to nodeport



<p id="gdcalert7" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image7.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert8">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image7.png "image_tooltip")


 

 

Issue 3 – Security Group Rules

- The EKS cluster nodes weren’t able to communicate outside because of default security group rules.

- Added a custom TCP inbound rule for port 31228 from 0.0.0.0/0 to fix this.



<p id="gdcalert8" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image8.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert9">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image8.png "image_tooltip")


- EC2 instances with elastic IPs were created along with a private VPC and cloud formation stack.

 

EC2 – instances (m5.large)



<p id="gdcalert9" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image9.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert10">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image9.png "image_tooltip")


 

 

Private VPC



<p id="gdcalert10" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image10.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert11">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image10.png "image_tooltip")


 

A cloud Formation Stack



<p id="gdcalert11" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image11.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert12">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image11.png "image_tooltip")


 

**3. Ingress Controller Setup for Load Balancing**

 

- Created the ingress controller using the official NGINX deployment file:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml

 

- The ingress controller watches ingress resources and creates a network load balancer accordingly.



<p id="gdcalert12" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image12.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert13">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image12.png "image_tooltip")


 

Issue with access:

- Couldn't access the app via Load Balancer DNS due to this line in ingress.yaml:

  - host: go-web-app.local

- The app only accepts requests through go-web-app.local.

 

Fix:

- Took the Load Balancer IP and mapped it to go-web-app.local in /etc/hosts:

52.66.26.202  go-web-app.local

NOW Only accept req if accessed through go-web-app.local

 

 

Network load balancer created by the ingress controller



<p id="gdcalert13" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image13.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert14">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image13.png "image_tooltip")


**4. Helm Chart for the Application**

** **

“Read about helm configuration

It is used to  variablize(dynamically) hardcoded stuff like

Image name --- adityarrudola/go-web-app:v1 to

                            	adityarrudola/go-web-app:dev  or

                            	adityarrudola/go-web-app:prod “

 

- Used Helm to templatize hardcoded values like image names and tags.

 

Ran:

helm create go-web-app-chart



<p id="gdcalert14" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image14.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert15">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image14.png "image_tooltip")


- Removed default charts.

- Edited Chart.yaml to add metadata.

- Inside /templates/, added Kubernetes manifests which refer to values from values.yaml.

 

- This makes image tags and other values configurable based on environments (dev, prod, etc.).

- During CI/CD, the tag ID will be dynamically updated to reflect the latest commit/image version.



<p id="gdcalert15" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image15.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert16">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image15.png "image_tooltip")


Deleted previous Kubernetes resources and created new ones using Helm.



<p id="gdcalert16" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image16.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert17">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image16.png "image_tooltip")


 

New One



<p id="gdcalert17" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image17.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert18">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image17.png "image_tooltip")


**5. CI Setup Using GitHub Actions**

 

- Added a GitHub Actions workflow with multiple stages:

  - Stage 1: Build and run unit tests.

  - Stage 2: Run static code analysis.

  - Stage 3: Build Docker image with the latest commit ID and push it to Docker Hub.

	- Update values.yaml in Helm chart with the new image tag.

  - Stage 4: Push the updated Helm chart back to the repo.

                                                                                    	

- ArgoCD later picks up the updated Helm chart and deploys the app to the Kubernetes cluster.

 

Also:

- Used GitHub Marketplace actions.

- Added a personal access token with read/write permission for the CI pipeline to push changes.



<p id="gdcalert18" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image18.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert19">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image18.png "image_tooltip")


 

 

 

 

 

Github Actions in working after any commit from build, code-quality to push and update



<p id="gdcalert19" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image19.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert20">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image19.png "image_tooltip")


 

CI pipeline working properly. Every commit builds a new Docker image.



<p id="gdcalert20" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image20.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert21">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image20.png "image_tooltip")


** **

** **

** **

** **

**6. CD Setup Using GitOps (ArgoCD)**

 

- Created a new namespace for ArgoCD:

kubectl create namespace argocd

 

- Installed ArgoCD using:

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml



<p id="gdcalert21" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image21.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert22">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image21.png "image_tooltip")


 

kubectl get svc argocd-server -n argocd



<p id="gdcalert22" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image22.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert23">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image22.png "image_tooltip")


 

Issue with patching argocd-server service:

- The inline patch command failed:

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

 

Fix:

- Created a patch.yaml with:

spec:

  type: LoadBalancer

- Applied the patch using:

kubectl patch svc argocd-server -n argocd --patch-file patch.yaml



<p id="gdcalert23" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image23.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert24">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image23.png "image_tooltip")


Then:

- Used the Load Balancer DNS to access ArgoCD UI.

- Username: admin

 

To get the password:

kubectl get secret argocd-initial-admin-secret -n argocd -o yaml

 

Decoded the base64 password using PowerShell:

[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("NEM2bmVoZ1VnWXpLa1lhYQ=="))

 

- Logged in and set ArgoCD sync policy to automatic with self-heal.



<p id="gdcalert24" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image24.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert25">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image24.png "image_tooltip")




<p id="gdcalert25" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image25.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert26">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image25.png "image_tooltip")

