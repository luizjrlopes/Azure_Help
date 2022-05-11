@description('Virtual machine size (has to be at least the size of Standard_A3 to support 2 NICs)')
param virtualMachineName string

@description('Virtual machine size (has to be at least the size of Standard_A3 to support 2 NICs)')
param virtualMachineSize string = 'Standard_DS1_v2'

@description('Default Admin username')
param adminUsername string

@description('Default Admin password')
@secure()
param adminPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Placa de rede.')
param nicId string

@description('Placa de rede.')
param sku string




resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: virtualMachineName
  location: location
  properties: {
   
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
     
    }
    
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: sku
        version: 'latest'
      }
      osDisk: {
        
        createOption: 'FromImage'
        managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
       
        }
  
      }
      dataDisks: [
        /*
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
        */
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: nicId
        }
      
      ]
    }
  
  }
}
