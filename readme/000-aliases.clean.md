# Kubectl Aliases

A small set of handy `kubectl` aliases you can source in your shell.

## Setup

Add these aliases to your interactive shell by sourcing the companion script:

```bash
echo 'source /root/k3s-repository/readme/kubectl-aliases.sh' >> ~/.bashrc
source ~/.bashrc
```

Or copy the alias block below into your `~/.bashrc` or `~/.zshrc` directly.

## Available Aliases

```bash
alias k=kubectl
alias kg='k get '
alias kgp='k get pods'
alias kcuc='k config use-context'
alias kcgc='k config get-contexts'
alias kcc='k config current-context'
alias kgpa='k get pods -A'
alias kgn='k get nodes'
alias kd='k describe'
alias kl='k logs'
alias ke='k edit'
alias ka='k apply -f'
alias kdel='k delete -f'
alias kr='k rollout restart'
alias krs='k rollout status deployment'
alias kns='k config set-context --current --namespace'
```

See `readme/kubectl-aliases.sh` for the sourced script.
