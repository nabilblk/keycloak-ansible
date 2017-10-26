## Installation des roles externe
*
ansible-galaxy install -r roles/roles_requirements.yml --roles-path=roles/


>> Two additional command :

```
kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin
kcadm.sh update realms/master -s sslRequired=NONE
```

>> Commande pour lancer le play :

```
ansible-playbook -i inventories/production/hosts  plays/keycloak.install/keycloak_install.yml --private-key=/Users/nabil/Downloads/keycloak.pem -su --su-user=ec2-user -u ec2-user
```
