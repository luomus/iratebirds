FROM bitnami/minideb

ARG PGUSER
ARG PGPASSWORD

RUN install_packages \
      gdebi-core \
      lsb-release \
      r-base-dev \
      r-cran-httr \
      r-cran-rmarkdown \
      r-cran-rpostgresql \
      r-cran-shiny \
      wget \
      xtail

RUN  wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" \
  && VERSION=$(cat version.txt) \
  && wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb \
  && gdebi -n ss-latest.deb \
  && rm -f version.txt ss-latest.deb \
  && . /etc/environment \
  && cp -R /usr/lib/R/site-library/shiny/examples/* /srv/shiny-server/ \
  && chown shiny:shiny /var/lib/shiny-server

RUN  /usr/lib/R/site-library/littler/examples/install.r RcppTOML shinyalert waiter \
  && echo "PGHOST='postgres'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGUSER='${PGUSER}'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGPASSWORD='${PGPASSWORD}'" >> /usr/lib/R/etc/Renviron.site \
  && rm -rf /tmp/downloaded_packages

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

CMD ["/usr/bin/shiny-server.sh"]
