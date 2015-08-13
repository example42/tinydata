# Tiny Data

This repository contains data used to manage applications on different Operating Systems.

It's currently used by the ([Tiny Puppet](https://github.com/example42/puppet-tp) module as default backend where is stored the application informations.

## Update policy

Software evolves and things change.
Our committment is to keep Tiny Data as updated as possible, so whenever new references to new vesions (for example in repos url) are available, they will be updated.
If data for some Operating Systems is incorred (and it is) we will update it without caring about possible backwards incompatibilities on existing setups: the driving principle is to have the correct data for each version of each supported operating system and application.

We recommend to make a local fork of this module and update it from this upstream version only with extreme attention. Of course any bug reporting or pull request is welcomed.

## Data structure

Each supported application has a sub directory in ```data/``` which contains: 

- the ```hiera.yaml``` file which describes the hierarchy to use to lookup for the relevant application data.

- the yaml files where data is stored according to the defined hierarchy.

A sample ```hiera.yaml``` is like this:

```
---
 :hierarchy:
   - "%{title}/osfamily/%{osfamily}"
   - "%{title}/default"
   - default
```

so the lookup is done, if ```$title == 'mariadb'```  and ```$::osfamily == 'RedHat'``` in these files:

    tinydata/data/mariadb/osfamily/RedHat.yaml
    tinydata/data/mariadb/default.yaml
    tinydata/data/default.yaml

The last file contains general defaults for every application.



