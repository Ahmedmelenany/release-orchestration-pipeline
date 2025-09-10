# release-orchestration-pipeline
Designing and Implementing a single pipeline to automate the releases from three apps. 

## Tech stack and Tools used
- **Applications:**
  - **Frontend-1:** Angular(Web) 
  - **Frontend-2:** Angular(Admin)
  - **Backend:** .Net (API)

- **CI/CD:** Github Actions -> Supports flexible workflows for parameterized release orchestration and native integration with GitHub 

- **Artifact Repository:** Nexus -> Registry to store build artifacts (e.g. zips, tar files, packages) with versioning and rollbacks.

- **Deployment Method:** Bash Scripts + EC2 -> Lightweight, simple, cost-effective and straightforward.

