# Terraform

### About this repo
This is the terraform code which runs rbrk.at.

### Setup
You will need to create a secrets folder, as referenced in the provider.tf file and then add the required credentials for GCP and OVH. Scrits for this will be added in the near future. As for how this is done, please reference the folder structure below.

### Folder
```
├── README.md
├── modules
│   ├── lb-https
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── vars.tf
│   └── mig
│       ├── main.tf
│       ├── outputs.tf
│       └── vars.tf
├── prod
│   ├── acme.tf
│   ├── dns.tf
│   ├── init.sh
│   ├── main.tf
│   ├── net.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── vars.tf
└── secrets
    ├── ovh
    │   ├── application_key
    │   ├── application_secret
    │   └── consumer_key
    ├── rbrk-dev.json
    └── rbrk-prod.json
```
