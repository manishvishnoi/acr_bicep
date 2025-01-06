@description('Name of the Azure Container Registry')
param acrName string

@description('Name of the Resource Group')
param resourceGroupName string = resourceGroup().name

@description('Location for the Azure Container Registry')
param location string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Premium'
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
      id: '/subscriptions/9436480f-c708-4e0f-aba3-3d5af128e84a/resourceGroups/RG-mavishnoi/providers/Microsoft.Network/virtualNetworks/Test444/subnets/Test444'
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
