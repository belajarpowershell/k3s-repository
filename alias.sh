
# set kubctl aliases
alias k=kubectl
alias kg='k get '
alias kgp='k get pods'
alias kcuc='k config use-context'
alias kcgc='k config get-contexts'
alias kcc='k config current-context'


#Update KUBECONFIG

export KUBECONFIG=$(for YAML in $(find ${HOME}/.kube/clusters -name '*.yaml') ; do echo -n ":${YAML}"; done)

