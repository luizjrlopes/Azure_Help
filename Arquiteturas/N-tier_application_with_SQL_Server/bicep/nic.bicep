@description('Locazação de todos os recursos.')
param location string = resourceGroup().location

@description('Nome da plca de rede da VM.')
param nicName string 

@description('Ip Público')
param privateIPAddress string //10.0.1.5

@description('Id do grupo de segurança (NSG)')
param nsgId string 

@description('Nome da subnet')
param subnetName string 

@description('Nome da vnet')
param vnetName string 

@description('nome da vm')
param vmName string 



resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig${vmName}'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          privateIPAddress: privateIPAddress
          privateIPAllocationMethod: 'Static'
        
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}
output nicId string = nic.id
