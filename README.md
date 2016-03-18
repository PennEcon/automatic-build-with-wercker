# Automatically building with wercker

Example repository with instructions on how to set up a Docker container and wercker to automatically build projects.

Sample usages:

1. Make sure your work is reproducible by re-building it every time you make a change to the master branch.
2. Automatically generate figures, build a latex document, and push it to the gh-pages branch every time you make a change.
3. Run your code through, e.g., a memory checker every time you make a change. For example, if you're developing an R package, you can run it by the memory checks that CRAN uses on submissions.

## Set up a docker container

Your docker container includes everything you need to build your project. See [here](https://docs.docker.com/engine/userguide/containers/dockerimages/) for instructions on creating your own docker image. Or, you can use pre-existing docker images from [Docker Hub](https://hub.docker.com). For example, the docker container [rocker/r-devel-ubsan-clang](https://hub.docker.com/r/rocker/r-devel-ubsan-clang/) will run memory checks on your R code, see [here](https://github.com/jtilly/r-clang-ubsan) for an example of how to set this up.

This repository uses a pre-made docker container, `svlentink/texlive-full:latest`, which contains a full `texlive` distribution.

## Set up your repository

Once your docker container is set up, you'll use wercker to run your code remotely in the docker container. You need to include `wercker.yml` in your repository to tell wercker how to run the project. See [here](http://blog.wercker.com/2015/04/02/Introducing-our-docker-stack.html) for an explanation of how this works. See `wercker.yml` in this repository for an example.

## Set up wercker

Once you've created a wercker account and added `wercker.yml` to your repository, you need to visit wercker and add your repository for it to start automatically building. 

## Giving wercker push access to your repository

If you want wercker to produce some output and push it to your repository (usually the `gh-pages` branch), you need to give wercker access to your repository. This is done by generating a personal access token in github. To do this, go to your profile settings, click 'Personal access tokens', generate a new token, and copy the token it gives you somewhere. Then, once you've added your repository in wercker, go to the wercker repository settings, click 'Environment variables', and add the token in under an appropriately descriptive name (in this repository, it is called `GITHUB_TOKEN`.) Make sure you make the environment variable as private. Then, in your build script, (in this repository, `build.sh`), the token will be available as an environmental variable in the bash script. The remote address in the build script is constructed by

```
remote="https://$GITHUB_TOKEN@github.com/$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY.git"
```

Note that `WERCKER_GIT_REPOSITORY` and `WERCKER_GIT_OWNER` are environmental variables available to you by default. Pushing and pulling to the git repository is then done normally, i.e., to make changes to the `gh-pages` branch,

```
git clone $remote
cd $WERCKER_GIT_REPOSITORY
git checkout gh-pages
# ... do what you will here
git config user.email "automatedbuild@wercker.com"
git config user.name "wercker"
git commit -m "My changes"
git push origin gh-pages
```
