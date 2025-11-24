resource "random_integer" "rand_int" {
  min = 10 # Minimum value for suffix
  max = 99 # Maximum value for suffix
}

# Random password generator for FSx ONTAP admin user
resource "random_password" "fsx_ontap" {
  length           = 32
  special          = true
  min_special      = 1
  min_numeric      = 1
  min_upper        = 2
  min_lower        = 2
  override_special = "!#%_-"
}

module "fsx_ontap" {
  source  = "terraform-aws-modules/fsx/aws//modules/ontap"
  version = "1.3.0" # Always pin a module version

  # File system configuration
  storage_capacity              = 1024                             # FSx size (GiB)
  subnet_ids                    = ["subnet-b06bb2d5"]              # Resolved from helper or manual input
  preferred_subnet_id           = "subnet-b06bb2d5"                # Preferred subnet (override or first available)
  security_group_ids            = ["sg-7e9b841b"]                  # SGs from helper or manual input
  deployment_type               = "SINGLE_AZ_1"                    # SINGLE_AZ_1 | SINGLE_AZ_2 | MULTI_AZ_1
  throughput_capacity           = 1024                             # Throughput (MB/s)
  fsx_admin_password            = random_password.fsx_ontap.result # Generated ONTAP admin password
  weekly_maintenance_start_time = "1:05:00"                        # Weekly maintenance time (Mon:HH:MM)

  # Security group created by module
  create_security_group      = true
  security_group_name        = "fsxontap-security-group"
  security_group_description = "FSx ONTAP security group"

  # Security group ingress rules
  security_group_ingress_rules = {
    ssh             = { ip_protocol = "tcp", from_port = 22, to_port = 22, cidr_ipv4 = "10.0.0.0/8", description = "SSH (mgmt LIFs)" }
    https           = { ip_protocol = "tcp", from_port = 443, to_port = 443, cidr_ipv4 = "10.0.0.0/8", description = "ONTAP REST / HTTPS" }
    nfs_server_tcp  = { ip_protocol = "tcp", from_port = 2049, to_port = 2049, cidr_ipv4 = "10.0.0.0/8", description = "NFS server" }
    nfs_server_udp  = { ip_protocol = "udp", from_port = 2049, to_port = 2049, cidr_ipv4 = "10.0.0.0/8", description = "NFS server" }
    smb             = { ip_protocol = "tcp", from_port = 445, to_port = 445, cidr_ipv4 = "10.0.0.0/8", description = "SMB/CIFS over TCP" }
    iscsi           = { ip_protocol = "tcp", from_port = 3260, to_port = 3260, cidr_ipv4 = "10.0.0.0/8", description = "iSCSI" }
    snapmirror_mgmt = { ip_protocol = "tcp", from_port = 11104, to_port = 11104, cidr_ipv4 = "10.0.0.0/8", description = "SnapMirror management" }
    snapmirror_data = { ip_protocol = "tcp", from_port = 11105, to_port = 11105, cidr_ipv4 = "10.0.0.0/8", description = "SnapMirror data" }
  }

  # Storage Virtual Machine (SVM) and volume
  storage_virtual_machines = {
    svm1 = {
      name = "svmname"
      volumes = {
        vol1 = {
          name                       = "svmname_audit"
          junction_path              = "/svmname_audit"
          size_in_megabytes          = 10240
          storage_efficiency_enabled = true
        }
      }
    }
  }

  # Resource tags
  tags = merge(
    {
      User                   = "Ymohame4"
      Application            = "APP000020013319"
      iacModuleName          = local.module
      iacCompositeModuleName = "terraform-aws-fsx-ontap"
    },
    var.tags
  )
}

# Tag the FSx ONTAP file system with Name = fsxidXXXXXXXX
resource "null_resource" "fsx_tagging" {
  depends_on = [module.fsx_ontap]

  triggers = {
    always_run = timestamp()        # Forces provisioner to run every apply
    name_tag   = local.fsx_name_tag # Computed Name tag (fsxidXXXXXX)
  }

  provisioner "local-exec" {
    command = "aws fsx tag-resource --resource-arn ${local.fsx_file_system_arn} --tags Key=Name,Value=${self.triggers.name_tag} --region eu-west-1"
  }
}

# Override Name tag for FSx security group
resource "aws_ec2_tag" "fsx_sg_name" {
  resource_id = module.fsx_ontap.security_group_id # Security group created by module
  key         = "Name"
  value       = local.fsx_name_tag # Match FSx Name tag
}
