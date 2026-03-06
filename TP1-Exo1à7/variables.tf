variable "docker_image" {
  description = "Nom de l'image du docker"
  type        = string
  default     = "nginx:latest"
}

variable "container_docker" {
  description = "Nom du container Docker"
  type        = string
  default     = "nginx-terraform"
}

variable "port_externe" {
  description = "Port exposé sur la machine"
  type        = number
  default     = 8080
}

variable "port_interne" {
  description = "port interne du container"
  type        = number
  default     = 80
}

variable "nb_clients" {
  description = "Nombre de conteneurs client"
  type = number
  default = 4
}

variable "servers" {
  description = "Liste des nom des serveurs"
  type = list(string)
  default = [ "Micheal", "Gerard", "Pascal", "Olivier" ]
}

variable "machines" {
  description = "Liste des machines virtuelles à déployer"

  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  default = [
    {
      name      = "vm-1"
      vcpu      = 2
      disk_size = 20
      region    = "eu-west-1"
    },
    {
      name      = "vm-2"
      vcpu      = 4
      disk_size = 520
      region    = "us-east-1"
    },
  ]

  validation {
    condition = alltrue([
      for machine in var.machines :
      machine.disk_size >= 20
    ])
    error_message = "Chaque machine doit avoir une taille de disque sup ou égale a 20."
  }

  validation {
    condition = alltrue([
      for machine in var.machines :
      contains(["eu-west-1", "us-east-1", "ap-southeast-1"], machine.region)
    ])
    error_message = "La région doit être eu-west-1, us-east-1 ou ap-southeast-1."
  }

  validation {
    condition = alltrue([
      for machine in var.machines :
      machine.vcpu >= 2 && machine.vcpu <= 64
    ])
    error_message = "Chaque machine doit avoir un nombre de vCPU compris entre 2 et 64."
  }
}