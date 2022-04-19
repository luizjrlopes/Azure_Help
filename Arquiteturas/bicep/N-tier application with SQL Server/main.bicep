

@description('Location for all resources.')
param adminUsername string 

@secure()
@description('Location for all resources.')
param adminPassword string 

@description('Location for all resources.')
param location string = deployment().location


var vmWebName='vmWeb'
var nicVmWebName='nicVmWeb'

var vmBussinessName='vmBussiness'
var nicVmBussinesName='nicVmBussines'



//Numero de Vms por camada
var vmCount = 2
//geras os ips da Vms que estarão atras do application gateway
var apgBackendAddressesIp = [for i in range(0, 2): '10.4.1.${i+4}']


var vmDataName='vmData'
var nicVmDataName='nicVmData'



targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg_ntier'
  location: location
}

module vnet 'vnet.bicep' = {
  scope: rg
  name: 'vnet'

  params: {

    location: location

    virtualNetworkName: 'vnet-ntier'
    addressPrefixes: '10.4.0.0/16'
    subnetAppGatewayName: 'AppGatewayTierSubnet'
   // subnetBastion:'BastionTierSubnet'
    subnetWebName: 'webTierSubnet'
    subnetBusinessName: 'businessTierSubnet'
    subnetDataName: 'dataTierSubnet'
   
    addressPrefixsubnetAppGateway: '10.4.0.0/24'
    //addressPrefixsubnetBastion: '10.4.254.0/27'
    addressPrefixsubnetWeb: '10.4.1.0/24'
    addressPrefixsubnetBusiness: '10.4.2.0/24'
    addressPrefixsubnetData: '10.4.3.0/24'
    
   
   // bastionNsgName:'BastionTierSubnet_nsg'
    nsgWebName:'webTierSubnet_nsg'
    nsgBusinessName:'businessTierSubnet_nsg'
    nsgDataName:'dataTierSubnet_nsg'
    
   // bastionIpName:'bastionIP-tier'
    //bastionHostName:'BastionHost_tier'
   

  }
  
}




module pipAppGateway 'pip.bicep'={
  name: 'pipAppGateway'
  scope: rg
  params:{

  location:location
  publicIpGateway : 'pipAppGateway'
  }

}


module appGateway 'apllicationgateway.bicep'={
  name: 'aplicationgateway'
  scope: rg

  params:{

    location:location
    applicationGatewayName:'webAppGateway'
    tier:'WAF_v2'
    skuSize:'WAF_v2'
    capacity:0
    vnetId:vnet.outputs.vnetId
    subnetAppGatewayName: 'AppGatewayTierSubnet'
    publicIPRef:pipAppGateway.outputs.pipId
    //zones:[]
    //publicIpAddressName:'publicIpGateway'
    //sku:'Standard'
  // allocationMethod:'Static'
    //publicIpZones:[]
    autoScaleMaxCapacity: 10
    apgBackendAddressesIp:apgBackendAddressesIp
  }

}

module nicVmWeb 'nic.bicep' =[for i in range(0, vmCount):{
  
  name: '${nicVmWebName}${i+1}'
  scope: rg
  params:{
  location:location
  nicName: '${nicVmWebName}${i+1}'
  privateIPAddress:'10.4.1.${i+4}'
  nsgId: vnet.outputs.nsgWebId
  subnetName:vnet.outputs.subnetWebName
  vnetName:vnet.outputs.virtualNetworkName
  vmName:'${vmWebName}${i+1}'
  }
  

}]

module vmWeb 'vm.bicep' =[for i in range(0, vmCount):{
  
  name: '${vmWebName}${i+1}'
  scope: rg
  params:{

  location:location
  virtualMachineName:'${vmWebName}${i+1}'
  virtualMachineSize:'Standard_D2_v3'
  adminUsername:adminUsername
  adminPassword:adminPassword
  nicId: nicVmWeb[i].outputs.nicId
  sku:'2019-Datacenter'
  }
  

}]

module nicVmBussines 'nic.bicep' =[for i in range(0, vmCount):{
  
  name: '${nicVmBussinesName}${i+1}'
  scope: rg
  params:{
  location:location
  nicName:'${nicVmBussinesName}${i+1}'
  privateIPAddress:'10.4.2.${i+4}'
  nsgId: vnet.outputs.nsgBusinessId
  subnetName:vnet.outputs.subnetBusinessName
  vnetName:vnet.outputs.virtualNetworkName
  vmName:'${vmBussinessName}${i+1}'
  }
  

}]

module vmBussiness 'vm.bicep' =[for i in range(0, vmCount):{
  
  name: '${vmBussinessName}${i+1}'
  scope: rg
  params:{

  location:location
  virtualMachineName: '${vmBussinessName}${i+1}'
  virtualMachineSize:'Standard_D2_v3'
  adminUsername:'adminLuiz'
  adminPassword:'Tecnologia1*'
  nicId: nicVmBussines[i].outputs.nicId
  sku:'2019-Datacenter'
  }
  

}]

module nicVmData 'nic.bicep' =[for i in range(0, vmCount):{
  
  name: '${nicVmDataName}${i+1}'
  scope: rg
  params:{
  location:location
  nicName:'${nicVmDataName}${i+1}'
  privateIPAddress:'10.4.3.${i+4}'
  nsgId: vnet.outputs.nsgDataId
  subnetName:vnet.outputs.subnetDataName
  vnetName:vnet.outputs.virtualNetworkName
  vmName:'${vmDataName}${i+1}'
  }
  

}]

module vmData 'vm.bicep' =[for i in range(0, vmCount):{
  
  name: '${vmDataName}${i+1}'
  scope: rg
  params:{

  location:location
  virtualMachineName:'${vmDataName}${i+1}'
  virtualMachineSize:'Standard_D2_v3'
  adminUsername:'adminLuiz'
  adminPassword:'Tecnologia1*'
  nicId: nicVmData[i].outputs.nicId
  sku:'2019-Datacenter'
  }
  

}]



/*
module loadBalancer 'loadbalance.bicep' ={
  
  name: 'loadBalancerName'
  scope: rg
  params:{

  location:location
  loadBalancerName:'nic-1'
  publicIPAddressLoadBalanceName:''
  frontendIPname:''
  
  }
 

}
 */
