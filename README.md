# Tiny Data

This repository contains data used to manage applications on different Operating Systems.

It's currently used by the ([Tiny Puppet (tp)](https://github.com/example42/puppet-tp) module as default backend where is stored the application informations.

## Data files

Each supported application has a sub directory in ```data/``` which contains: 

- the ```hiera.yaml``` file which describes the hierarchy to use to lookup for the relevant application data.

- the yaml files where data is stored according to the defined hierarchy.

A basic ```hiera.yaml``` is like this:

```
---
 :hierarchy:
   - "%{title}/osfamily/%{osfamily}"
   - "%{title}/default"
   - default
```

so the lookup is done, if ```$title == 'mariadb'```  and ```$facts['os']['family'] == 'RedHat'``` in these files:

    tinydata/data/mariadb/osfamily/RedHat.yaml
    tinydata/data/mariadb/default.yaml
    tinydata/data/default.yaml

The last file contains general defaults for every application, if a setting is specified in an higher level file, it will override the default.
For example what's set in tinydata/data/mariadb/osfamily/RedHat.yaml will override the default in tinydata/data/default.yaml (on RedHat derivatives).

## Data format

For each application a settings hash is stored in the yaml files.

Check the [reference app](data/reference/default.yaml) tinyata for the official reference on the settings and how they are used.
Settings marked as v3 are used by tp module up to version 4, where they are still supported but start to be deprecated.
Settings marked as v4 are used by tp module 4 and above (a tech preview is available from tp 3.8.0).

## Create data for a new application

To create tinydata for a new application is enough to create a new directory in ```data/``` with the name of the application and then:
- add the ```hiera.yaml``` where you configure the hierarchy to follow.
- add at least a ```default.yaml``` (or whatever matches your default file in hiera.yaml) with the settings for the application.

The recommended approach is to use the [moduledata_clone.sh](scripts/moduledata_clone.sh) script to generate a new app data directory based on an existing one.

Usage is as follows:

    scripts/moduledata_clone.sh <sourceapp> <newapp>

You can and should use one of the sample apps templates with predefined and updated tinydata to have a good starting point:

    scripts/moduledata_clone.sh sample <newapp>

## Update policy

Software evolves and things change.
Our committment is to keep Tiny Data as updated as possible, so whenever new references to new versions (for example in repos url) are available, they will be updated.

If data for some Operating Systems is incorrect (and it is) we will update it without caring about possible backwards incompatibilities on existing setups: the driving principle is to have the correct data for each version of each supported operating system and application.

We recommend to refer to a specific version on this module in your Puppetfile and update it after proper checks on the eventual changes introduced in data related to the application you managing via Tiny Puppet.
