Template for a Beamline or Accelerator Domain Repository
========================================================

This is where you will define all IOC instances for the beamline/domain.

The IOC instance will take the form of a subfolder in the iocs folder.
This subfolder will container a `values.yaml`` file with at a minimum the
URI of the generic IOC container image to use e.g.:

```yaml
image: ghcr.io/epics-containers/ioc-adsimdetector-linux-runtime:23.10.1
```

This yaml file may also override any of the settings in the beamline
helm chart's values file. See [values.yaml](beamline/values.yaml)


This defines the Generic IOC image that is used to launch the instance.

In addition  to `values.yaml` there will be a `config` folder which will
be mounted into the Generic IOC at runtime at `/epics/ioc/config``.
This folder will contain the required files to make the generic IOC
into a specific IOC instance.

For the details of the contents of the config folder see the default
[start.sh](./iocs/blxxi-ea-ioc-01/config/start.sh)


How To Copy This Template Project
=================================

This is a template project. You can create your own beamline/domain from this
template by clicking the green "Use this template" button on the
[GitHub page](https://github.com/epics-containers/blxxi-template) and then
choosing `Create a new repository`. You will be asked to specify the name
and GitHub organization for the new repository.

See [GitHub documentation for templates](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

If you don't want to use GitHub, you can create you copy as follows:

- create a new completely blank repository in your preferred git registry
- copy the uri for this new repository
- clone this template repository and replace its remote with the new repository
  uri

  - git clone git@github.com:epics-containers/blxxi-template.git
  - mv blxxi-template `new-repository-name`
  - cd `new-repository-name`
  - git remote set-url origin `paste new repository uri here`
  - git push -u origin main


How To Make a New Unique Beamline or Domain
===========================================

The following steps are required to make a new unique beamline or domain:

- replace the contents of /README.md with the description of the beamline or
  domain
- find all instances of `xxi` or `ixx` and replace the name containing that
  string with the new beamline or domain name. The files will be:

  - `values.yaml` in each of the 3 helm charts in this repository

- update `/environment.sh` so that it sets the correct values for the
  environment variables and loads the appropriate software to install and
  monitor IOCs for the beamline or domain. See below for more details.

DLS USERS
---------
Instead of using this repository as a template, take a look at bl38p here:
https://github.com/epics-containers/bl38p.

Environment.sh
==============

The `environment.sh` file is used to set the environment variables and software
required to interact with the beamline or domain. It will install the
command line tool `ec` from epics-containers-cli and set the environment
variables required to use it. You should set the following up in this file:

environment variables
---------------------

The first section of the script sets up the environment variables.

The first 3 of the below must be set. The rest are optional.

1. `EC_REGISTRY_MAPPING` - This tells ec where to push generic IOC container
  images when building generic IOCs. It is a space separated list of
  `git-registry-domian:container-registry-domain` pairs.
1. `EC_K8S_NAMESPACE` - The namespace of the kubernetes cluster to use for
  deploying to the beamline or domain. If you are not using Kubernetes, you
  can leave this blank and `ec` will deploy to the local docker instance.
1. `EC_DOMAIN_REPO` - The URI this domain repository. This is used by `ec` to
  fetch tagged versions of IOC instances when deploying.
1. `EC_LOG_URL` - A Url with to the centralized logging system for the
  beamline or domain. Leave blank if you don't have one. Insert the string
  {ioc_name} to be replaced with the name of the IOC to log.
1. `EC_CONTAINER_CLI` - override automatic detection of the container cli to
  use. Valid values are `docker` or `podman`. If you are using a different
  container cli, which is compatible with `docker` you can set it here.
1. `EC_DEBUG` - set to `true` to enable debug output from all `ec` commands.

installing `ec`
---------------

The second section of the script installs `ec` from epics-containers-cli. If you
have a python virtual environment set up before running this script, then you '
can leave this section alone.

However it is likely to be dependent on your infrastructure as to how you
ensure that users have access to the `ec` command. Potentially you may choose
to install it in a system wide location.

Configuring the Cluster
-----------------------

The third section of the script configures the cluster to be used by `ec`. If you
are not using a Kubernetes cluster, you can delete this section.

Configuring the cluster will again be an infrastructure specific task. The
example provided is how this is done at DLS where we have a cluster per
beamline.

Essentially this part of script needs to set up your `kubectl` configuration
to enable you to authenticate and connect to the cluster. It could also
set the default namespace to use for deploying to the cluster - but this is
for convenience only and not required by `ec`.
