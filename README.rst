Docker Base Image Builds
==========================

This is a work in progress, which is currently functional but very rough
and pretty ugly.

* Separate build images from production images.  Build tools don't belong 
  in production images.

* Use our own compilations of Python and Python packages, not the distro's.

* It isn't possible to mount external resources during `docker build`, only
  copy files to the image from the build context (I think they get copied
  twice in this case).  This makes sense when you want to add files
  directly to the image.  It doesn't make much sense for package
  installation where you want a \*.deb or \*.whl available only for the
  build.  Apparently adding these files to the build actually increases the
  container size, because ADD creates a new layer, and although removing
  the file in a later step hides the file, it is still in the earlier
  layer.  So some of the build process is handled by doing `docker run`
  with a volume mount and then `docker commit`.  This might be a bad
  optimization, because it complicates the build process.  It also does not
  do caching like `docker build`, so these steps will always be executed.

* Docker allows some parameterization of the build using build-time
  variables, but for whatever reason, it doesn't allow variables in the
  `FROM` statement, which means we have to either put ourselves at the
  mercy of the distro and docker hub with `FROM debian:latest` or hard-code
  a release like `FROM debian:jessie` in our Dockerfiles, then manually
  modify all our images when we want to change the base image.  No thanks.

  Also, it's nice to be able to factor out some bits of the Dockerfile
  that apply to multiple images.

  So we use m4 to generate Dockerfiles before running `docker build`.


Ultimately, we may have compelling reason to just use straight Dockerfiles.
Or switch to an alternative build system (maybe HashiCorp's Packer_).  Or
create our own.  Docker has a lot of momentum, and currently has the most
support (ECS), but it may not be the right match long-term.  We may at some
point reevaluate other container technologies like rkt_ and nix_.

.. _Packer: https://www.packer.io/
.. _rkt: https://coreos.com/rkt/docs/latest/
.. _nix: http://nixos.org/

Images
"""""""

debbase
-------

Base image, adds `aptinstall` script, a wrapper around `apt-get install`,
and installs libraries required by python.

pybuild
--------

Build image.  When run, this image downloads and compiles specified version
of python, then creates a \*.deb package.

python
-------

Base python image, with a fresh pyenv at `/venv`.

wheelbuild
----------

Image for building wheels.

Scripts
""""""""

The build scripts are in `build/`

debbase.sh
----------

Usage::

    build/debbase.sh [debian release]

The builds the **debbase** and **pybuild** images.  Debian release defaults to jessie.

buildpython.sh
--------------

Usage::

    build/buildpython.sh [debian release] [python version] [pkg release]

This runs the **pybuild** image to create a python \*.deb.  Pkg release is an
internal release number, which defaults to 1.

python.sh
----------

Usage::

    build/python.sh [debian release] [python version] [pkg release]

This builds the **python** and **wheelbuild** images.
