# DevOps Workflow Summary

📄 **[For in-depth documentation, click here](https://docs.google.com/document/d/1CqzU0VBSlS-HcKdihpGtKfG93lVYbNgDwyp02UIZk_s/edit?usp=sharing)**

---

# ✅ DevOps Setup
<img width="667" height="1324" alt="image" src="https://github.com/user-attachments/assets/ff0891d6-b8db-4445-bb46-809b30791caa" />

# 🔁 CI Pipeline (GitHub Actions)
<img width="720" height="1305" alt="image" src="https://github.com/user-attachments/assets/6bcd01d0-f4b5-415f-a2ea-71ca9a55df00" />

# 🚀 CD Pipeline (ArgoCD)
<img width="891" height="1094" alt="image" src="https://github.com/user-attachments/assets/93981a90-0f8b-432f-871b-c86d30d137b6" />

---

## 🧰 Tools Used

- **Go (Golang)** – Application language
- **Docker** – Containerization
- **Docker Hub** – Image registry
- **Kubernetes (EKS)** – Container orchestration
- **kubectl & eksctl** – Cluster management
- **Helm** – Kubernetes package manager (templating)
- **GitHub & Git** – Source control
- **GitHub Actions** – Continuous Integration (CI)
- **ArgoCD** – GitOps-based Continuous Delivery (CD)
- **AWS EC2, VPC, Load Balancer, CloudFormation** – Cloud infrastructure

---

## 🔁 DevOps Workflow

### 1. **Application Development**
- A simple Go application that renders an "About Me" page.

### 2. **Containerization**
- Multi-stage `Dockerfile` used.
- Final image uses distroless base.
- Tagged and pushed to Docker Hub.

### 3. **Kubernetes Setup (EKS)**
- Created a cluster with `eksctl`.
- Wrote Kubernetes manifests:
  - `deployment.yaml`
  - `service.yaml`
  - `ingress.yaml`
- Applied manifests via `kubectl`.

### 4. **Ingress Controller**
- Deployed NGINX ingress controller.
- Configured ingress resource for load balancing.
- Used LoadBalancer IP mapped to domain via `/etc/hosts`.

### 5. **Helm Chart for the App**
- Used `helm create` to scaffold chart.
- Replaced hardcoded values with templated variables in:
  - `values.yaml`
  - `deployment.yaml`, etc.
- Supports multiple environments (e.g., dev, prod).

### 6. **Continuous Integration (GitHub Actions)**
- CI Workflow stages:
  - Run unit tests
  - Static code analysis
  - Build and tag Docker image (with commit ID)
  - Push image to Docker Hub
  - Update Helm `values.yaml` with new tag
  - Commit updated chart back to GitHub

### 7. **Continuous Delivery (ArgoCD)**
- Installed ArgoCD in its own namespace.
- Configured to monitor Helm chart repo.
- Syncs and deploys the latest image on change.
- Enabled auto-sync with self-healing.

---

✅ This end-to-end workflow automates development, testing, deployment, and delivery using modern DevOps tools and GitOps principles.
