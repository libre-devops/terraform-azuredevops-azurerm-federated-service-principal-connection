module "azdo_spn" {
  source                        = "../../"
  azuredevops_organization_guid = var.azdo_org_guid
  azuredevops_organization_name = var.azdo_org_name
  azuredevops_project_name      = var.azdo_project_name
}
