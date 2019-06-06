# ismir-home

Jekyll version of the ISMIR Homepage

[![Build Status](https://travis-ci.com/ismir/ismir-home.svg?branch=master)](https://travis-ci.com/ismir/ismir-home)

## Contributing (the simple version)

In most cases, this website can be updated by the following process:

* fork the website
* make one or more edits
* create a pull request

For minor changes, it may be sufficient to edit the website source (of your fork) *directly in your web browser*. Once your pull request has been approved and merged, the changes will propagate to the live website.

That's it! Simple, right!?


## Contributing Upstream

Not all of the content in this website originates from *this* repository, which is a downstream consumer of three information sources:

- [conference-archive](http://github.com/ismir/conference-archive): Collection of publication metadata
- [mir-datasets](http://github.com/ismir/mir-datasets): Collection of MIR datasets
- Individual conference websites


### Publication Metadata

If you notice that any publication metadata is incorrect, either here or over at [Zenodo](http://zenodo.org), please submit corrections to the [conference-archive](http://github.com/ismir/conference-archive) repository, which maintains the source data for all ISMIR publications.

This is doubly true for missing PDFs. If possible, please provide a URL or upload the PDF in the issue so that we can more easily fix things.


### Datasets

If you would like to add to or update the [list of datasets](http://ismir.net/resources/datasets/) found on this website, please submit corrections to the [mir-datasets](http://github.com/ismir/mir-datasets) repository, which maintains the collection provided here.


### Conference Websites

The websites of past conferences are being migrated to individual repositories in the ISMIR GitHub organization. Each is being served as a separate GitHub pages site, mapped to the corresponding subdomain.

If you find any **major** issues with these websites, please identify the appropriate repository and create an issue (or ideally a pull request!) there. Please note, however, that these websites are provided primarily for historical purposes, and are in a state of critical-issue only maintenance, *e.g.* only significant issues may be addressed (and even then...).


## Developing Locally

This website is written with Jekyll for simplified automatic deployment via GitHub pages. If you are only ever pushing to master, congratulations! this will be rather transparent.

This feedback loop is slow, however, and it is recommended that bigger changes are developed and tested locally. There are a few things to be aware of when doing so:

### Running the Jekyll development server

Make sure you've installed the `jekyll` tools. See the [instructions here](). To serve the website locally, you must be **inside** the `docs` folder, along side the `_config.yaml` file:

```bash
$ cd ./docs
$ bundle install; bundle exec jekyll serve;
```

This will not work from the repository root.


### Local configuration

The first pass at developing this site, @ejhumphrey couldn't figure out how to properly use relative URLs in Jekyll across (a) the config file, (b) layout files, and (c) markdown in a way that worked for both local development and as a project site in GitHub, prior to taking over the http://ismir.net domain. This issue is detailed [more completely here](http://github.com/ismir/ismir-home/issues/??).

Until this is fixed more correctly, a temporary solution has been developed where a single field is specified in the site's `_config.yaml`:

```yaml
base_url: /ismir-home
```

When developing locally, set this to an empty string (`""`) for local development. When pushing to master, this should match the repository name (`/ismir-home`).


### Deploying

Once you've built the website and confirmed that it works, you can `scp` the site's output to a remote server.

```bash
scp -vr docs/_site/* username@your.host.com:~/destination/
```

#### Automated Deployments on Travis-CI

This repository is currently configured to build **pull requests** and **commits to master**, and in the latter case, redeploy the build output (the static site) to web hosting. While this now makes redeployments easy, configuration was not exactly straightforward.

One can recreate this configuration as follows:

0. Create a `.travis.yml` file.
    1. If starting from the one in this repository, delete the `env:globals` and the `before_install` routine. We'll overwrite these below.
    2. Otherwise, start from the Jekyll template here: https://jekyllrb.com/docs/continuous-integration/travis-ci/
1. Create an SSH key-pair locally with `ssh-keygen`. Here they are called `id_rsa` (private key) and `id_rsa.pub` (public key)
    1. The public key must be copied to the host, e.g. `ssh-copy-id -p 22 -i id_rsa.pub username@ip.add.ress.here`
    2. The private key must be modified to eliminate the passphrase via `ssh-keygen -p -f id_rsa -N ''`
2. We can now encrypt environment variables that will be used by `./deploy_production.sh`, a shell script that has been made executable (`chmod +x`)
    1. We need to specify two env variables, `DEPLOY_HOST` and `DEPLOY_USER`, to access the host. This can be achieved by supplying this call with the right values from the repository root: `travis encrypt SOMEVAR="secretvalue" --add`
    2. See the instructions here for complete details: https://docs.travis-ci.com/user/encryption-keys
    3. Not that these encrypted values provide an extra layer of obfuscation to the location of the server, and are not strictly necessary – future configurations could provide this info as plaintext.
3. We must encrypt the private key file so that the Travis-CI build context can copy the built website to the host.
    1. The private key is encrypted with the following command, issued from the repository root: `travis encrypt-file id_rsa --add`
    2. This will encrypt the file with a `.enc` suffix, and add an additional command to `before_install`. Add the encrypted file to the repository (NOT THE PRIVATE KEY) and commit both changes.
    3. See the instructions here for complete details: https://docs.travis-ci.com/user/encrypting-files/
4. The `./deploy_production` script takes a path to the private key to use for securely copying data to the host server. One can similarly use this script locally with appropriately configured SSH keys.
    1. Note that `.travis.yml` is configured to only deploy on commits to master.
    2. The ssh-agent must be kick-started before attempting to copy the website to the host.

