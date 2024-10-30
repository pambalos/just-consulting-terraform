variable "db_name" {
    description = "The name of the database"
    type        = string
}

variable "db_region" {
    description = "The region in which the database will be created"
    type        = string
}

variable "neon_project_name" {
    description = "The name of the Neon project"
    type        = string
}

variable "neon_role_name" {
    description = "The name of the Neon role"
    type        = string
}