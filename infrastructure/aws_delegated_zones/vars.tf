variable "root_domain_names" {
  description = "Root domain names that need to be delegated."
  type        = set(string)
}

variable "zones" {
    description = "The root domain names that need to be delegated."
    type        = map(map(string))
}

variable "subdomain_identifiers" {
  description = "The subdomain path segments"
  type        = set(string)
}



