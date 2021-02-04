#!/bin/sh

az vm image list-publishers -l eastus --query "[?contains(name, 'Canonical')]"
az vm image list-offers -l eastus --publisher Canonical -o table
az vm image list-skus -l eastus --publisher Canonical --offer 0001-com-ubuntu-server-focal -o table
