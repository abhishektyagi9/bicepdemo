@description('Application Name')
@maxLength(30)
param applicationName string = 'to-do-app${uniqueString(resourceGroup().id)}'
@description('Location for all resources.')
param location string = resourceGroup().location
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
@description('App Service Plan\'s pricing tier. Details at https://azure.microsoft.com/pricing/details/app-service/')
param appServicePlanTier string = 'F1'
@minValue(1)
@maxValue(3)
@description('App Service Plan\'s instance count')
param appServicePlanInstances int = 1
param repositoryUrl string = 'https://github.com/Azure-Samples/cosmos-dotnet-core-todo-app.git'
@description('The branch of the GitHub repository to use.')
param branch string = 'main'
param databasename string='tododata'
param containerName string='todocontainers'

module stgModule './storage.bicep' = {
  name: 'cosmosdbdeploy'
  params: {
    applicationName: applicationName
    location:location
  }
}
module appservie './appservice.bicep'={
  name:'appservicemodule'
  params:{
    appServicePlanTier:appServicePlanTier
    location:location
    applicationName:applicationName
    branch:branch
    appServicePlanInstances:appServicePlanInstances
    repositoryUrl:repositoryUrl
    cosmosdb:stgModule.outputs.storageEndpoint
    databaseName:databasename
    containerName:containerName
  }
}
