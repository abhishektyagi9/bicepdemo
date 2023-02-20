[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)

🤔 Prerequisites
---------------------------------------------------------------------------------------------------------------------------------------------------------

+ Windows 11/1- – The majority of the demos in this tutorial will work on other operating systems but all demos will use Windows 11.
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

Assign variables and Parameters in your Bicep template

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
var appserviceplanname='${prefix}${uniqueString(resourceGroup().id)}'
var webappname='${prefixwebapp}${uniqueString(resourceGroup().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appserviceplanname
  location: location
  sku: {
    name: appServicePlanSkuName
    capacity: 1
  }
}
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


Step 3: Checking Microsoft hosted Parallel jobs (Free tier)
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Login to https://dev.azure.com to open Azure DevOps. Select your Organization and click on Organization Settings. 

<img width="208" alt="image" src="https://user-images.githubusercontent.com/84516667/201188357-27fcb1c7-3e4b-4daf-868b-333572957d90.png">

2. Select Parallel jobs under pipelines and check if you see Microsoft-hosted Free tier parallel jobs as shown in the screenshot below,

<img width="698" alt="image" src="https://user-images.githubusercontent.com/84516667/201190398-8385360f-9c55-48d5-9d69-e7c2a922bceb.png">

If you don't have a free tier, you can request this grant by submitting a [request](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR63mUWPlq7NEsFZhkyH8jChUMlM3QzdDMFZOMkVBWU5BWFM3SDI2QlRBSC4u)

Note: You can select either Public or Private project depending on your usage.

<img width="924" alt="image" src="https://user-images.githubusercontent.com/84516667/201203577-98b94d93-4034-49c2-8796-c74af07a5092.png">

[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)
