locals {
  # ----------------------------------------
  # Module & random suffix
  # ----------------------------------------
  module = basename(abspath(path.module))     # Current module name
  random = "jnj${random_integer.rand_int.id}" # Random suffix for unique resource naming

  # ----------------------------------------
  # FSx metadata
  # ----------------------------------------
  fsx_file_system_arn         = module.fsx_ontap.file_system_arn                                                                  # ARN of FSx filesystem
  fsx_file_system_id          = element(split("/", local.fsx_file_system_arn), length(split("/", local.fsx_file_system_arn)) - 1) # Extract FSx filesystem ID from ARN
  fsx_name_tag                = "fsxid${replace(local.fsx_file_system_id, "fs-", "")}"                                            # Name tag format fsxidXXXXXX
  effective_route_table_ids   = []                                                                                                # Route table IDs
  effective_endpoint_ip_range = null                                                                                              # Endpoint IP range
}
