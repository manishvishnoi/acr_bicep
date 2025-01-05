@description('Name of the Azure Container Registry')
param acrName string

@description('Name of the Resource Group')
param resourceGroupName string = resourceGroup().name

@description('Location for the Azure Container Registry')
param location string = resourceGroup().location

@description('SKU for the Azure Container Registry (e.g., Basic, Standard, Premium)')
param sku string = 'Basic'

@description('Enable admin user')
param adminEnabled bool = true

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminEnabled
  }
}

output registryId string = containerRegistry.id
output registryUrl string = containerRegistry.properties.loginServer
