# Test VPC Logging Detection (GCP)

This repo is a minimal Terraform setup used to demonstrate that Snyk IaC does **not** catch the listed vulnerability in a specific case.

The listed vulnerability is:
- `SNYK-CC-TF-194` (GCP subnet/VPC flow logs disabled)

## What this repo does

- Creates a single custom VPC and subnet in GCP London (`europe-west2`).
- Uses a dynamic `log_config` block on the subnet.
- Uses `run.sh` to generate a plan and scan it with Snyk IaC.

## Prerequisites

- Terraform
- Snyk CLI (authenticated)
- `jq`

## Usage

Run the demo script with exactly one argument:

```bash
./run.sh LOGS
```

- Uses `logs.tfvars` (logging enabled by default)
- Produces `logs.tfplan`, `logs.tfplan.json`, and `snyk-iac-logs.json`

To disable logging and reproduce the missed finding:

```bash
./run.sh NOLOGS
```

- Uses `no-logs.tfvars` (`subnet_logging_config = null`)
- Produces `no-logs.tfplan`, `no-logs.tfplan.json`, and `snyk-iac-nologs.json`
- Expected finding: `SNYK-CC-TF-194`
- Actual behavior this repo demonstrates: Snyk does not report that finding

## Notes

- `run.sh` prints Terraform and Snyk versions plus any Snyk findings and the subnet `log_config`.
- Update `project_id` in `logs.tfvars` and `no-logs.tfvars` to a real project before running.

## Example output

```
jonauman@Mac test-vpc % ./run.sh NOLOGS                       
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Using previously-installed hashicorp/google v7.17.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_compute_network.vpc will be created
  + resource "google_compute_network" "vpc" {
      + auto_create_subnetworks                   = false
      + bgp_always_compare_med                    = (known after apply)
      + bgp_best_path_selection_mode              = (known after apply)
      + bgp_inter_region_cost                     = (known after apply)
      + delete_bgp_always_compare_med             = false
      + delete_default_routes_on_create           = false
      + gateway_ipv4                              = (known after apply)
      + id                                        = (known after apply)
      + internal_ipv6_range                       = (known after apply)
      + mtu                                       = (known after apply)
      + name                                      = "this-vpc"
      + network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
      + network_id                                = (known after apply)
      + numeric_id                                = (known after apply)
      + project                                   = "1234567890123"
      + routing_mode                              = "REGIONAL"
      + self_link                                 = (known after apply)
    }

  # google_compute_subnetwork.subnet will be created
  + resource "google_compute_subnetwork" "subnet" {
      + creation_timestamp         = (known after apply)
      + external_ipv6_prefix       = (known after apply)
      + fingerprint                = (known after apply)
      + gateway_address            = (known after apply)
      + id                         = (known after apply)
      + internal_ipv6_prefix       = (known after apply)
      + ip_cidr_range              = "10.1.1.128/25"
      + ipv6_cidr_range            = (known after apply)
      + ipv6_gce_endpoint          = (known after apply)
      + name                       = "this-subnet"
      + network                    = (known after apply)
      + private_ip_google_access   = (known after apply)
      + private_ipv6_google_access = (known after apply)
      + project                    = "1234567890123"
      + purpose                    = (known after apply)
      + region                     = "europe-west2"
      + self_link                  = (known after apply)
      + stack_type                 = (known after apply)
      + state                      = (known after apply)
      + subnetwork_id              = (known after apply)

      + secondary_ip_range (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + subnet_name      = "this-subnet"
  + subnet_self_link = (known after apply)
  + vpc_name         = "this-vpc"
  + vpc_self_link    = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: no-logs.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "no-logs.tfplan"
{
  "meta": {
    "isPrivate": true,
    "isLicensesEnabled": false,
    "ignoreSettings": {
      "adminOnly": false,
      "reasonRequired": false,
      "disregardFilesystemIgnores": false,
      "autoApproveIgnores": false,
      "approvalWorkflowEnabled": false
    },
    "org": "my-org",
    "orgPublicId": "xxx-xxxx-xxx-xxxx",
    "policy": ""
  },
  "filesystemPolicy": false,
  "vulnerabilities": [],
  "dependencyCount": 0,
  "licensesPolicy": null,
  "ignoreSettings": null,
  "targetFile": "no-logs.tfplan.json",
  "projectName": "test-vpc",
  "org": "my-org",
  "policy": "",
  "isPrivate": true,
  "targetFilePath": "/Users/jonauman/test-vpc/no-logs.tfplan.json",
  "packageManager": "terraformconfig",
  "path": "no-logs.tfplan.json",
  "projectType": "terraformconfig",
  "ok": true,
  "infrastructureAsCodeIssues": []
}
TERRAFORM VERSION: Terraform v1.13.3
SNYK VERSION: 1.1302.1
SNYK FINDINGS: 
EXPECTED SNYK FINDINGS: SNYK-CC-TF-194
SUBNET LOG CONFIG: []
```
