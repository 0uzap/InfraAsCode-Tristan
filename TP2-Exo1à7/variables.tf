variable "instance_type" {
    description = "Type de l'instance EC2"
    type        = string
    default     = "t2.micro"
}

variable "instance_name" {
    description = "Nom de l'instance EC2"
    type        = string
    default     = "nginx-server"
}

variable "bucket_name" {
    description = "Nom du bucket S3"
    type        = string
    default     = "monbucketexotp2"
}

variable "default_port" {
    description = "Port HTTP du security group"
    type        = number
    default     = 80
}

variable "db_instance_name" {
    description = "Nom de l'instance EC2 base de donnée"
    type        = string
    default     = "database-server"
}

variable "wordpress_db_name" {
    description = "Nom base WP"
    type        = string
    default     = "wordpress"  
}

variable "wordpress_db_user" {
    description = "Utilistaeur Mysql pour wp"
    type        = string
    default     = "wpuser"
}

variable "wordpress_db_password" {
    description = "Mdp Mysql pour wp"
    type        = string
    default     = "wppassword123"
}

variable "wordpress_db_root_password" {
    description = "mdp root mysql"
    type        = string
    default     = "rootpassword123"
}