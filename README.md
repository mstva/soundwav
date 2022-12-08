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

---

### Backend:

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

### Infrastructure:

**Setup Terraform Backend:**
- Create a new project on Google Cloud Platform.
- Create a service account and download the service key JSON file and rename it to `.gcp_creds.json`.
- Create a storage on Google Cloud Storage.
- Create a file and name it to `.backend.hcl` under `infrastructure` folder.
- Copy the content of file `.backend.hcl.sample` inside it and fill the values.

**Setup Secrets:**
- Create a file with the name `.secrets.auto.tfvars` under `infrastructure` folder.
- Copy the contents of file `.secrets.auto.tfvars.sample` inside it and fill the values.

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

---
