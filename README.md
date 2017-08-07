Personal Cancer Genome Reporter deployment recipes
==================================================

Introduction
============

Cancer reporting systems require prepopulating several gigabytes of genomic reference data and provisioning all software pieces, docker containers and configuration.

PCGR eases that, `pcgr-deploy` simplifies it futher.

This ansible playbook contains tasks to deploy [PCGR](https://github.com/sigven/pcgr) into Amazon and OpenStack clouds, with HPC-specific tasks added as a module (mainly NFS mounting).

Quickstart
==========

The following lines will install the deployment modules, deploy PCGR and run its built-in example as a validation:

```
conda install -c conda-forge ansible>=2.3
ansible-playbook -i inventory launch_aws.yaml
ssh ubuntu@<AWS INSTANCE>
cd /mnt/work/pcgr-*
./pcgr.py --input_vcf examples/tumor_sample.COAD.vcf.gz --input_cna_segments examples/tumor_sample.COAD.cna.tsv /mnt/work/pcgr-* output tumor_sample.COAD
```

Amazon or OpenStack or HPC?
===========================

This playbook allows for all of them, it has tested on the [Australian NCI supercomputing centre Tenjin private cloud](https://nci.org.au/systems-services/cloud-computing/tenjin/).

The following steps assume that you have a previously configured [aws-cli](https://github.com/aws/aws-cli) and have a recent version of ansible installed (2.3.x). If this is the case, ansible will create 

1. Tweak `ansible/group_vars/vars` according to your current AWS zones and preferences.
2. Run `ansible-playbook -i inventory site.yaml` to deploy and install the EC2 instance linked with the previously created volume.
3. SSH into the newly created instance.

(Optional) Amazon: Saving money with Spot instances
---------------------------------------------------

The following script included in `ansible` queries AWS's spot history and determines if the
instance we are asking for will be available. For instance, running the script with a `0.08AUD`
asking price gives us:

```
python ~/bin/get_spot_duration.py \
	--region ap-southeast-2 \
	--product-description 'Linux/UNIX' \
	--bids c4.large:0.08
```

That is 168 hours uptime at that particular asking price for `ap-southeast-2c`, that 
is ~87% savings at the time of writing this:

```
$ ./get_spot_duration.sh
Duration    Instance Type    Availability Zone
168.0    c4.large    ap-southeast-2c
108.2    c4.large    ap-southeast-2a
15.7    c4.large    ap-southeast-2b
```

Kubernetes
==========

Open ended experiment for now, there are some errors that [need some attention](https://twitter.com/braincode/status/865250048480817152).

FAQ
===

`ERROR: package is not a legal parameter in an Ansible task or handler` is a symptom of a too old ansible version, you need 2.x to deploy this.
