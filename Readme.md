# Rmd-oc

Build and push, in dockerhub, an image for deploy with Rmarkdown.
# Use

To build Rmarkdown from local directory:

```
ocker run -ti --rm --user $(id -u):$(id -g) -v $(pwd):/github/workspace agusti/rmd-oc
```


