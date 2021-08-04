     variable "environment" {
    type = string
  }
  /*
  variable "subscription_id" {
    type = "string"
  }

  variable "tenant_id" {
    type = "string"
  }
  */
  variable "admin_username" {
    type     = "string"
    default  = "username"
  }
  
  variable "admin_password" {
    type     = "string"
    default  = "Password123!"
  }

  variable "location" {
    type     = "string"
 
  }



  variable "vm_image_string" {
    type    = "string"
  }

  variable "vm_size" {
    type    = "string"
    default = "Standard_DS2_v2"
  }