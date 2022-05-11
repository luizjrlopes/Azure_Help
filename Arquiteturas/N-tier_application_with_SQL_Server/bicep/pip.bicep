@description('Location for all resources.')
param location string = resourceGroup().location

param publicIpGateway string

output pipId string = pipAppGateway.id
resource pipAppGateway 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIpGateway
  location: location
  sku: {
    name: 'Standard'
  }
 
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }

  
  }

