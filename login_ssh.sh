az vm user update --resource-group sjg-udacity-demo-resources2 --name sjg-udacity-vm --username azureuser --ssh-key-value az_sjg.pub
ip_address=`az vm show -d -g sjg-udacity-demo-resources2 -n sjg-udacity-vm --query publicIps -o tsv`
ssh -i ~/.ssh/az_sjg azureuser@$ip_address
