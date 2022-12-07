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

---
