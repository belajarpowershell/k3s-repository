
`kube.libsonnet`
Summary

Purpose: A Jsonnet library of Kubernetes resource constructors and helpers to produce valid k8s API objects programmatically. See kube.libsonnet.
Key concepts:
Underscore helpers: fields ending with _ (e.g., env_, ports_, volumes_) are convenient jsonnet-native maps/objects that the library converts into Kubernetes arrays (e.g., env, ports).
Hidden helpers / defaults: constructors expose helper fields (double-colon style) and default behavior for common cases (e.g., Service.target_pod builds selector/ports automatically).
Assertions toggle: _assert:: true can be set to false when importing to skip runtime checks for speed.
Useful utility functions: hyphenate, parseOctal, siToNum, mapToNamedList, objectValues / objectItems, toLower/toUpper.
Principal constructors: Namespace, Service, Pod, PodSpec, Container, ConfigMap, Secret, PersistentVolume, PersistentVolumeClaim, StorageClass, List, PodDisruptionBudget, and many volume helpers (e.g., HostPathVolume, EmptyDirVolume).
How to use: import the library and instantiate resources, overriding fields with jsonnet object merges:
Example:
local kube = import 'libs/kube.libsonnet';
kube.Service('my-svc') { target_pod:: kube.Pod('my-pod') { spec+: { containers_: { app: { image: 'nginx' } } } } }
Use underscore helpers: containers_, env_, ports_ to keep jsonnet-friendly maps.
Notes / gotchas:
Library aims to be jsonnet-friendly; be aware of the underscore-to-array conversion.
Check _assert behavior when debugging (turn on for clearer errors).
Some helpers assume fields exist (e.g., target_pod.metadata.labels) — supply required fields or adjust assertions.


