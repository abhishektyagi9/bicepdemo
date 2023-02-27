[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)

 Create and use Bicep modules
 
 Benefits of Modules:

1. Reusability
  After you've created a module, you can reuse it in multiple Bicep files, even if the files are for different projects or workloads. For example, when you build out     one solution, you might create separate modules for the app components, the database, and the network-related resources. Then, when you start to work on another        project with similar network requirements, you can reuse the relevant module.

2.Encapsulation

Modules help you keep related resource definitions together. For example, when you define an Azure Functions app, you typically deploy the app, a hosting plan for the app, and a storage account for the app's metadata. These three components are defined separately, but they represent a logical grouping of resources, so it might make sense to define them as a module.


Composability
After you've created a set of modules, you can compose them together. For example, you might create a module that deploys a virtual network, and another module that deploys a virtual machine. You define parameters and outputs for each module so that you can take the important information from one and send it to the other.

Diagram that shows a template referencing two modules and passing the output from one to the parameter of another.

![image](https://user-images.githubusercontent.com/24537906/221453424-3ddd0d43-6cfc-4b71-bcc6-cdaa190afe98.png)

![image](https://user-images.githubusercontent.com/24537906/221453525-77e96213-5aa0-4882-8b46-feca52d0c996.png)

🤔 Prerequisites
---------------------------------------------------------------------------------------------------------------------------------------------------------

+ Windows 11/10- – The majority of the demos in this tutorial will work on other operating systems but all demos will use Windows 11.
+ Visual Studio Code( If not downloaded down load .[here](https://code.visualstudio.com/)
+ Download Bicep extension in visual studio code [steps](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
+ Azure CLI download and [install](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

---------------------------------------------------------------------------------------------------------------------------------------------------------

## :dart: Objectives
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Walk through the process of creating a Bicep file.
2. Demonstrate how to define parameters, variables, and resources.
3. Deploy resources using the Azure CLI or Azure Portal.

---------------------------------------------------------------------------------------------------------------------------------------------------------
**Step 1: Walk through the process of creating a Bicep file**
---------------------------------------------------------------------------------------------------------------------------------------------------------

**Add an App Service plan and app to your Bicep template
**

+ Open Vs Code editor and Click on to create new file and save it as a bicep file.
<img width="322" alt="image" src="https://user-images.githubusercontent.com/24537906/220178524-b9fc31b1-ce71-4425-beb9-f1f9f2641690.png">

+ Provide bicep file name that will be used for this workshop. Click on save.

In bicep file start typing "res" and select appservice plan or copy below code

```
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'name'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}
```

Next, add start typing webapp or copy following code

```
resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: 'name'
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: 'webServerFarms.id'
  }
}
```




**Step 2: Demonstrate how to define parameters, variables, and resources.** 
---------------------------------------------------------------------------------------------------------------------------------------------------------
A parameter lets you bring in values from outside the template file. For example, if someone is manually deploying the template by using the Azure CLI or Azure PowerShell, they'll be asked to provide values for each parameter. They can also create a parameter file, which lists all of the parameters and values they want to use for the deployment. If the template is deployed from an automated process like a deployment pipeline, the pipeline can provide the parameter values.

A variable is defined and set within the template. Variables let you store important information in one place and refer to it throughout the template without having to copy and paste it.

**Add following parameteres**
```
param location string=resourceGroup().location
param prefix string='webapppublicplam'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param prefixwebapp string='webapp01'

```

**Add following variables into your file**
```

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'
var appserviceplan='${prefix}${uniqueString(resourceGroup().id)}'
var webappname='${prefixwebapp}${uniqueString(resourceGroup().id)}'
```

******Assign variables and Parameters in your Bicep template, The final Bicep file should look something like this** 
```
param location string=resourceGroup().location
param prefix string='webapppublicplam'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param prefixwebapp string='webapp01'

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'
var appserviceplan='${prefix}${uniqueString(resourceGroup().id)}'
var webappname='${prefixwebapp}${uniqueString(resourceGroup().id)}'


//provisioning azure app service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appserviceplan
  location: location
  sku: {
    name: appServicePlanSkuName
    capacity: 1
  }
}
//provisioning azure app service in above app plan
resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: webappname
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}




```


Step 3: Deploying Bicep template to Azure
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
az deployment group create  --name $deploymentname  -g $groupname --template-file .\main.bicep  --parameters environmentType=nonprod
```

Check resource deployment in azure, login to [Portal](https://portal.azure.com) and find resource group created earlier
![image](https://user-images.githubusercontent.com/24537906/220200734-46959726-44a3-45bc-a36b-b09daee48484.png)


[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)
