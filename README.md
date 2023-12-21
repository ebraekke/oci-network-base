# oci-network-base
oci-network-base


terraform plan --out=oci-network-base.tfplan --var-file=config/vars_arn.tfvars

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

### Create stack

```bash
$C = "ocid1.compartment.oc1..somehashlikestring"
$config_source  = "C:\Users\espenbr\GitHub\oci-network-base\config\test_rel.zip"
$variables_file = "C:/Users/espenbr/GitHub/oci-network-base/config/vars_arn.json"
$disp_name = "DEV 2.Network base"
$desc = "DEV 2 oci-network-base RM"
$wait_spec="--wait-for-state=ACTIVE"

oci resource-manager stack create --config-source=$config_source --display-name="$disp_name" --description="$desc" --variables=file://$variables_file -c $C --terraform-version=1.2.x $wait_spec
```