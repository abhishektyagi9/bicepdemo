@description('Application Name')
@maxLength(30)
param applicationName string
@description('Location for all resources.')
param location string
var cosmosAccountName = toLower(applicationName)
resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: cosmosAccountName
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}

output storageEndpoint object = cosmosAccount
