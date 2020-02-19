



variable simulation_environment_instance_number {
  type        = number
  description = "The number of the simulation environment instance. It will be used as suffix for several resource names to make them unique."
}

variable location {
  type        = string
  description = "The name of the location where the resources for the simulation environment virtual machines will be created."
}

variable "predefined_rules" {
  type    = list(any)
  default = []
}
variable "source_address_prefix" {
  type    = list(string)
  default = ["VirtualNetwork"]

  # Example ["10.0.3.0/24"] or ["VirtualNetwork"]
}

# Destination address prefix to be applied to all rules
variable "destination_address_prefix" {
  type    = list(string)
  default = ["VirtualNetwork"]

  # Example ["10.0.3.0/32","10.0.3.128/32"] or ["VirtualNetwork"] 
}
