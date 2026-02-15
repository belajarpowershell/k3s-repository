# Kubectl aliases — source this from ~/.bashrc or ~/.zshrc
# Usage: source /root/k3s-repository/readme/kubectl-aliases.sh

alias k=kubectl
alias kgp='k get pods'
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

# Preferred context aliases
alias kcuc='k config use-context'
alias kcgc='k config get-contexts'
alias kcc='k config current-context'
