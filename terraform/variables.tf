variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "yc_zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_image_id" {
  description = "Yandex Cloud image ID for VMs (Ubuntu 22.04 LTS)"
  type        = string
  default     = "fd8autg36kchufhej85b"
}

variable "vm_platform_id" {
  description = "Yandex Cloud platform ID for VMs"
  type        = string
  default     = "standard-v3"
}

variable "vm_cores" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "RAM in GB per VM"
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Boot disk size in GB per VM"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "app_production"
}

variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "app_user"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "db_disk_size" {
  description = "PostgreSQL cluster disk size in GB"
  type        = number
  default     = 10
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "example.com"
}

variable "app_port" {
  description = "Application port on web servers"
  type        = number
  default     = 80
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application key"
  type        = string
  sensitive   = true
}
