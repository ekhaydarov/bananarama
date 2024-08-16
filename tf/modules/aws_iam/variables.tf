variable "role_name" {
  description = "The name of the IAM role to create"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy to create"
  type        = string
}

variable "group_name" {
  description = "The name of the IAM group to create"
  type        = string
}

variable "user_names" {
  description = "The names of the IAM users to create. default empty list to be able to create group with policy attached"
  type        = list(string)
  default     = []
}