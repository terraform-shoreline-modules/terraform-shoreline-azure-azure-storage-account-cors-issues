resource "shoreline_notebook" "azure_storage_account_cors_issues" {
  name       = "azure_storage_account_cors_issues"
  data       = file("${path.module}/data/azure_storage_account_cors_issues.json")
  depends_on = [shoreline_action.invoke_cors_setup]
}

resource "shoreline_file" "cors_setup" {
  name             = "cors_setup"
  input_file       = "${path.module}/data/cors_setup.sh"
  md5              = filemd5("${path.module}/data/cors_setup.sh")
  description      = "Check and update the Azure storage account configuration settings to ensure that CORS is correctly configured."
  destination_path = "/tmp/cors_setup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cors_setup" {
  name        = "invoke_cors_setup"
  description = "Check and update the Azure storage account configuration settings to ensure that CORS is correctly configured."
  command     = "`chmod +x /tmp/cors_setup.sh && /tmp/cors_setup.sh`"
  params      = ["STORAGE_ACCOUNT_KEY","ALLOWED_ORIGINS","STORAGE_ACCOUNT_NAME","METHODS"]
  file_deps   = ["cors_setup"]
  enabled     = true
  depends_on  = [shoreline_file.cors_setup]
}

