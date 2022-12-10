## Soundwav
A full production backend API built with these tech stacks:

- REST API: _Django and Django REST Framework_.
- Database: _PostgresSQL_.
- Unit Testing: _Pytest_.
- Packaging Management: _Poetry_.
- Containerization: _Docker and Docker Compose_.
- Cloud Provider: _GCP (Google Cloud):_
  - _Google Cloud Compute Engine._
  - _Google Cloud Storage._
  - _Google Cloud SQL._
  - _Google Cloud Container Registry._
- Infrastructure as Code: _Terraform_.
- CI/CD: _Jenkins_.
- Version Control: _Git and GitHub_.

---

### Table of Contents
- [Run The Backend](#backend)
- [Setup The Infrastructure](#infrastructure)
- [Deployment](#deployment)
  - [Deploy Manually](#deploy-manually)

### Backend

**Set the environment variables:**
- Copy `backend/.env.sample/` folder and rename it to `backend/.env/`.

**Run the base environment locally:**
- Update the `backend/.env/.env.base` file.
- Run Docker Compose:
  ```shell
  docker compose -f backend/.docker-compose/base.yml up -d --build
  ```
- Run Pytest:
  ```shell
  docker exec -it soundwav_base_django /bin/bash -c "/opt/venv/bin/pytest"
  ```

**Run the production environment locally:**
- Get the environment variables from the infrastructure:
  ```shell
  python scripts/get_infra_output.py --compose=infrastructure/.docker-compose.yml --module=gcp
  ```
- Update the `backend/.env/.env.production` file.
- Run Docker Compose:
  ```shell
  docker compose -f backend/.docker-compose/production.yml up -d --build
  ```

---

### Infrastructure

**Setup Terraform Backend:**
- Create a new project on Google Cloud Platform.
- Create a service account and download the service key JSON file and rename it to `.gcp_creds.json`.
- Create a storage on Google Cloud Storage.
- Create a file and name it to `.backend.hcl` under `infrastructure` folder.
- Copy the content of file `.backend.hcl.sample` inside it and fill the values.

**Setup Secrets:**
- Create a file with the name `.secrets.auto.tfvars` under `infrastructure` folder.
- Copy the contents of file `.secrets.auto.tfvars.sample` inside it and fill the values.

**Setup SSH:**
- Generate an SSH Key.
- Create a folder with the name `.ssh` under `infrastructure` folder.
- Copy `id_rsa.pub` and `id_rsa` file to `infrastructure/.ssh`.

**Run Terraform Commands:**

- terraform init
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform init -backend-config=.backend.hcl
  ```

- 
- terraform plan all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan
  ```
- terraform plan gcp
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform plan -target="module.gcp"
  ```

- 
- terraform apply all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply --auto-approve
  ```
- terraform apply gcp
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform apply -target="module.gcp" --auto-approve
  ```

- 
- terraform destroy all
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy --auto-approve
  ```
- terraform destroy gcp
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform destroy -target="module.gcp" --auto-approve
  ```

-
- terraform output gcp
  ```shell
  docker compose -f infrastructure/.docker-compose.yml run --rm terraform output gcp
  ```
---

### Deployment

#### Deploy Manually
- Create the GCP resources by following the infrastructure section.
- Export values and change them according to your infrastructure:
  ```shell
  
  export KEY_FILE=.gcp_creds.json;
  export KEY_TYPE=_json_key;
  export HOSTNAME=gcr.io;
  
  export PROJECT_ID=soundwav;
  export IMG_NAME=soundwav;
  export IMG_TAG=latest;
  
  export FINAL_IMAGE=$HOSTNAME/$PROJECT_ID/$IMG_NAME:$IMG_TAG;
  
  export ENVIRONMENT=production;
    
  export INSTANCE_USER=<YOUR_INSTANCE_USER>;
  export INSTANCE_IP=<YOUR_INSTANCE_IP>;
  ```


- Login to GCP Container Registry:
  ```shell
  cat $KEY_FILE | docker login -u $KEY_TYPE --password-stdin https://$HOSTNAME
  ```
- Build a Docker image:
  ```shell
  docker build -t $FINAL_IMAGE -f backend/Dockerfile backend --build-arg ENVIRONMENT=$ENVIRONMENT
  ```
- Push the Docker image to GCP Container Registry:
  ```shell
  docker push $FINAL_IMAGE
  ```


- Copy the env file and the run script to the server:
  ```shell
  rsync backend/.gcp_creds.json backend/.env/.env.$ENVIRONMENT scripts/run_backend.py $INSTANCE_USER@$INSTANCE_IP:/home/$INSTANCE_USER
  ```

- Login to GCP Container Registry on the server:
  ```shell
  ssh $INSTANCE_USER@$INSTANCE_IP "cat $KEY_FILE | docker login -u $KEY_TYPE --password-stdin https://$HOSTNAME"
  ```
- Run the script on the server:
  ```shell
  ssh $INSTANCE_USER@$INSTANCE_IP "python3 run_backend.py --env=.env.$ENVIRONMENT --image=$FINAL_IMAGE"
  ```

---
