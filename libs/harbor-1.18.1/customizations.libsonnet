{
  Customizations(p):: {
    "expose": {
       "type": "ingress",
       "ingress": {
          "className": "nginx",
          "hosts": {
             "core": "harbor.k8s.lab"
          },
        }
    },
 }
}