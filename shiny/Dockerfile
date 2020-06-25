FROM bitnami/minideb

RUN install_packages \
      gdebi-core \
      lsb-release \
      r-base-core \
      r-cran-stringi \
      wget \
      xtail

RUN  wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" \
  && VERSION=$(cat version.txt) \
  && wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb \
  && gdebi -n ss-latest.deb \
  && rm -f version.txt ss-latest.deb \
  && . /etc/environment \
  && chown shiny:shiny /var/lib/shiny-server

RUN  echo "options(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/bionic/latest'))" >> /usr/lib/R/etc/Rprofile.site \
  && R -e "install.packages(c('future', 'httr', 'promises', 'remotes', 'shinyalert', 'shinyjs', 'waiter'))" \
  && R -e "remotes::install_github('stefanwilhelm/ShinyRatingInput', dependencies = FALSE, upgrade = 'never')" \
  && rm -rf /tmp/downloaded_packages

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

CMD ["/usr/bin/shiny-server.sh"]
