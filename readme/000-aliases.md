```
alias k=kubectl
alias kg='k get '
alias kgp='k get pods'
alias kcuc='k config use-context'
alias kcgc='k config get-contexts'
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

alias kcuc='k config use-context'
alias kcgc='k config get-contexts'
alias kcc='k config current-context'

```

Add these aliases to your interactive shell by sourcing the companion script:

```bash
# Add and source in your ~/.bashrc (run these commands)
echo 'source /root/k3s-repository/readme/kubectl-aliases.sh' >> ~/.bashrc
source ~/.bashrc
```

Or copy the alias block into `~/.bashrc` or `~/.zshrc` directly.


```