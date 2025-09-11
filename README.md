# release-orchestration-pipeline
Designing and Implementing a single pipeline to automate the releases from three apps. 

## Designing and the workflow 
There are two approaches i followed in my design: the monorepo and polyrepo. 

both are valid depending on the company’s setup. I documented both Monorepo and polyrepo(Release Orchestration).

**Personally**, I prefer Monorepo Since the company is a strong startup in the fintech domain and faster iteration because it simplifies dependency management and CI/CD.

### Deployment Designs
#### Polyrepo flow
![poly](./assets/polorepo.svg)
#### monorepo flow
![mono](./assets/monorepo.svg)
### Release Orchestration (Polyrepo)

Each Application (Backend, Frontend 1, Frontend 2) lives in its own repository.

A central pipeline orchestrates deployments across these repositories.

Full and Partial deployments are handled by triggering only the affected service’s pipeline.

Useful when one leader know the whole application and control the central pipeline and teams are independent and own separate repos.

### Monorepo

All services (Backend, Frontend 1, Frontend 2) are stored in a single repository in folders.

It's optional that shared pipeline handles builds, tests, and deployments.

Partial deployments are handled by detecting changes in the specific service folder and select it's parameter (e.g., only deploying backend/ if it's code changes).

Useful for simplifying dependency management and ensuring consistency across apps.

## Tech stack and Tools used
- **Applications:**
  - **Frontend-1:** Angular(Web) 
  - **Frontend-2:** Angular(Admin)
  - **Backend:** .Net (API)

- **CI/CD:** Github Actions -> Supports flexible workflows for parameterized release orchestration and native integration with GitHub 

- **Artifact Repository:** Nexus -> Registry to store build artifacts (e.g. zips, tar files, packages) with versioning and rollbacks.

- **Deployment Method:** Bash Scripts + EC2 -> Lightweight, simple, cost-effective and straightforward.

## Automation with Github Actions workflow 
- All GitHub Actions workflows are stored in the default location:
```
 .github/workflows/release-orchestration.yml
 .github/workflows/monorepo.yml
```

- If the repos are all in one org or monorepo and your account has access -> *one token is enough*. If the repos are in different companies/orgs: Your account might not have access to all of them, which each org might require its own token (because of different permissions / policies).

- Go to GitHub repository on the web and to the settings tab of the project and inject the required secrets for the workflow.

- Click the Actions tab.

- In the left sidebar, select the workflow name (e.g., release-orchestration).

- On the right, click the “Run workflow” button (green dropdown).

- Add inputs (e.g., release_version), select them.

- Click Run workflow.
### GitHub CLI
- Install GitHub CLI if not installed
```bash
 gh auth login # Authentication
 gh workflow list
 gh workflow run deploy.yml 
   -f release_version=release/v1.0.0 # Add the other inputs
 gh run list # Check the run status

```
> [!NOTE]
> According to GitHub’s docs, the ubuntu-latest (currently Ubuntu 22.04) runner comes with a lot of pre-installed software, including: .NET SDKs (dotnet), Node.js + npm

- If we need specific versions, we can use actions/setup-dotnet and actions/setup-node with the version required.
### Branching and versioning are handled by the CI/CD workflow:

When the workflow is triggered, it prompts for a release version (e.g., release/v1.0.0).
For each selected application (Backend, Frontend1, Frontend2), a new branch is created from dev with the name: *release/version*

**Example:** if the release version is release/v1.0.0, the branch name will be release/v1.0.0.

**Note:** If the workflow is triggered for a single application (e.g., Backend only), the release version release/v1.1.0 applies only to that app. A release/v1.1.0 branch will be created in the selected repo, and if we want to named the release version as backend-release/v1.1.0 we can do this. Other applications remain on their existing versions until included in a later release run.

## Artifacts
Since the apps are .NET (backend) and Angular/Node.js (frontend1 & frontend2), the artifacts are packaged differently but follow the same naming convention.

Each artifact is named using the pattern:
```bash
<application>-<version>.<extension>

```
#### Examples:

**Backend (.NET API):** backend-release/v1.0.0.zip

**Frontend1 (Angular Web):** frontend1-release/v1.0.0.tar.gz

**Frontend2 (Angular Admin):** frontend2-release/v1.0.0.tar.gz

### Storage in Nexus
Artifacts are uploaded to Nexus under their application and version path:
```bash
<NEXUS_URL>/repository/<NEXUS_REPO>/<application>/<version>/<artifact>

```
**Example:** .../backend/release/v1.0.0/backend-v1.0.0.zip

## Full and Partial Deployments
Deployments are controlled through workflow inputs.

- If full_deploy=true, all apps (backend, frontend1, frontend2) are built and deployed.

- If full_deploy=false, you can selectively deploy apps by toggling the boolean flags (backend, frontend1, frontend2).

Each selected app runs in its own parallel job, so only the chosen apps are processed.

The target environment **(dev, staging, prod)** is also provided as an input, and the selected apps are deployed to that environment only.

### Important

- This project demonstrates a sample use case of release orchestration and deployment to EC2 instances using GitHub Actions.
- In real-world production environments, deployments would typically be handled differently for reliability, scalability, and zero downtime. Clear mapping to environments (dev, staging, prod) using dedicated EC2 instances or kubernetes.

