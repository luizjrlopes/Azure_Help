@description('Location for all resources.')
param location string

@description('Location for all resources.')
param networkSecurityGroupName string

@description('Location for all resources.')
param sourceAddressPrefixIn string //'*'

@description('Location for all resources.')
param sourceAddressPrefixOut string //'*'

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: sourceAddressPrefixIn
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Permitir conexão porta 80'
        properties: {
          priority: 1000
          sourceAddressPrefix: sourceAddressPrefixIn
          protocol: 'Tcp'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Permitir conexão porta 80'
        properties: {
          priority: 1000
          sourceAddressPrefix: sourceAddressPrefixOut
          protocol: 'Tcp'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Outbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }





    ]
  }
}
