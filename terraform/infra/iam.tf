resource "aws_iam_role" "ec2_admin_eks_role" {
  name = "ec2-admin-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary EKS policies
resource "aws_iam_policy_attachment" "eks_policies" {
  count = 2
  name  = "ec2-eks-access-attachment-${count.index}"
  roles = [aws_iam_role.ec2_admin_eks_role.name]
  policy_arn = element(
    [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    ],
    count.index
  )
}

# Create the IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_admin_eks_profile" {
  name = "ec2_admin_eks_profile"
  role = aws_iam_role.ec2_admin_eks_role.name
}



# resource "aws_iam_role" "ec2_admin_eks_role" {
#   name = "ec2-admin-eks-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach the AdministratorAccess policy
# resource "aws_iam_policy_attachment" "admin_access" {
#   name       = "ec2-admin-access-attachment"
#   roles      = [aws_iam_role.ec2_admin_eks_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# # Attach the individual EKS policies
# resource "aws_iam_policy_attachment" "eks_cluster_policy" {
#   name       = "ec2-eks-cluster-access-attachment"
#   roles      = [aws_iam_role.ec2_admin_eks_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_policy_attachment" "eks_cni_policy" {
#   name       = "ec2-eks-cni-access-attachment"
#   roles      = [aws_iam_role.ec2_admin_eks_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_policy_attachment" "eks_service_policy" {
#   name       = "ec2-eks-service-access-attachment"
#   roles      = [aws_iam_role.ec2_admin_eks_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
# }

# # Create the IAM Instance Profile for EC2
# resource "aws_iam_instance_profile" "ec2_admin_eks_profile" {
#   name = "ec2_admin_eks_profile"
#   role = aws_iam_role.ec2_admin_eks_role.name
# }


# resource "aws_iam_role" "ec2_role" {
#   name = "EC2FullReadOnlyAndIAMManagementRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = "sts:AssumeRole"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "ec2_full_and_iam_management_policy" {
#   name        = "EC2FullAndIAMManagementPolicy"
#   description = "Policy to allow EC2 full access, read-only access, and IAM management"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = [
#           "ec2:Describe*",
#           "ec2:List*",
#           "ec2:StartInstances",
#           "ec2:StopInstances",
#           "ec2:TerminateInstances",
#           "ec2:RunInstances",
#           "ec2:CreateTags",
#           "ec2:DeleteTags",
#           "ec2:ModifyInstanceAttribute"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect   = "Allow"
#         Action   = [
#           "iam:CreateRole",
#           "iam:AttachRolePolicy",
#           "iam:PutRolePolicy",
#           "iam:PassRole",
#           "iam:CreateInstanceProfile",
#           "iam:AddRoleToInstanceProfile",
#           "iam:CreatePolicy",
#           "iam:DeleteRole",
#           "iam:DetachRolePolicy",
#           "iam:RemoveRoleFromInstanceProfile",
#           "iam:DeleteInstanceProfile"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.ec2_full_and_iam_management_policy.arn
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "EC2InstanceProfileWithIAMAccess1"
#   role = aws_iam_role.ec2_role.name
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "EC2InstanceProfileWithIAMAccess-${timestamp()}"
#   role = aws_iam_role.ec2_role.name
# }






# resource "aws_iam_role" "ec2_role" {
#   name = "EC2FullReadOnlyAndIAMManagementRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ec2_full_access_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "ec2_read_only_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
# }

# resource "aws_iam_role_policy_attachment" "iam_management_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "ec2_instance_profile"
#   role = aws_iam_role.ec2_role.name
# }






# resource "aws_iam_role" "ec2_role" {
#   name = "EC2FullAndReadOnlyAccessRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ec2_full_access_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "ec2_read_only_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "ec2_instance_profile"
#   role = aws_iam_role.ec2_role.name
# }

