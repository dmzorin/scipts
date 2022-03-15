fun_calc() {
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
if [ -z "${1}" ]; then
echo "Date required in format: yyyy-mm-dd"
return
fi
pro=${2:-aan}
function_list=(
"argo_cd_trigger"
"auto_resource_labeler"
"block_notebooks_metadata_removal"
"block_notebooks_network_tag_removal"
"block_notebooks_root_access"
"cloud_sql_instance_set_backup"
"dataflow_long_running_job_alerts"
"enforce_https_cloud_functions"
"gcp-compute-engine-osloginenforce"
"gcp-gke-cluster-basic-authentication-disabled"
"gcp-gke-cluster-disable-legacy-abac"
"gcp-gke-cluster-intranode-visibility-enable0"
"gcp-gke-cluster-set-logging-monitoring"
"gcp-gke-cluster-set-master-authorized-networks"
"gcp-gke-cluster-unsecure-delete"
"gcp-gke-nodepool-ensure-gke-metadata-server"
"gcp-gke-nodepool-set-auto-repair"
"gcp-gke-nodepool-set-auto-upgrade"
"gcp-gke-nodepool-set-cos-image"
"gcp-gke-nodepool-unsecure-delete"
"gcp-kms-disallowed-key-delete"
"gcr_enforce_gcf_images"
"key_rotation"
"load_balancer_logging_disabled"
"load_balancer_no_cloud_armor_policy"
"load_balancer_uses_https"
"load_balancer_uses_tls1_2_restricted_profile_ssl_policy"
"notification_service"
"periodic_functions_trigger"
"role_create_validation"
"role_grant_validation"
"ssl_connections_for_cloud_sql"
"test_block_dataflow_network_tag_removal"
"test_block_dataflow_worker_metadata_removal"
"test_block_project-wide_ssh_keys_for_instances"
"test_cloud_storage_have_only_private_access"
"test_periodic_function"
"test_valid_network"
"test_vm_backup_policy"
)
for function_name in ${function_list[*]}; do
printf "$YELLOW%-56s$NC%s" $function_name SUCCESS:
success_count=`gcloud logging read 'timestamp<="'${1}'T23:59:59.999Z" AND
timestamp>="'${1}'T00:00:00.000Z" AND
textPayload=~"finished with status: '"'"'ok'"'"'" AND
resource.labels.function_name="'$function_name'"' --project=gcp-vpcx-${pro} --format list | grep -c "insertId:"`
printf "$GREEN%5s$NC CRASH:" $success_count

crash_count=`gcloud logging read 'timestamp<="'${1}'T23:59:59.999Z" AND
timestamp>="'${1}'T00:00:00.000Z" AND
textPayload=~"finished with status: '"'"'crash'"'"'" AND
resource.labels.function_name="'$function_name'"' --project=gcp-vpcx-${pro} --format list | grep -c "insertId:"`
printf "$RED%5s$NC\n" $crash_count
done
}

fun_calc 2022-01-26