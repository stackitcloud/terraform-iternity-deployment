# iTernity iCAS Terraform deployment

![](overview.svg)

To start the installation you first need a working [Terraform instalation](https://developer.hashicorp.com/terraform/downloads) on your PC.

## Installation
Start the installation with creating an `.env` file in the working directory with the following input:
```ini
export TF_VAR_TENANTID=<OpenStackProjectID>
export TF_VAR_USERNAME=<UATUsername>
export TF_VAR_PASSWORD=<UATPassword>
export TF_VAR_STACKIT_PROJECT_ID=<STACKITProjectID>
export TF_VAR_STACKIT_SERVICE_ACCOUNT_TOKEN=<STACKITServiceAccountToken>
```

> Please grather the required information from the Infrastructure API and Service Account tab in the STACKIT Portal.
To create and use a service account please take a look at the [docs](https://docs.stackit.cloud/stackit/en/getting-started-in-service-accounts-134415831.html)

1. Initialize the `.env` variables
    ```shell
    source .env
    ```
1. Configure the iCAS Settings `json`
1. Configure the Deployment parameters (VM type, disk size, availability zone, ...) in the `02-config.tf` file
1. Execure the script
    ```shell
    terraform apply
    ```