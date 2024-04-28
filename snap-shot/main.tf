terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Retrieve information about the virtual machine
data "azurerm_virtual_machine" "example_vm" {
  name                = "test-vm"
  resource_group_name = "res-01"
}

# Retrieve the managed OS disk attached to the virtual machine
data "azurerm_managed_disk" "example_os_disk" {
  name                = "test-vm_disk1_4a584796b1c541dc83d08757ba986b22"#"${data.azurerm_virtual_machine.example_vm.name}-osdisk"
  resource_group_name = data.azurerm_virtual_machine.example_vm.resource_group_name
}

# Create a snapshot of the OS disk
resource "azurerm_snapshot" "example_snapshot" {
  name                = "snap-shot-01"
  location            = "East US"  # Specify the desired location for the snapshot
  resource_group_name = "res-01"

  source_resource_id = data.azurerm_managed_disk.example_os_disk.id
  create_option      = "Copy"  # Specify the create_option as "Copy" to create an independent snapshot
}
