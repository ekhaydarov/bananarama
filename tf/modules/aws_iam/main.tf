data "aws_caller_identity" "current" {}

locals {
  root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  base_policy = {
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = local.root_arn
      },
      Action = "sts:AssumeRole",
    }]
  }

  group_policy = merge(
    local.base_policy,
    {
      Condition = {
        StringEquals = {
          "aws:PrincipalTag/Group" = [ var.group_name ]
        }
      }
    }
  )
}

resource "aws_iam_role" "all_users" {
  name               = "assume_all_users"
  assume_role_policy = jsonencode(local.base_policy)
}

# restrict the role to just the group
resource "aws_iam_role" "group" {
  name               = var.role_name
  assume_role_policy = jsonencode(local.group_policy)
}

resource "aws_iam_policy" "assume_all_users" {
  for_each    = toset([aws_iam_role.group, aws_iam_role.all_users])
  name        = each.value.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = each.value.arn
    }]
  })
}

resource "aws_iam_group" "devs" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "devs" {
  for_each   = toset([aws_iam_policy.assume_all_users, aws_iam_policy.assume_group])
  group      = aws_iam_group.devs.name
  policy_arn = each.value.arn
}

resource "aws_iam_user" "dev" {
  for_each = toset(var.user_names)
  name     = each.value
}

resource "aws_iam_user_group_membership" "dev" {
  for_each = toset(aws_iam_user.dev)
  user     = each.value.name
  groups = [
    aws_iam_group.all_users.name,
    aws_iam_group.group.name
  ]
}