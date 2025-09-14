# ismir-home

### This repo is deprecated and no longer hosts ISMIR website. The pull requests on this repo are no longer monitored. Please use the contact forms on ISMIR website ([http://ismir.net/contact](http://ismir.net/contact)) to make any contributions or change requests.###

--- 

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

#### Automated Deployments using Github Actions

This repository is currently configured to build **pull requests** and **commits to master**, and in the latter case, redeploy the build output (the static site) to web hosting.

One can recreate this configuration as follows:

##### Authentication

On the host where the site is going to be uploaded, create an ssh key pair

    ssh-keygen -t ed25519

Add the contents of the pub key (e.g. `.ssh/id_ed25519.pub`) to `.ssh/authorized_keys`

Test that you can log in with this key without a password:

    ssh -i ~/.ssh/id_ed25519 username@localhost

In the Github interface, add the contents of the private key file (`.ssh/id_ed25519`) as an
Actions Secret.
For ISMIR, this would be at https://github.com/organizations/ismir/settings/secrets/actions
You need to be an organisation administrator to view this page.

* Add the private key file as secret named `WEBHOST_PRIVATE_KEY`
* Add the host name of the webserver as a secret named `WEBHOST_HOST`
* Add the username of the account on the webserver as a secret named `WEBHOST_USERNAME`

Add the secrets with "Repository access" to "Selected repositories", and select this repository
from the list.

##### Actions workflow

The main workflow file is `.github/workflows/deploy-ismir-website.yaml`

The workflow has two main steps:

1. Install Ruby and Jekyll, and build the site
2. Copy the site to the webserver using rsync

The site build step is based on publicly available actions at https://jekyllrb.com/docs/continuous-integration/github-actions/ and https://github.com/actions/starter-workflows/blob/b1df8a/pages/jekyll.yml

The site copy step uses the [rsync-deployments-action](https://github.com/marketplace/actions/rsync-deployments-action). This step reads the webserver username, host, and private key from
the secrets set up in the previous step.

The action is configured to run when a push is made to the `master` branch (either when a pull
request is merged, or a direct push). A list of historical runs of this action can be
seen on the [actions page](https://github.com/ismir/ismir-home/actions).
The action can be manually triggered by viewing the workflow and clicking the ["Run workflow"](https://github.com/ismir/ismir-home/actions/workflows/deploy-ismir-website.yaml) button.

## WTFs

Here's a shortlist of weird things that have happened in the past that may serve as useful breadcrumbs, should they show up in the future:

* Only _some_ pages in a collection aren't available: Check the folder permissions on the server. In the past they've been set to 775, rather than 755, and this won't work; rsync will update files, but won't fix these wonky settings.

* Some links are `html`, other are `mypage/`: this is a permalinks issue, look into `collections`, which provide permalinks for free in exchange for a little upfront work. 

* Datasets table goes missing: Check upstream, it depends on the mir-datasets repository to serve this correctly.
