variable "rules" {
  description = "Standard set of predefined rules"
  type        = "map"
  default = {
    RDP = ["Inbound", "Allow", "TCP", "*", "3389", "RDP"]
    SSH = ["Inbound", "Allow", "TCP", "*", "22", "SSH"]
    ADS2 = ["Inbound", "Allow", "TCP", "*", "9010-9111", "ADS2"]
  }
}
