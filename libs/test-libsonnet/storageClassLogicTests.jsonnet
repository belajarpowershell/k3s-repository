## Example showing how to run tests on the implemented code.
## not sure if this is working, to ensure the tests results are printed out for confirmation
##### test using jsonnet storageClassLogicTests.jsonnet 
local storageClassLogic = import 'storageClassLogic.libsonnet';

local k3s_multi = {
  preferred_storageclass: 'longhorn-one-replica',
  type: 'k3s'
};

local k3s_single = {
  preferred_storageclass: 'local-path',
  type: 'k3s'
};

local k3s_no_preference = {
  type: 'k3s'
};

local aks = {
  type: 'aks'
};

local aks_hci = {
  type: 'hci'
};

local other = {
  type: 'other'
};

{
  assert storageClassLogic.GetStorageClassForCluster(k3s_multi) == 'longhorn-one-replica' : 'k3s_multi',
  assert storageClassLogic.GetStorageClassForCluster(k3s_single) == 'local-path' : 'k3s_single',
  assert storageClassLogic.GetStorageClassForCluster(aks) == 'managed-premium' : 'aks',
  assert storageClassLogic.GetStorageClassForCluster(aks_hci) == 'hci-linux': 'aks-hci',
  assert storageClassLogic.GetStorageClassForCluster(k3s_no_preference) == 'longhorn-one-replica' : 'k3s_no_preference',
  assert storageClassLogic.GetStorageClassForCluster(other) == 'unknown' : 'unknown',

  messagge: 'All tests successfull if this message is shown.'
}