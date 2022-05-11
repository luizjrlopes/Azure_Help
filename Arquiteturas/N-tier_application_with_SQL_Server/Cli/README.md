# Lab 1 - N-tier_application_with_SQL_Server Cli do Azure

## Roteiro
+ Instalar Cli do Azure no pc local
+ Criar Vnet
+ Criar Subnets
+ Criar arquivo para instalar servidor NGINX nas máquinas virtuais da camada web
+ Criar Máquinas Virtuais camada Web
+ Criar Application Gateway
+ Criar Bastion Host
+ Criar arquivo para instalar servidor NGINX nas máquinas virtuais da camada de negócios
+ Criar Máquinas Virtuais da camada de negócios
+ Criar Load Balance da camada de negócios
+ Criar conta de armazenamento para Máquinas Virtuais da camada de banco de dados
+ Criar Máquinas Virtuais da camada de banco de dados
+ Criar Load Balance da camada de banco de dados
+ Criar DNS Publico
+ criar DDos
## Instalando Cli do Azure no PC Local a partir do powershell

Você também pode instalar a CLI do Azure usando o PowerShell.

### Abra o powershell como administrador

Execute o comando a seguir:


 **powershell** 
  ```powershell
   $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
   ```

Isso baixará e instalará a versão mais recente da CLI do Azure para Windows. Se você já tiver uma versão instalada, o instalador atualizará a versão existente.

Para instalar uma versão específica, substitua o argumento ```-Uri```  pelo ```https://azcliprod.blob.core.windows.net/msi/azure-cli-<version>.msi```, colocando a versão desejada no campo **\<version>**. As versões disponíveis podem ser encontradas nas [notas de versão da CLI do Azure](https://docs.microsoft.com/en-us/cli/azure/release-notes-azure-cli) .

**Obs:** Para utilizar o módulo do CLI após a instalação, feche e abra novamente o powershell como administrador.



## Faça login pelo CLI

Primeiramente faça login em sua conta.
Você continuará na interface do powershell, entretando usando o módulo do cli.

Execute o comando a seguir:

 **cli** 
  ```
   az login --tenant <digite o ID do tenant>
   ```
  **Exemplo** 
  ```
   az login --tenant 11a11a11-1aa1-a11a-11a1-1111a1111a11
   ```


Uma aba de navegador abrirá para que se possa fazer o login em sua conta. faça o login, fecha a tela e volte ao terminal do powershell.

**Obs:** O valor do Tenant ID é encontrado dentro do seu diretório do Azure AD no portal. Se não colocar o tenant ID pode ocorrer erro de autorização na hora de executar os cmdlets.

![image](../../../AZ-104/imagens/imagensTenantIDAAD.png)

**Obs:** Caso apareça uma tela de erro, informando que o comando não existe, basta fechar o powershell, abri-lo novamente e repetir o comando **az login**.

## Criar resource group
Execute o comando a seguir:


 **CLI** 
  ```
   $name = "rg-ntier"
   $location = "westus"

   az group create --name $name --location $location

   ```


## Create a virtual network and a Application Gateway subnet.

Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $location = "westus"
   $vNetName = "vnet-ntier"
   $addressPrefixVNet="10.5.0.0/16"
   $subnetNameApg = "subnet-apg"
   $subnetPrefixApg = "10.5.0.0/24"

   echo "Creating vNet and subnetNameApg"
   az network vnet create --resource-group $resourceGroup `
   --name $vNetName --address-prefix $addressPrefixVNet `
   --location "$location" --subnet-name $subnetNameApg `
   --subnet-prefix $subnetPrefixApg

   ```

## Criando demais subnets

### Criando subnet de gerenciamento 
Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $vNetName = "vnet-ntier"
   $subnetBastionName = "subnet-bastion"
   $subnetPrefixBastion = "10.5.254.0/27"

   echo "Creating subnet BastionHost"
   az network vnet subnet create --address-prefix $subnetPrefixBastion --name $subnetBastionName --resource-group $resourceGroup --vnet-name $vNetName

   ```

### Criando subnet Web 
Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $vNetName = "vnet-ntier"
   $subnetWebName = "subnet-web"
   $subnetPrefixWeb = "10.5.1.0/24"

   echo "Creating subnet Web"
   az network vnet subnet create --address-prefix $subnetPrefixWeb --name $subnetWebName --resource-group $resourceGroup --vnet-name $vNetName

   ```


### Criando subnet Business 
Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $vNetName = "vnet-ntier"
   $subnetBusinessName = "subnet-business"
   $subnetPrefixBusiness = "10.5.2.0/24"

   echo "Creating subnet Bussiness"
   az network vnet subnet create --address-prefix $subnetPrefixBusiness --name $subnetBusinessName --resource-group $resourceGroup --vnet-name $vNetName

   ```

### Criando subnet Data 
Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $vNetName = "vnet-ntier"
   $subnetDataName = "subnet-data"
   $subnetPrefixData = "10.5.3.0/24"

   echo "Creating subnet data"
   az network vnet subnet create --address-prefix $subnetPrefixData --name $subnetDataName --resource-group $resourceGroup --vnet-name $vNetName

   ```




### Criando subnet Active Directory 
Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $vNetName = "vnet-ntier"
   $subnetAdName = "subnet-ad"
   $subnetPrefixAd = "10.5.4.0/24"

   echo "Creating subnet AD"
   az network vnet subnet create --address-prefix $subnetPrefixAd --name $subnetAdName --resource-group $resourceGroup --vnet-name $vNetName

   ```

## Criando NSG's

Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $location = "westus"
   
   echo "Creating nsg's"
   az network nsg create --resource-group $resourceGroup --name "nsgApg" --location "$location"
   az network nsg create --resource-group $resourceGroup --name "nsgWeb" --location "$location"
   az network nsg create --resource-group $resourceGroup --name "nsgBusiness" --location "$location"
   az network nsg create --resource-group $resourceGroup --name "nsgData" --location "$location"
   az network nsg create --resource-group $resourceGroup --name "nsgAD" --location "$location"

   ```

## Criando regras para os NSG's

**CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $location = "westus"
   
   echo "Criando regras para nsgApg"
   az network nsg rule create --resource-group $resourceGroup --nsg-name "nsgApg" --name Allow-HTTPS-All --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 443

    echo "Criando regras para nsgWeb"
   az network nsg rule create --resource-group $resourceGroup --nsg-name "nsgWeb" --name AllowWeb --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix "10.5.0.0/24" --source-port-range "*" --destination-address-prefix "10.5.1.0/24" --destination-port-range 3000


   echo "Criando regras para nsgBusiness"
   az network nsg rule create --resource-group $resourceGroup --nsg-name "nsgBusiness" --name AllowBusiness --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix "10.5.1.0/24" --source-port-range "*" --destination-address-prefix "10.5.2.0/24" --destination-port-range 3002

   echo "Criando regras para nsgData"
   az network nsg rule create --resource-group $resourceGroup --nsg-name "nsgData" --name AllowData --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix "10.5.2.0/24" --source-port-range "*" --destination-address-prefix "10.5.3.0/24" --destination-port-range 3002

   
   ```

## Associando os NSG's às subnets.

Execute o comando a seguir:


 **CLI** 
  ```
   $resourceGroup = "rg-ntier"
   $location = "westus"
   $vNetName = "vnet-ntier"
   $subnetNameApg = "subnet-apg"
   $subnetWebName = "subnet-web"
   $subnetBusinessName = "subnet-business"
   $subnetDataName = "subnet-data"
   $subnetAdName = "subnet-ad"
   $nsgApg = "nsgApg"
   $nsgWeb = "nsgWeb"
   $nsgBusiness = "nsgBusiness"
   $nsgData = "nsgData"
   $nsgAd = "nsgAD"
   
   echo "Associando nsgApg ao subnetNameApg"
   az network vnet subnet update --vnet-name $vNetName --name $subnetNameApg --resource-group $resourceGroup --network-security-group $nsgApg
  
   echo "Associando nsgWeb ao subnetWebName"
   az network vnet subnet update --vnet-name $vNetName --name $subnetWebName --resource-group $resourceGroup --network-security-group $nsgWeb
  
   echo "Associando nsgBusiness ao subnetBusinessName"
   az network vnet subnet update --vnet-name $vNetName --name $subnetBusinessName --resource-group $resourceGroup --network-security-group $nsgBusiness

   echo "Associando nsgData ao subnetDataName"
   az network vnet subnet update --vnet-name $vNetName --name $subnetDataName --resource-group $resourceGroup --network-security-group $nsgData

   echo "Associate nsgAd ao subnetAdName"
   az network vnet subnet update --vnet-name $vNetName --name $subnetAdName --resource-group $resourceGroup --network-security-group $nsgAd


   ```












Execute o comando a seguir:


 **CLI** 
  ```
   $name = "storage-account-name"
   $location = "westus"

   az network vnet create --name
                       --resource-group
                       [--address-prefixes]
                       [--bgp-community]
                       [--ddos-protection {false, true}]
                       [--ddos-protection-plan]
                       [--defer]
                       [--dns-servers]
                       [--edge-zone]
                       [--enable-encryption {false, true}]
                       [--encryption-enforcement-policy {allowUnencrypted, dropUnencrypted}]
                       [--flowtimeout]
                       [--location]
                       [--network-security-group]
                       [--subnet-name]
                       [--subnet-prefixes]
                       [--tags]
                       [--vm-protection {false, true}]

   ```







## Criar uma conta de armazenamento

Uma conta de armazenamento é um recurso do Azure Resource Manager. O Resource Manager é o serviço de implantação e gerenciamento do Azure. Para obter mais informações, consulte [Visão geral do Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) .
 
Cada recurso do Resource Manager, incluindo uma conta de armazenamento do Azure, deve pertencer a um grupo de recursos do Azure. Um grupo de recursos é um contêiner lógico para agrupar seus serviços do Azure. Ao criar uma conta de armazenamento, você tem a opção de criar um novo grupo de recursos ou usar um grupo de recursos existente. Este tutorial mostra como criar um novo grupo de recursos.

Para criar uma conta general-purpose v2 com a CLI do Azure, primeiro crie um novo grupo de recursos chamando o comando **az group create** .

Execute o comando a seguir:


 **CLI** 
  ```
   $name = "storage-account-name"
   $location = "westus"

   az group create --name $name --location $location

   ```

Se você não tiver certeza de qual região especificar para o parâmetro **--location**, poderá acessar uma lista de regiões com suporte para sua assinatura com o comando **az account list-locations.** 

Execute o comando a seguir:


 **CLI** 
  ```
   az account list-locations --query "[].{Region:name}" --out table

   ```

Em seguida, crie uma conta de armazenamento. No exemplo abaixo iremos utilizar uma armazenamento do tipo **StorageV2** com sku **Standard** com armazenamento com redundância geográfica com acesso de leitura **(RA-GRS)** usando o comando **az storage account create** . Lembre-se de que o nome da sua conta de armazenamento deve ser exclusivo no Azure, portanto, substitua o valor da variável **storage-account-name** pelo seu próprio valor exclusivo:

**Obs:** O nome da conta de armazenamento deve ter entre 3 e 24 caracteres e usar apenas números e letras minúsculas.

Execute o comando a seguir:


 **powershell** 
   ```
   $name = "storage-account-name"
   $resourceGroup = "storage-resource-group"
   $location = "westus"
   $sku = "Standard_RAGRS"
   $kind = "StorageV2"

   az storage account create `
   --name $name `
   --resource-group $resourceGroup `
   --location $location `
   --sku $sku `
   --kind $kind

   ```
**Obs:** Note que, caso haja segmentação do comando em múltiplas linhas deve-se colocar no final das linhas um acento craseado. 


## Obter informações de configuração da conta de armazenamento

### Obter o ID do recurso para uma conta de armazenamento

Cada recurso do Azure Resource Manager tem uma ID de recurso associada que o identifica exclusivamente. Certas operações exigem que você forneça o ID do recurso. Você pode obter a ID do recurso para uma conta de armazenamento usando o portal do Azure, PowerShell ou CLI do Azure.


Execute o comando a seguir:


 **powershell** 
   ```
   $name = "storage-account-name"
   $resourceGroup = "resource-group"

   az storage account show `
    --name $name `
    --resource-group $resourceGroup `
    --query id `
    --output tsv

   ```

**saída** 
   ```
/subscriptions/11a11a11-1aa1-a11a-11a1-1111a1111a11/resourceGroups/resource-group/providers/Microsoft.Storage/storageAccounts/storage-account-name
   ```

O valor do ID está representado pelo campo “11a11a11-1aa1-a11a-11a1-1111a1111a11”

### Obtenha o tipo de conta, local ou SKU de replicação para uma conta de armazenamento

O tipo de conta, local e SKU de replicação são algumas das propriedades disponíveis em uma conta de armazenamento. Você pode usar o portal do Azure, PowerShell ou CLI do Azure para exibir esses valores.

Execute o comando a seguir:


 **powershell** 
   ```powershell
   $name = "storage-account-name"
   $resourceGroup = "resource-group"

   az storage account show `
   --name $name `
   --resource-group $resourceGroup `
   --query '[location,sku,kind]' `
   --output tsv

   ```

## Atualizar uma conta de armazenamento

Para fins de verificação iremos criar uma conta **general-purpose v1**.

Execute o comando a seguir:


 **powershell** 
   ```powershell
   $resourceGroup = "<nome do grupo de recurso>"
   $name = "nomeunico"
   $location = "região"
   $skuName = "Standard_RAGRS"
   $kind = "Storage"

   az storage account create `
   --name $name `
   --resource-group $resourceGroup `
   --location $location `
   --sku $skuName `
   --kind $kind

   ```


Após a criação vamos atualizar a conta. Antes vamos verificar se foi criado como  **general-purpose v1**

Execute o comando a seguir:


 **powershell** 
   ```powershell
   $name = "storage-account-name"
   $resourceGroup = "resource-group"

   az storage account show `
   --name $name `
   --resource-group $resourceGroup `
   --query '[location,sku,kind]' `
   --output tsv

   ```


Para atualizar uma conta **general-purpose v1** para uma conta **general-purpose v2** usando a CLI do Azure, é necessário a versão mais recente da CLI do Azure. 

Execute o comando a seguir para atualizar a conta, substituindo o nome do grupo de recursos, o nome da conta de armazenamento e o nível de acesso à conta desejado.


 **powershell** 
   ```
   $name = "storage-account-name"
   $resourceGroup = "resource-group"
   $kind = "StorageV2"
   $accessTier = "Hot/Cool"
   $name = "storage-account-name"


   az storage account update -g $resourceGroup -n $name --set kind=$kind --access-tier=$accessTier

   ```
**Obs:** Também se pode usar flags no lugar dos parâmetros. Por exemplo, invés de usar **--resource-group** se pode colocar **-g**.


Verifique se a mudança de tipo ocorreu.

Execute o comando a seguir:


 **powershell** 
   ```powershell
   $name = "storage-account-name"
   $resourceGroup = "resource-group"

   az storage account show `
   --name $name `
   --resource-group $resourceGroup `
   --query '[location,sku,kind]' `
   --output tsv

   ```

## Deletar uma conta de armazenamento

A exclusão de uma conta de armazenamento exclui a conta inteira, incluindo todos os dados da conta. Certifique-se de fazer backup de todos os dados que deseja salvar antes de excluir a conta.
 
Sob certas circunstâncias, uma conta de armazenamento excluída pode ser recuperada, mas a recuperação não é garantida. Para obter mais informações, consulte  [Recuperar uma conta de armazenamento excluída](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-recover) .
 
Se você tentar excluir uma conta de armazenamento associada a uma máquina virtual do Azure, poderá receber um erro sobre a conta de armazenamento ainda estar em uso. Para obter ajuda para solucionar esse erro, consulte  [Solucionar erros ao excluir contas de armazenamento](https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/storage-resource-deletion-errors) .


Para excluir a conta de armazenamento, execute o comando a seguir:


 **powershell** 
  ```
   $name = "storage-account-name"
   $resourceGroup = "resource-group"

   az storage account delete --name $name --resource-group $resourceGroup
   ```

Caso deseje deletar o grupo de recurso, execute o comando abaixo.

  **powershell** 
  ```
   $name = "resource-group-name"
  
   az group delete --name $name
   ``` 

Quando se deleta o grupo de recursos, todos os recursos contidos nele são deletados. Ao fazer esse processo se certifique que todos o s recursos podem ser excluídos. Caso contrário, exclua-os individualmente.   

#### Revisão

Nesse laboratório, você aprendeu:

+ Instalar Módulo Azure CLI no PC Local
+ Conectar ao Storage Accounts pelo CLI
+ Criar uma conta de armazenamento
+ Obter informações de configuração da conta de armazenamento
+ Atualizar uma conta de armazenamento
+ Deletar uma conta de armazenamento




#### Referências

+ https://docs.microsoft.com/pt-br/azure/storage/common/storage-account-create?tabs=azure-cli&source=docs
+ https://docs.microsoft.com/pt-br/azure/storage/common/storage-account-get-info?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-cli

