variable "environment" {
  description = "The name of the environment the infrastructure is being deployed into. #injected"
  type        = string
  default     = null
}

variable "root_module" {
  description = "The name of the root module in the module tree. #injected"
  type        = string
  default     = "aws_tags"
}

variable "module" {
  description = "The name of the module where the containing resources are directly defined. #injected"
  type        = string
  default     = "aws_tags"
}

variable "region" {
  description = "The region the infrastructure is being deployed into. #injected"
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Extra tags or labels to add to the created resources. #injected"
  type        = map(string)
  default     = {}
}

variable "is_local" {
  description = "Whether this module is a part of a local development deployment #injected"
  type        = bool
  default     = true
}
