1) Create a 2 GitHub Repositories with the names `Pcommerce-Infrastructure-Code-Repo` and `Pcommerce-Application-Code-Repo` and and push the respective codes from the two downloaded project source codes to your two remote repositoriesyou just created.
    - Go to GitHub: <https://github.com>
    - Login to `Your GitHub Account`
    - Create a Repository called `Pcommerce-Infrastructure-Code-Repo`
    - Create a Repository called `Pcommerce-Application-Code-Repo`
    - Clone the two Repositories into the `Repository` directory/folder on your `local machine`
    - Download the two project source codes in these repositories `"Main branches"`: https://github.com/georgea233/DevOps_MasterPiece-CD-with-ArgoCD.git and https://github.com/georgea233/DevOps_MasterPiece-CD-with-ArgoCD.git
    - `Unzip` the `code/zipped file`
    - `Copy` and `Paste` everything `from the zipped files` into their respective `repositories you cloned` to your local machine
    - Open your `Terminal`
        - Add the codes to git, commit and push them to the upstream branch "main" of the two repositories you created above. 
        - Add the changes: `git add -A`
        - Commit changes: `git commit -m "added project source code"`
        - Push to GitHub: `git push`
    - Confirm that the two source codes are now available on GitHub

2) Create An IAM Profile/Role For The Jenkins Environment

- Create an EC2 Service Role in IAM with `AdministratorAccess` Privilege
- Navigate to IAM
![IAM!](https://github.com/awanmbandi/realworld-cicd-pipeline-project/blob/zdocs/images/Screen%20Shot%202023-10-03%20at%206.20.44%20PM.png)
  - Click on `Roles`
  - Click on `Create Role`
  - Select `Service Role`
  - Use Case: Select `EC2`
  - Click on `Next`
  - Attach Policy: `AdministratorAccess`
  - Click `Next`
  - Role Name: `AWS-AdministratorAccess-Role`
  - Click `Create`

3) Jenkins
    - Create an `Ubuntu 22.04` Jenkins VM instance
    - Name: `Jenkins/Prometheus/Grafana/Trivy`
    - Instance type: `t2.large`
    - Key pair: `Select` or `create a new keypair`
    - Security Group (Edit/Open): `8080`, `9090`, `3000`, `9100` and `22` to `0.0.0.0/0`
    - IAM instance profile: Select the `AWS-AdministratorAccess-Role`
    - User data (Copy the following user data): <https://github.com/awanmbandi/realworld-cicd-pipeline-project/blob/terraform-jenkins-cicd-pipeline-project/installations/jenkins-install.sh>
    - Launch Instance
    - Add the public key (id_rsa.pub) to the Jenkins server: Copy the contents of the public key (`id_rsa.pub`) and add it to the `~/.ssh/authorized_keys` file on the `Jenkins server`.
    - Public key for Jenkins Server to be used later: `SHA256:K62j2LhfdzBg2S0r85mavz5+AuJ2lk5F1V/yiHP/zAI`. You can use ssh to do this: `ssh ubuntu@<jenkins-server-ip> nano ~/.ssh/authorized_keys` or can test this too: `ssh -i ~/.ssh/id_rsa.pub <Jenkins-Server-IP>`. Private key already added as secret in GitHub Actions Secrets under the repo `Pcommerce-Infrastructure-Code-Repo`

4) SonarQube/Hashicorp Vault
    - Create a SonarQube/Hashicorp Vault `Ubuntu 22.04` VM instance
    - Name: `SonarQube/Hashicorp-Vault`
    - Instance type: `t2.medium`
    - Key pair: `Select` or `create a new keypair`
    - Firewall Rules (Open): `9000`, `9100`, `8200` and `22` to `0.0.0.0/0`
    - User Script (Copy the following user data): <https://github.com/awanmbandi/realworld-cicd-pipeline-project/blob/maven-nexus-sonarqube-jenkins-install/sonarqube-install.sh>
    - Launch Instance

5) JFrog Artifactory
    - Create a JFrog `Ubuntu 22.04` VM instance
    - Name: `JFrog-Artifactory`
    - Instance type: `t2.medium`
    - Key pair: `Select` or `create a new keypair`
    - Firewall Rules (Open): `8081`, `8082`, `9100` and `22` to `0.0.0.0/0`
    - User Script (Copy the following user data): <https://github.com/awanmbandi/realworld-cicd-pipeline-project/blob/maven-nexus-sonarqube-jenkins-install/artifactory-install.sh>
    - Launch Instance

6) Slack
    - Go to the below Workspace and create a Private Slack Channel and name it "yourfirstname-pcommerce-cicd-pipeline-alerts"
    - Link: <https://join.slack.com/t/jjtechtowerba-zuj7343/shared_invite/zt-24mgawshy-EhixQsRyVuCo8UD~AbhQYQ>  
      - You can either join through the browser or your local Slack App
      - Create a `Private Channel` using the naming convention `YOUR_INITIAL-pcommerce-cicd-alerts`
        - **NOTE:** *`(The Channel Name Must Be Unique, meaning it must be available for use by you)`*
      - Visibility: Select `Private`
      - Click on the `Channel Drop Down` and select `Integrations` and Click on `Add an App`
      - Search for `Jenkins` and Click on `View`
      - Click on `Configuration/Install` and Click `Add to Slack`
      - On Post to Channel: Click the Drop Down and select your channel above `YOUR_INITIAL-terraform-cicd-alerts`
      - Click `Add Jenkins CI Integration`
      - Scrol Down and Click `SAVE SETTINGS/CONFIGURATIONS`
      - Leave this page open
      ![SlackConfig!](https://github.com/awanmbandi/realworld-cicd-pipeline-project/raw/zdocs/images/Screen%20Shot%202023-04-26%20at%202.08.55%20PM.png)

7)    - Instead of manually provision the above infrastructure via the
aws console, if you wish to use terraform and employ gitops practice, which means that your single source of truth is your git repository, you can follow this [link](https://github.com/awanmbandi/realworld-cicd-pipeline-project/blob/zdocs/images/Screen%20Shot%202023-04-26%20at%202.08.55%20PM.png)


8)    - SSH into the `Jenkins/Prometheus/Grafana/Trivy` server
        - Run the following commands and confirm that the `services` are all `Running`

```bash
# `Jenkins/Prometheus/Grafana/Trivy` server:

# Confirm Java version
sudo java --version

# Confirm that Jenkins is running
sudo systemctl status jenkins

# Confirm that docker is running
sudo systemctl status docker

# Confirm that Terraform is running
terraform version

# Confirm that the Kubectl utility is running 
kubectl version --client

# Confirm that AWS CLI is running
aws --version

# Confirm that Trivy is running
sudo systemctl status trivy

# Confirm that Prometheus is running
sudo systemctl status prometheus

# Confirm that Grafana is running
sudo systemctl status grafana

# Confirm that Git is running
git --version

# Confirm that Github CLI is running
github version

# Confirm that Terraform is running
terraform version

# Confirm that Helm is running
helm version

# Confirm that EKSCTL is running
eksctl version 

`SonarQube/Hashicorp Vault server:

# Confirm that SonarQube is running
sudo systemctl status sonarqube

# Confirm that hashicorp vault is running
vault status

`JFrog Artifactory server:

# Confirm that JFrog Artifactory is running   
sudo systemctl status artifactory

```

5) Install Plugins

- Snyk
- Slack
- Blue Ocean
- Pipeline: Stage View
