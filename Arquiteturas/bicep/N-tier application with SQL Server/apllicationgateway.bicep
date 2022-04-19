param location string
param applicationGatewayName string

@description('Parametros de recursos externos ao Application Gateway')

param vnetId string
param subnetAppGatewayName string
param apgBackendAddressesIp array

@description('Parametros das Propriedades do Application Gateway')
//sku do Application Gateway
param tier string
param skuSize string

// gatewayIPConfigurations do Application Gateway
param gatewayIPConfigurationsName string = 'appGatewayIpConfig'

// frontendIPConfigurations do Application Gateway
param publicIPRef string

//autoscaleConfiguration do Application Gateway

param capacity int
param autoScaleMaxCapacity int

//@description('Parametros do Ip publico')

//param publicIpAddressName string

//param zones array

//param sku string
//param allocationMethod string
//param publicIpZones array





@description('Gera ID da subnet do Application Gateway')
var subnetRef = '${vnetId}/subnets/${subnetAppGatewayName}'


@description('Variáveis das Propriedades do Application Gateway')
// frontendIPConfigurations do Application Gateway
var frontendIPName  = 'publicIpGateway'

// frontendIPConfigurations do Application Gateway
var frontendPortName  = 'port_80'

// backendAddressPools do Application Gateway
var backendAddressPoolsName  = 'webBackendAddressPool'

// backendHttpSettingsCollection do Application Gateway
var backendHttpSettingsCollectionName  =  'webBackendHttpSetting1'

// httpListeners do Application Gateway
var httpListenersName = 'webHttpListener1'

resource applicationGatewayName_resource 'Microsoft.Network/applicationGateways@2019-09-01' = {
  name: applicationGatewayName
  location: location
  tags: {}
  zones: []
  properties: {
    sku: {
      name: skuSize
      tier: tier
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIPConfigurationsName
        properties: {
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIPName
        properties: {
          publicIPAddress: {
            id: publicIPRef
          }
         
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendPortName
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name:backendAddressPoolsName
        properties: {
          backendAddresses: [
            {
              ipAddress: apgBackendAddressesIp[0]
            }
            {
              ipAddress: apgBackendAddressesIp[1]
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsCollectionName
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenersName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations',applicationGatewayName,frontendIPName)
           
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts',applicationGatewayName,frontendPortName)
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'webRule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
           
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/',applicationGatewayName,httpListenersName)
         
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools',applicationGatewayName,backendAddressPoolsName)
         
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection',applicationGatewayName,backendHttpSettingsCollectionName)
         
          }
        }
      }
    ]
    enableHttp2: false
    sslCertificates: []
    probes: []
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Detection'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
    }
  }
}


