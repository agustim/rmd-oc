## Emacs, make this -*- mode: sh; -*-

FROM debian:testing

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://localhost" \
      org.label-schema.vendor="Rmd" \
      maintainer="Noname <noname@noname.com>"

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		ed \
		fonts-texgyre \
		less \
		locales \
		vim-tiny \
		wget \
	&& rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
        && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default \
        && echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/90local-no-recommends

ENV R_BASE_VERSION 4.0.3

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update \
        && apt-get install -t unstable -y --no-install-recommends \
                gcc-9-base \
                libopenblas0-pthread \
		littler \
                r-cran-littler \
		r-base=${R_BASE_VERSION}-* \
		r-base-dev=${R_BASE_VERSION}-* \
		r-recommended=${R_BASE_VERSION}-* \
	&& ln -s /usr/lib/R/site-library/littler/examples/build.r /usr/local/bin/build.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/check.r /usr/local/bin/check.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installDeps.r /usr/local/bin/installDeps.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installBioc.r /usr/local/bin/installBioc.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                ghostscript \
                lmodern \
                pandoc-citeproc \
                qpdf \
                r-cran-formatr \
                r-cran-ggplot2 \
                r-cran-knitr \
		        r-cran-rmarkdown \
                r-cran-runit \
                r-cran-testthat \
                texinfo \
                texlive-fonts-extra \
                texlive-fonts-recommended \
                texlive-latex-extra \
                texlive-latex-recommended \
                texlive-luatex \
                texlive-plain-generic \
                texlive-science \
                texlive-xetex \
        && install.r binb linl pinp tint \
        && mkdir ~/.R \
        && echo _R_CHECK_FORCE_SUGGESTS_=FALSE > ~/.R/check.Renviron \
        && cd /usr/local/bin \
        && ln -s /usr/lib/R/site-library/littler/examples/render.r .

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                libssl-dev  \libcurl4-openssl-dev

RUN Rscript -e 'install.packages(c("rmarkdown","flexdashboard","plotly","lubridate","htmltools","RColorBrewer","jsonlite","httr"))'

WORKDIR /github/workspace

VOLUME ["/github/workspace"]

ENTRYPOINT [ "/usr/bin/Rscript" ]

CMD ["-e", "rmarkdown::render_site()"]
