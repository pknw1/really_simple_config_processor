```
 ____            _ _         ____  _                 _      
|  _ \ ___  __ _| | |_   _  / ___|(_)_ __ ___  _ __ | | ___ 
| |_) / _ \/ _` | | | | | | \___ \| | '_ ` _ \| '_ \| |/ _ \
|  _ <  __/ (_| | | | |_| |  ___) | | | | | | | |_) | |  __/
|_| \_\___|\__,_|_|_|\__, | |____/|_|_| |_| |_| .__/|_|\___|
                     |___/                    |_|           
  ____             __ _         ____                                         
 / ___|___  _ __  / _(_) __ _  |  _ \ _ __ ___   ___ ___  ___ ___  ___  _ __ 
| |   / _ \| '_ \| |_| |/ _` | | |_) | '__/ _ \ / __/ _ \/ __/ __|/ _ \| '__|
| |__| (_) | | | |  _| | (_| | |  __/| | | (_) | (_|  __/\__ \__ \ (_) | |   
 \____\___/|_| |_|_| |_|\__, | |_|   |_|  \___/ \___\___||___/___/\___/|_|   
                        |___/                                                
 ```

 * a simple mechanism to ingest configurations added over time to a git repo


 1. add a config file into the `configuration_files` folder
 2. run `terraform apply` to start the workflow
 3. `terraform` `locals` creates a list of files to process from the folder
 4. process the inputs in the usual way with a for_each loop


 ```
 locals {
    json_files = fileset(path.module, "configuration_files/*json")   
    json_data  = [ for f in local.json_files : jsondecode(file("${f}")) ]  
}
```

```

module "azurerm_ea_subscription" {
    source="./src"

    for_each = { for f in local.json_data : f.module_variable1 => f }

    module_variable1         = each.value.module_variable1
    module_variable2         = each.value.module_variable2  

}
```

- Single config files, rather than huge config maps are easier to decipher and simpler to review in a Pull Request
- By using one file per configuration, we have a way of users dropping in a config file that if valid will process, if not, will get rejected
- Rather than a traditional repo based solution as below, we could use other methods of dropping thre file in  - such as a webhook post in to `repository_dispatch`
  - git clone
  - branch
  - modify
  - push
  - pr
  - review
  - merge
  - process
