variable "attempt_assign_role_to_spn" {
  type        = bool
  description = "Whether or not to attempt to assign a role to the SPN to the subscription.  This is actually needed, so defaults to true"
  default     = true
}

variable "azuredevops_organization_guid" {
  type        = string
  description = "The unique ID of your Azure DevOps organisation"
}

variable "azuredevops_organization_name" {
  type        = string
  description = "The name of your Azure DevOps organization"
}

variable "azuredevops_project_name" {
  type        = string
  description = "The name of your Azure DevOps project you want to configure the federated cred for"
}

variable "federated_credential_audiences" {
  type        = list(string)
  description = "The audience for the credential, set to the default for Azure DevOps"
  default     = ["api://AzureADTokenExchange"]
}

variable "federated_credential_display_name" {
  type        = string
  description = "The display name of your federated credential in AzureAD/Entra for ID"
  default     = null
}

variable "role_definition_name_to_assign" {
  type        = string
  description = "The role definition needed to setup SPN, for security reasons, defautls to Reader"
  default     = "Reader"
}

variable "service_principal_description" {
  type        = string
  description = "The description of the service principal"
  default     = null
}

variable "service_principal_name" {
  type        = string
  description = "The name of the service principal"
  default     = null
}
