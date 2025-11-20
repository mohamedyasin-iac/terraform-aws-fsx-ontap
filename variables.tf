### JNJ Environment Specific Variable ###
variable "iacCompositeModuleName" {
  description = "Specifies the parent composite module that calls this module. The value is propagated into resource tags for module-level traceability."
  type        = string
  default     = null
}

variable "enable_helper" {
  description = "Enable helper module"
  type        = bool
  default     = true
}
variable "VPCx_environment" {
  type    = string
  default = "PROD"
}
variable "security_group_filter_fms" {
  description = "Allows you to query security groups based on 'fms-policy-name' tags. Use this filter for xbot2 created security groups like 'DefaultSecurityGroupsCommonsPolicy', 'CloudFlareSecurityGroupsCommonsPolicy', 'SMTPSecurityGroupsCommonsPolicy', 'DatabaseSecurityGroupsCommonsPolicy'"
  default     = ["DefaultSecurityGroupsCommonsPolicy"]
  type        = list(string)
}

variable "security_group_filter" {
  description = "Allows you to query security groups based on 'Security group names'. Use this filter for user and/or xbot1 created security groups"
  type        = list(string)
  default     = [""]
}

variable "subnet_filter" {
  description = "Allows you to query the desired subnet"
  type        = list(string)
  default     = ["Primary VPC 1 - Primary1 Subnet 1", "Primary VPC 1 - Primary1 Subnet 2"]
}

variable "vpc_filter" {
  description = "Allows you to query the desired VPC"
  type        = string
  default     = "Primary VPC 1*"
}

variable "user" {
  description = "AD account ID of the user"
  type        = string
  default     = ""
}

variable "application" {
  description = "APP ID as shown in IRIS"
  type        = string
  default     = ""
}

# tflint-ignore: terraform_unused_declarations
variable "is_ts_managed" {
  description = "Whether or not the account is full-service."
  type        = bool
  default     = false
}

variable "region" {
  description = "The AWS region to create resources in. If not provided, the provider region is used."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
#### FSx Specific Variable ###
variable "storage_capacity" {
  description = "The storage capacity of the file system (in GB)."
  type        = number
  default     = null
}

variable "deployment_type" {
  description = "The deployment type of the file system. Valid values: MULTI_AZ_1, SINGLE_AZ_1, SINGLE_AZ_2"
  type        = string
  default     = ""
}

variable "throughput_capacity" {
  description = "The throughput capacity of the file system (in MBps)."
  type        = number
  default     = null
}

variable "standby_subnet_id" {
  description = "Standby subnet ID for FSx (required only for MULTI_AZ_1)"
  type        = string
  default     = ""
}

variable "preferred_subnet_id" {
  description = "Preferred subnet ID for FSx ONTAP"
  type        = string
  default     = ""
}

variable "security_group_id_fms" {
  type        = list(string)
  description = "User-provided SG IDs from FMS"
  default     = []
}

variable "svm_name" {
  description = "Preferred subnet ID for FSx ONTAP"
  type        = string
  default     = ""
}

variable "route_table_ids" {
  description = "Optional route table IDs for FSx endpoints (only for MULTI_AZ_1)."
  type        = list(string)
  default     = []
}

variable "endpoint_ip_address_range" {
  description = "Optional CIDR for FSx endpoints (only for MULTI_AZ_1)."
  type        = string
  default     = null
}

variable "weekly_maintenance_start_time" {
  description = "weekly maintenance start time in the format d:HH:MM (d = day of week, 1-7; HH = hour of day, 00-23; MM = minute of hour, 00-59)."
  type        = string
  default     = ""
}