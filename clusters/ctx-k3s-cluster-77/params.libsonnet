local globals = import '../../../../../libs/globals.libsonnet';

(import 'cluster.libsonnet') + {

  local servicePrincipalClientId = globals.servicePrincipals[$.countryFactory][$.environment].clientID,

  certManager: {
    clientID: servicePrincipalClientId,
    resourceGroupName: $.dnsResourceGroup,
    subscriptionID: $.subscriptionId,
    zoneName: $.environment + '.' + $.countryFactory + '.skf.io',
    keyVault: $.keyVaultName,
  },
  externalDns: {
    resourceGroup: $.dnsResourceGroup,
    tenantID: globals.tenantID,
    subscriptionId: $.subscriptionId,
    aadClientId: servicePrincipalClientId,
    keyVault: $.keyVaultName,
  },
  velero: {
    resourceGroup: $.veleroResourceGroup,
    storageAccount: $.backupstorageAccount,
    keyVault: $.keyVaultName,
    subscriptionId: $.subscriptionId,
    prefix: $.name,
  },

  additionalContainerRegistries: [
  ],
  metallb:{
    addresses: '10.170.45.210-10.170.45.224'
  },
}

