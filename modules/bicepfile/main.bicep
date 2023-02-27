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


resource webApplicationExtension 'Microsoft.Web/sites/extensions@2020-12-01' = {
  parent: webApplication
  name: 'MSDeploy'
  properties: {
    packageUri: 'packageUri'
    dbType: 'None'
    connectionString: 'connectionString'
    setParameters: {
      'IIS Web Application Name': 'name'
    }
  }
}

 

