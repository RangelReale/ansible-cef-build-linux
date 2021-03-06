# Ansible scripts to build CEF (Chromium Embedded Framework) for Linux

This repository contains scripts to build CEF for Linux in a cloud environment.

Initialy only Azure is supported, but more can be added later.

## Usage (Azure)

Ansible should be installed with the Azure plugin, and configured with a service principal in the ```~/.azure/credentials``` file in the ```default``` section. If the Azure configuration isn't made this way, the upload to blob storage will fail.

Copy ```azure_config_default.yaml``` to ```azure_config.yaml``` and edit its parameters. At least the ```admin_password``` must be set with a password compatible with Azure (mix of lowercase, uppercase, number and symbol).

```
ansible-playbook azure_build.yaml --extra-vars "@azure_config.yaml"
```

This process takes approximately 4:30 hours, 2:30 of it building in a high spec machine, the rest in a medium spec one.

## Process (Azure)

* Provision a VM with medium specs (by default a 4 vcpu with premium SSD) for the setup in a resource group named ```rg-cefbuild-linux```.
* Create, partition and format a separate 250GB managed disk to store the source and compilation, mounting it in ```/cefbuild```.
* Install the build dependencies using ```apt```.
* Download the CEF build scripts and source code, using the ```automate-git.py``` tool.
* Switch to a high spec VM for the compilation phase (by default a 64 vcpu with premium SDD. You need to ask for a quota increase in Azure to use this VM).
* Compile CEF in release and debug modes, also generating the binary distribution.
* Upload the resulting binary distribution to Azure Blob Storage, in the ```sacsweb01``` storage account, container ```fl-cs-web01```.
* Stop the VM without destroying it.

You should destroy the ```rg-cefbuild-linux``` resource group when you confirm everything went smoothly.

## Parameters

* **admin_password**: the password for the ```cefuser``` user of the Linux VM. You can use this password to connect to the machine using SSH.
* **azure_location** [default: eastus]: the Azure datacenter location to use.
* **azure_upload_distrib_blob** [default: true]: whether to upload the generated binary distrib to Azure Blob Storage.
* **azure_vm_size_setup** [default: Standard_DS3_v2]: the vm size to use when setting up the machine and downloading the CEF source code.
* **azure_vm_size_build** [default: Standard_D64s_v3]: the vm size to use when compiling CEF.
* **azure_managed_disk_type** [default: Premium_LRS]: the managed disk type to use on the vm.
* **cef_branch** [default: 4324]: the CEF branch to build
* **cef_gn_defines** [default: is_official_build=true proprietary_codecs=true ffmpeg_branding=Chrome use_sysroot=true use_allocator=none symbol_level=1 is_cfi=false use_thin_lto=false]: the Chromium compile defines. The default enables video playing with ffmpeg.

## Author

Rangel Reale (rangelreale@gmail.com)
