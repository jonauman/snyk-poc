LOGS=$1
SNYK_FINDING=SNYK-CC-TF-194

if [ $# -eq 0 ]
then
  echo "This script takes exactly one argument."
  echo "If the argument value is 'LOGS', then logging"
  echo "will be enabled and no alert should be generated."
  echo ""
  echo "Any other argument value;e.g. 'foo', will disable"
  echo "logging and should generate SNYK finding: $SNYK_FINDING"
  exit 1
fi

if [[ $LOGS == "LOGS" ]]
then
    varfile=logs.tfvars
    out=logs.tfplan
    snyk_out=snyk-iac-logs.json
else
    varfile=no-logs.tfvars
    out=no-logs.tfplan
    snyk_out=snyk-iac-nologs.json
fi

terraform init
terraform plan -var-file $varfile -out=$out
terraform show -json $out | jq . > ${out}.json
snyk iac test --json --json-file-output=${snyk_out} --scan=planned-values ${out}.json

log_config=$(jq '.planned_values.root_module.resources[1].values.log_config' ${out}.json)

echo "TERRAFORM VERSION: $(terraform --version|head -1)"
echo "SNYK VERSION: $(snyk --version)" 
echo "SNYK FINDINGS: $(jq '.infrastructureAsCodeIssues[].id' ${snyk_out})"
if [[ $out == "no-logs.tfplan" ]]
then
    echo "EXPECTED SNYK FINDINGS: $SNYK_FINDING"
fi
echo "SUBNET LOG CONFIG: ${log_config}"
