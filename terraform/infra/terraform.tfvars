aws_region = "us-east-2"

key_pair = "ohio-keypair"

security_groups = {
  "jenkins_sg" = {
    ingress = [
      { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 9100, to_port = 9100, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ]
  },
  "sonarqube_sg" = {
    ingress = [
      { from_port = 9000, to_port = 9000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 9100, to_port = 9100, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 8200, to_port = 8200, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ]
  },
  "jfrog_sg" = {
    ingress = [
      { from_port = 8081, to_port = 8081, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 8082, to_port = 8082, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 9100, to_port = 9100, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    ]
  }
}

instances = {
  "jenkins_instance" = {
    name = "jenkins-server"
    # environment    = "dev"
    ami            = "ubuntu"
    instance_type  = "t2.large"
    security_group = "jenkins_sg"
    user_data      = "user-data/jenkins-installation.sh"
  },
  "sonarqube_instance" = {
    name = "sonarqube-server"
    # environment    = "stage"
    ami            = "ubuntu"
    instance_type  = "t2.medium"
    security_group = "sonarqube_sg"
    user_data      = "user-data/sonarqube-installation.sh"
  },
  "jfrog_instance" = {
    name = "jfrog-server"
    # environment    = "prod"
    ami            = "ubuntu"
    instance_type  = "t2.medium"
    security_group = "jfrog_sg"
    user_data      = "user-data/jfrog-installation.sh"
  }
}
