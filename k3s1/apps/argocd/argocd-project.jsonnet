local config = import "../../../k3s1/cluster.jsonnet";
local projectlist= import "../../../k3s1/projectlist.jsonnet";

local project = import "../../../libs/argocd/project.jsonnet";

// Generate a list of projects from the config
[
  project(p) for p in projectlist.projects
]
