@description('Application Name')
@maxLength(30)
param applicationName string
@description('The URL for the GitHub repository that contains the project to deploy.')
param location string
param appServicePlanTier string
param appServicePlanInstances int
param branch string
param repositoryUrl string
param cosmosdb object
param  databaseName string
param containerName string
var websiteName = applicationName
var hostingPlanName = applicationName
resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: appServicePlanTier
    capacity: appServicePlanInstances
  }
}
resource website 'Microsoft.Web/sites@2021-03-01' = {
  name: websiteName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'CosmosDb:Account'
          value: cosmosdb.documentEndpoint
        }
        {
          name: 'CosmosDb:DatabaseName'
          value: databaseName
        }
        {
          name: 'CosmosDb:ContainerName'
          value: containerName
        }
      ]
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-03-01' = {
  name: '${website.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
