{
  tenantID: 'tenantID',

  argocd: {
    encryptedData: {
      //##argocdServerAdminPassword=YourSecurePassword
      'admin.password': '$2b$12$3peDOQrx3EVLpfCJ.lRQQOSVNBiyjbJ0ofT79qrsdJvU9eTBG.mFm',
      'admin.passwordMtime': '$(date +%FT%T%Z)'
,     'server.secretkey': '',
      'oidc.azure.clientSecret': '',
    },

    reposPatToken: {
      password: '',
      username: '',
    },
    reposPrivatekey: {
      privateKey: '',

    },
    az1: {
      dev: [
        'stack1',
        'stack2',
      ],
      prd: [
        'stack1',
        'stack2',
      ],
    },
    az2: {
      dev: [
        'stack1',
        'stack2',
      ],
      prd: [
        'stack1',
        'stack2',
      ],
    },
  },

  subscriptions: {
    azure: {
      dev: {
        az1: 'subscription-id-dev-az1-dm',
        az2: 'subscription-id-dev-az2-dm',
      },
      prd: {
        az1: 'subscription-id-prd-az1-dm',
        az2: 'subscription-id-prd-az2-dm',
      },
    },
  },

  //# Access HTTPS repositories link using reposPatToken ##
  gitrepos: {
    #kubeApplicationsState: 'git@github.com:belajarpowershell/k3s-repository.git',
    kubeApplicationsState: 'https://github.com/belajarpowershell/k3s-repository.git'
  },

  //# Access ssh repositories link using reposPrivatekey ##
  gitrepossshkey: {
    #kubeApplicationsState: 'git@github.com:belajarpowershell/k3s-repository.git',
    kubeApplicationsState: 'https://github.com/belajarpowershell/k3s-repository.git'    
  },

  servicePrincipals: import 'servicePrincipals.json',


  loganalyticsWorkspace: {
    dev: {
      az1: 'az1-loganalyticsWorkspace',
      az2: 'az2-loganalyticsWorkspace',
    },
    prd: {
      az1: 'az1-loganalyticsWorkspace',
      az2: 'az2-loganalyticsWorkspace',
    },
  }
}
