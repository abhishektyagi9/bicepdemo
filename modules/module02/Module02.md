[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)

 Create and use Bicep modules
 
 Benefits of Modules:

1. Reusability
  After you've created a module, you can reuse it in multiple Bicep files, even if the files are for different projects or workloads. For example, when you build out     one solution, you might create separate modules for the app components, the database, and the network-related resources. Then, when you start to work on another        project with similar network requirements, you can reuse the relevant module.

2.Encapsulation

Modules help you keep related resource definitions together. For example, when you define an Azure Functions app, you typically deploy the app, a hosting plan for the app, and a storage account for the app's metadata. These three components are defined separately, but they represent a logical grouping of resources, so it might make sense to define them as a module.


3. Composability

After you've created a set of modules, you can compose them together. For example, you might create a module that deploys a virtual network, and another module that deploys a virtual machine. You define parameters and outputs for each module so that you can take the important information from one and send it to the other.

Diagram that shows a template referencing two modules and passing the output from one to the parameter of another.
<img width="322" alt="image" src="https://user-images.githubusercontent.com/24537906/221453424-3ddd0d43-6cfc-4b71-bcc6-cdaa190afe98.png"/>


<img width="322" alt="image" src="https://user-images.githubusercontent.com/24537906/221453525-77e96213-5aa0-4882-8b46-feca52d0c996.png"/>

🤔 Prerequisites
---------------------------------------------------------------------------------------------------------------------------------------------------------

+ Windows 11/10- – The majority of the demos in this tutorial will work on other operating systems but all demos will use Windows 11.
+ Visual Studio Code( If not downloaded down load .[here](https://code.visualstudio.com/)
+ Download Bicep extension in visual studio code [steps](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
+ Azure CLI download and [install](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

---------------------------------------------------------------------------------------------------------------------------------------------------------

## :dart: Objectives
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Walk through the process of creating a module in bicep file.
2. Demonstrate how to define and use templates.
3. Deploy resources using the Azure CLI or Azure Portal.

---------------------------------------------------------------------------------------------------------------------------------------------------------
**Step 1: Walk through the process of creating a Bicep file**
---------------------------------------------------------------------------------------------------------------------------------------------------------

**Add an App Service plan and app to your Bicep template
**

Create a new folder called modules in the same folder where you created your main.bicep file in previous module. In the modules folder, create a file called app.bicep. Save the file.

```
@description('The Azure region into which the resources should be deployed.')
param location string

@description('The name of the App Service app.')
param appServiceAppName string

@description('The name of the App Service plan.')
param appServicePlanName string

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-01-15' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

@description('The default host name of the App Service app.')
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
```




**Step 2: Add the module to your Bicep template.** 
---------------------------------------------------------------------------------------------------------------------------------------------------------
1. Open the main.bicep file.

2. Add the following parameters and variable to the file:

**Add the following parameters and variable to the file:**
```
@description('The Azure region into which the resources should be deployed.')
param location string = 'westus3'

@description('The name of the App Service app.')
param appServiceAppName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'F1'

var appServicePlanName = 'toy-product-launch-plan'

```

******Complete the module declaration:** 
```
module app 'modules/app.bicep' = {
  name: 'toy-launch-app'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}
```

**At the bottom of the file, define an output:**

```
@description('The host name to use to access the website.')
output websiteHostName string = app.outputs.appServiceAppHostName

```

Step 3: Create a module for the content delivery network
---------------------------------------------------------------------------------------------------------------------------------------------------------
1. In the modules folder, create a file called cdn.bicep. Save the file.
2. Add the following content into the cdn.bicep file:

```
@description('The host name (address) of the origin server.')
param originHostName string

@description('The name of the CDN profile.')
param profileName string = 'cdn-${uniqueString(resourceGroup().id)}'

@description('The name of the CDN endpoint')
param endpointName string = 'endpoint-${uniqueString(resourceGroup().id)}'

@description('Indicates whether the CDN endpoint requires HTTPS connections.')
param httpsOnly bool

var originName = 'my-origin'

resource cdnProfile 'Microsoft.Cdn/profiles@2020-09-01' = {
  name: profileName
  location: 'global'
  sku: {
    name: 'Standard_Microsoft'
  }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
  parent: cdnProfile
  name: endpointName
  location: 'global'
  properties: {
    originHostHeader: originHostName
    isHttpAllowed: !httpsOnly
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: originName
        properties: {
          hostName: originHostName
        }
      }
    ]
  }
}

@description('The host name of the CDN endpoint.')
output endpointHostName string = endpoint.properties.hostName
```

**Add the modules to the main Bicep template**

1. Open the main.bicep file.
2. Below the appServicePlanSkuName parameter, add the following parameter:

```
@description('Indicates whether a CDN should be deployed.')
param deployCdn bool = true
```

3. Below the app module definition, define the cdn module:

```
module cdn 'modules/cdn.bicep' = if (deployCdn) {
  name: 'toy-launch-cdn'
  params: {
    httpsOnly: true
    originHostName: app.outputs.appServiceAppHostName
  }
}
```

4. Update the host name output so that it selects the correct host name. When a CDN is deployed, you want the host name to be that of the CDN endpoint.
```
output websiteHostName string = deployCdn ? cdn.outputs.endpointHostName : app.outputs.appServiceAppHostName
```
Step 4: Deploy the Bicep template to Azure
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Login to azure using Az cli

```
az login
```

2. Create/use exising resource group to create thses resource

```
$groupname='rg-bicepdemo'
$location='westus'
$deploymentname='Appdeployment'
az group create -n $groupname -l $location
```

3. Deploy bicep template  to azure
```
az deployment group create  --name $deploymentname  -g $groupname --template-file .\main.bicep
```

Check resource deployment in azure, login to [Portal](https://portal.azure.com) and find resource group created earlier
![image](https://user-images.githubusercontent.com/24537906/220200734-46959726-44a3-45bc-a36b-b09daee48484.png)


[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)
