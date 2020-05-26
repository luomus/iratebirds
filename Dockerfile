FROM bitnami/minideb

ARG PGUSER
ARG PGPASSWORD

RUN install_packages \
      r-base-dev \
      r-cran-httr \
      r-cran-rmarkdown \
      r-cran-rpostgresql \
      r-cran-shiny

RUN  /usr/lib/R/site-library/littler/examples/install.r RcppTOML shinyalert waiter \
  && echo "PGHOST='postgres'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGUSER='${PGUSER}'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGPASSWORD='${PGPASSWORD}'" >> /usr/lib/R/etc/Renviron.site \
  && rm -rf /tmp/downloaded_packages

EXPOSE 3838

RUN mkdir app

COPY app /app

CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
