
//Paramentros gerais
//------------------------------------------------
@description('Localização do recurso.')
param location string

//Paramentros gerais
//------------------------------------------------
@description('Localização do recurso.')
param loadBalancerName string

param publicIPAddressLoadBalanceName string


param frontendIPSubnetname string

param frontendIPSubnetname string

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressLoadBalanceName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}



resource loadBalancer 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: loadBalancerName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendIPSubnetname
        properties: {
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
    // ...
  }
}

resource symbolicname 'Microsoft.Network/loadBalancers@2021-05-01' = {
  name: 'string'
  location: 'string'

  sku: {
    name: 'string'
    tier: 'string'
  }

  properties: {
    backendAddressPools: [
      {
        id: 'string'
        name: 'string'
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: 'string'
              properties: {
                ipAddress: 'string'
                loadBalancerFrontendIPConfiguration: {
                  id: 'string'
                }
                subnet: {
                  id: 'string'
                }
                virtualNetwork: {
                  id: 'string'
                }
              }
            }
          ]
          location: 'string'
          tunnelInterfaces: [
            {
              identifier: int
              port: int
              protocol: 'string'
              type: 'string'
            }
          ]
        }
      }
    ]
    frontendIPConfigurations: [
      {
        id: 'string'
        name: 'string'
        properties: {
          gatewayLoadBalancer: {
            id: 'string'
          }
          privateIPAddress: 'string'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Static'
       
          subnet: {
            id: 'string'
            name: 'string'
            properties: {
              addressPrefix: 'string'
              addressPrefixes: [
                'string'
              ]
              
              delegations: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    serviceName: 'string'
                  }
                  type: 'string'
                }
              ]
              ipAllocations: [
                {
                  id: 'string'
                }
              ]
           
              networkSecurityGroup: {
                id: 'string'
                location: 'string'
                properties: {
                  securityRules: [
                    {
                      id: 'string'
                      name: 'string'
                      properties: {
                        access: 'string'
                        description: 'string'
                        destinationAddressPrefix: 'string'
                        destinationAddressPrefixes: [
                          'string'
                        ]
                        destinationApplicationSecurityGroups: [
                          {
                            id: 'string'
                            location: 'string'
                            properties: {}
                            tags: {}
                          }
                        ]
                        destinationPortRange: 'string'
                        destinationPortRanges: [
                          'string'
                        ]
                        direction: 'string'
                        priority: int
                        protocol: 'string'
                        sourceAddressPrefix: 'string'
                        sourceAddressPrefixes: [
                          'string'
                        ]
                        sourceApplicationSecurityGroups: [
                          {
                            id: 'string'
                            location: 'string'
                            properties: {}
                            tags: {}
                          }
                        ]
                        sourcePortRange: 'string'
                        sourcePortRanges: [
                          'string'
                        ]
                      }
                      type: 'string'
                    }
                  ]
                }
                tags: {}
              }
              
                         
              serviceEndpoints: [
                {
                  locations: [
                    'string'
                  ]
                  service: 'string'
                }
              ]
            }
            type: 'string'
          }
        }
     
      }
    ]

    loadBalancingRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          backendAddressPool: {
            id: 'string'
          }
          backendAddressPools: [
            {
              id: 'string'
            }
          ]
          backendPort: int
          disableOutboundSnat: bool
          enableFloatingIP: bool
          enableTcpReset: bool
          frontendIPConfiguration: {
            id: 'string'
          }
          frontendPort: int
          idleTimeoutInMinutes: int
          loadDistribution: 'string'
          probe: {
            id: 'string'
          }
          protocol: 'string'
        }
      }
    ]
    outboundRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          allocatedOutboundPorts: int
          backendAddressPool: {
            id: 'string'
          }
          enableTcpReset: bool
          frontendIPConfigurations: [
            {
              id: 'string'
            }
          ]
          idleTimeoutInMinutes: int
          protocol: 'string'
        }
      }
    ]
    probes: [
      {
        id: 'string'
        name: 'string'
        properties: {
          intervalInSeconds: int
          numberOfProbes: int
          port: int
          protocol: 'string'
          requestPath: 'string'
        }
      }
    ]
  }
}
