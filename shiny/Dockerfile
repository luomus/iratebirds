FROM bitnami/minideb

RUN install_packages \
      gdebi-core \
      lsb-release \
      r-cran-digest \
      r-cran-future \
      r-cran-httr \
      r-cran-magrittr \
      r-cran-r6 \
      r-cran-remotes \
      r-cran-shiny \
      r-cran-yaml \
      wget \
      xtail

RUN  wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" \
  && VERSION=$(cat version.txt) \
  && wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb \
  && gdebi -n ss-latest.deb \
  && rm -f version.txt ss-latest.deb \
  && . /etc/environment \
  && chown shiny:shiny /var/lib/shiny-server

RUN  /usr/lib/R/site-library/littler/examples/install.r shinyalert waiter \
  && R -e "remotes::install_github('stefanwilhelm/ShinyRatingInput', dependencies = FALSE, upgrade = 'never')" \
  && rm -rf /tmp/downloaded_packages

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

CMD ["/usr/bin/shiny-server.sh"]
