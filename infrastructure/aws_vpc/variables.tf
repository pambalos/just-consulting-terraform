variable "vpc_cidr" {
    description = "The main CIDR range for the VPC."
    type        = string
}

variable "vpc_name" {
    description = "The name of the VPC."
    type        = string
}

variable "subnets" {
    description = "A map of subnet configurations."
    type        = map(object({
        az          = string
        cidr_block  = string
        public      = bool
        description = string
        extra_tags = optional(map(string), {}) # Additional tags for the subnet
    }))
}

variable "vpc_extra_tags" {
    description = "Extra tags to add to the VPC resource."
    type        = map(string)
    default     = {}
}

variable "nat_associations" {
    description = "A map of NAT associations."
    type        = map(string)
}

variable "vpc_peer_acceptances" {
    description = "A list of VPC peering requests to accept. All VPC peers will be routable from all subnets."
    type = map(object({
        allow_dns                 = bool   # Whether the remote VPC can use the DNS in this VPC.
        cidr_block                = string # The CIDR block to route to the remote VPC.
        vpc_peering_connection_id = string # The peering connection ID produced from the VPC peer request.
    }))
    default = {}
}

variable "vpc_flow_logs_expire_after_days" {
    description = "How many days until VPC flow logs expire."
    type        = number
    default     = 30

    validation {
        condition     = var.vpc_flow_logs_expire_after_days >= 7
        error_message = "Flow logs must be kept for at least 7 days"
    }
}

variable "vpc_flow_logs_enabled" {
    description = "Whether to enable VPC flow logs"
    type        = bool
    default     = false
}