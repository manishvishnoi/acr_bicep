@description('Name of the Azure Container Registry')
param acrName string

@description('Location for the Azure Container Registry')
param location string = resourceGroup().location

@description('SKU for the Azure Container Registry (e.g., Basic, Standard, Premium)')
param sku string = 'Premium'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: true
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${acrName}-privateEndpoint'
  location: location
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'Test444', 'Test444')
    }
    privateLinkServiceConnections: [
      {
        name: '${acrName}-connection'
        properties: {
          privateLinkServiceId: containerRegistry.id
          groupIds: ['registry']
        }
      }
    ]
  }
}
