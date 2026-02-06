
# set kubctl aliases
alias k=kubectl
alias kg='k get '
alias kgp='k get pods'
alias kcu='k config use-context'
alias kcg='k config get-contexts'
alias kcc='k config current-context'

alias kgpa='k get pods -A'


alias kgd='k get deployments'
alias kgs='k get svc'
alias kgn='k get nodes'
alias kd='k describe'
alias kl='k logs'
alias ke='k edit'
alias ka='k apply -f'
alias kdel='k delete -f'
alias kr='k rollout restart'
alias krs='k rollout status deployment'
alias kns='k config set-context --current --namespace'

#Update KUBECONFIG

export KUBECONFIG=$(for YAML in $(find ${HOME}/.kube/clusters -name '*.yaml') ; do echo -n ":${YAML}"; done)

