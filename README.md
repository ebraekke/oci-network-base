# ebraekke/oci-network-base

TODO: Clean up doc and redo section with fw rules, replace generic rules with specific ones for bastion and reverse ips respectively.  


## Download the latest version of the Resource Manager ready stack from the releases section

Or you can just click the button below.

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/ebraekke/oci-network-base/releases/download/v0.9.0-alpha.1/oci-network-base_0.9.0.zip)

## Session based authentication

Provide the name of the session created using `oci cli session autenticate` in the variable `oci_cli_profile`.

## Create

```hcl
terraform plan --out=oci-network-base.tfplan --var-file=config/vars_arn.tfvars

terraform apply "oci-network-base.tfplan"
```

## Resource Manager

### Create a release

Perform these operations from the top level folder in repo.

Remember to add Linux to lock file.
```bash
terraform providers lock -platform=linux_amd64
```

Create ZIP archive, add non-tracked file from config dir.
```bash
git archive --add-file config\provider.tf --format=zip HEAD -o .\config\test_rel.zip
```

### Create stack in FRA

```bash
$C = "ocid1.compartment.oc1..somehashlikestring"
$config_source  = "C:\Users\espenbr\GitHub\oci-network-base\config\test_rel.zip"
$variables_file = "C:/Users/espenbr/GitHub/oci-network-base/config/vars_fra.json"
$disp_name = "DEV 2.Network base FRA"
$desc = "DEV 2 oci-network-base RM"
$wait_spec="--wait-for-state=ACTIVE"

oci resource-manager stack create --config-source=$config_source --display-name="$disp_name" --description="$desc" --variables=file://$variables_file -c $C --terraform-version=1.2.x $wait_spec
```
### Create stack in ARN

```bash
$C = "ocid1.compartment.oc1..somehashlikestring"
$config_source  = "C:\Users\espenbr\GitHub\oci-network-base\config\test_rel.zip"
$variables_file = "C:/Users/espenbr/GitHub/oci-network-base/config/vars_arn.json"
$disp_name = "DEV 2.Network base"
$desc = "DEV 2 oci-network-base RM"
$wait_spec="--wait-for-state=ACTIVE"

oci resource-manager stack create --config-source=$config_source --display-name="$disp_name" --description="$desc" --variables=file://$variables_file -c $C --terraform-version=1.2.x $wait_spec
```