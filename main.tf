data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}


data "azuredevops_project" "project_id" {
  name = var.azuredevops_project_name
}

resource "azuredevops_serviceendpoint_azurerm" "azure_devops_service_endpoint_azurerm" {
  depends_on                             = [azurerm_role_assignment.assign_spn_to_subscription[0]]
  project_id                             = data.azuredevops_project.project_id.id
  service_endpoint_name                  = var.service_principal_name != null ? var.service_principal_name : "spn-azdo-${var.azuredevops_project_name}-${var.azuredevops_organization_guid}"
  description                            = var.service_principal_description
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = module.service_principal.application_id["0"]
  }

  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

module "service_principal" {
  source = "github.com/libre-devops/terraform-azuread-service-principal"

  spns = [
    {
      spn_name                            = var.service_principal_name != null ? var.service_principal_name : "spn-azdo-${var.azuredevops_project_name}-${var.azuredevops_organization_guid}"
      description                         = var.service_principal_description
      create_corresponding_enterprise_app = true
      create_federated_credential         = true
      federated_credential_display_name   = var.service_principal_name != null ? var.service_principal_name : "oidc-wlfid-spn-azdo-${var.azuredevops_project_name}-${var.azuredevops_organization_guid}"
      federated_credential_description    = var.service_principal_description
      federated_credential_audiences      = var.federated_credential_audiences
      federated_credential_issuer         = format("https://vstoken.dev.azure.com/%s", var.azuredevops_organization_guid)
      federated_credential_subject        = format("sc://%s/%s/%s", var.azuredevops_organization_name, var.azuredevops_project_name, var.service_principal_name != null ? var.service_principal_name : "spn-azdo-${var.azuredevops_project_name}-${var.azuredevops_organization_guid}")
    }
  ]
}

resource "azurerm_role_assignment" "assign_spn_to_subscription" {
  count                = var.attempt_assign_role_to_spn == true ? 1 : 0
  principal_id         = module.service_principal.object_id["0"]
  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_definition_name_to_assign
}
