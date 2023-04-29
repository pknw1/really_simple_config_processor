locals {
    json_files = fileset(path.module, "configuration_files/*json")   
    json_data  = [ for f in local.json_files : jsondecode(file("${f}")) ]  
}

module "azurerm_ea_subscription" {
    source="./src"

    for_each = { for f in local.json_data : f.module_variable1 => f }

    module_variable1         = each.value.module_variable1
    module_variable2         = each.value.module_variable2  

}


output "files" {
  value = local.json_files
}