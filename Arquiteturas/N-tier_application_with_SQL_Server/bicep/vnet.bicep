
//Paramentros gerais
//------------------------------------------------
@description('Localização do recurso.')
param location string = resourceGroup().location



//Paramentros Vnet
//------------------------------------------------
@description('Nome da Vnet')
param virtualNetworkName string

@description('Mascara de IP da vnet.')
param addressPrefixes string

//------------------------------------------------

//@description('Nome da Subnet do BastionHost.')
//param subnetBastion string
@description('Nome da Subnet Web.')
param subnetAppGatewayName string

@description('Nome da Subnet Web.')
param subnetWebName string

@description('Nome da Subnet Bussiness.')
param subnetBusinessName string

@description('Nome da Subnet de banco de dados.')
param subnetDataName string



//Paramentros de endereçamento de ip da subnets
//------------------------------------------------
//@description('Mascara de IP da subnet Bastion.')
//param addressPrefixsubnetBastion string

@description('Mascara de IP da subnet web.')
param addressPrefixsubnetAppGateway string
@description('Mascara de IP da subnet web.')
param addressPrefixsubnetWeb string

@description('Mascara de IP da subnet bussiness.')
param addressPrefixsubnetBusiness string

@description('Mascara de IP da subnet de dados.')
param addressPrefixsubnetData string


//------------------------------------------------

//Paramentros de cada grupo de segurança(NSG) 
//------------------------------------------------

//@description('Nome do Nsg do bastion.')
//param bastionNsgName string



@description('Nome do Nsg web.')
param nsgWebName string

@description('Nome do Nsg bussiness.')
param nsgBusinessName string

@description('Nome do Nsg banco de dados.')
param nsgDataName string


//------------------------------------------------


//Paramentros subnetBastion
//------------------------------------------------
//@description('Nome da BastionHost')

//param bastionHostName string
//@description('Nome do ip publico que direciona para o bastion')
//param bastionIpName string

@description('Outputs do módulo')

//output nsgbastionId string = bastionIpPublic.id
output vnetId string = vnet.id
output nsgWebId string = nsgWeb.id
output nsgBusinessId string = nsgBusiness.id
output nsgDataId string = nsgData.id



output subnetWebName string = subnetWebName
output subnetBusinessName string = subnetBusinessName
output subnetDataName string = subnetDataName

output virtualNetworkName string = virtualNetworkName



resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
    subnets: [
      /*
      {
        name: subnetBastion
        properties: {
          addressPrefix: addressPrefixsubnetBastion
          networkSecurityGroup: {
            id: bastionNsg.id
          }
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
       
      }*/
      {
        name: subnetAppGatewayName
        properties: {
          addressPrefix: addressPrefixsubnetAppGateway
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
         
        }
      }
      {
        name: subnetWebName
        properties: {
          addressPrefix: addressPrefixsubnetWeb
          networkSecurityGroup: {
            id: nsgWeb.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'

        }
      }
        
      {
        name: subnetBusinessName
        properties: {
          addressPrefix: addressPrefixsubnetBusiness
          networkSecurityGroup: {
            id: nsgBusiness.id
          }
        }
      }

      {
        name: subnetDataName
        properties: {
          addressPrefix: addressPrefixsubnetData
          networkSecurityGroup: {
            id: nsgData.id
          }
        }
      }

      


      
    ]
  }


}

resource subnetAppGateway 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet
  name: subnetAppGatewayName
  properties: {
    addressPrefix: addressPrefixsubnetAppGateway
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnetWeb 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet
  name: subnetWebName
  properties: {
    addressPrefix: addressPrefixsubnetWeb
    networkSecurityGroup: {
      id: nsgWeb.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}


/*
resource bastionNsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: bastionNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'in_gateway_manager_any'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'in_azure_cloud_any'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureCloud'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'in_any_https'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'out_azure_cloud_https'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'out_virtualnetwork_rdp'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'out_virtualnetwork_ssh'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }



    ]
  }
}*/



resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgWebName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '10.2.254.0/27'
          destinationAddressPrefix: '10.2.1.0/24'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80WebIn'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.1.0/24'
          destinationAddressPrefix: '10.2.2.0/24'
          access: 'Allow'
          priority: 1010
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80DataIn'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.3.0/24'
          destinationAddressPrefix: '10.2.2.0/24'
          access: 'Allow'
          priority: 1011
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'AllowPort_80WebOut'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: '10.2.1.0/24'
          access: 'Allow'
          priority: 1010
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80DataOut'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: '10.2.3.0/24'
          access: 'Allow'
          priority: 1011
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }


    ]
  }
}

resource nsgBusiness 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgBusinessName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '10.2.254.0/27'
          destinationAddressPrefix: '10.2.2.0/24'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80WebIn'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.1.0/24'
          destinationAddressPrefix: '10.2.2.0/24'
          access: 'Allow'
          priority: 1010
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80DataIn'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.3.0/24'
          destinationAddressPrefix: '10.2.2.0/24'
          access: 'Allow'
          priority: 1011
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }

      {
        name: 'AllowPort_80WebOut'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: '10.2.1.0/24'
          access: 'Allow'
          priority: 1010
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowPort_80DataOut'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: '10.2.3.0/24'
          access: 'Allow'
          priority: 1011
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }


    ]
  }
}

resource nsgData 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgDataName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '10.2.254.0/27'
          destinationAddressPrefix: '10.2.3.0/24'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Negar_conexoes'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1040
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NegarPort_80'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '10.2.1.0/24'
          destinationAddressPrefix: '10.2.3.0/24'
          access: 'Deny'
          priority: 1030
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}
/*

resource bastionIpPublic 'Microsoft.Network/publicIPAddresses@2021-05-01'={
  
  name:bastionIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }

}*/


