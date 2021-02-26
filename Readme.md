# Rmd-oc

Build and push, in dockerhub, an image for deploy with Rmarkdown.
# Use

To build Rmarkdown from local directory:

```
docker run -ti --rm --user $(id -u):$(id -g) -v $(pwd):/github/workspace agusti/rmd-oc
```

# bonus track

Install script to download from sugarcrm
```
docker run -ti --rm --user $(id -u):$(id -g) --entrypoint /usr/bin/kreport-dl -v $(pwd):/github/workspace agusti/rmd-oc -h https://mysugarcrm.example.com/ -k 00000000-0000-0000-0000-000000000000 -o myreport.csv -u user -p mypassword
```
