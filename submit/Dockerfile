FROM bitnami/minideb

ARG PGUSER
ARG PGPASSWORD

RUN  install_packages \
       r-cran-plumber \
       r-cran-rpostgresql \
  && echo "PGHOST='postgres'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGUSER='${PGUSER}'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGPASSWORD='${PGPASSWORD}'" >> /usr/lib/R/etc/Renviron.site

EXPOSE 8000

COPY create_table.R create_table.R

ENTRYPOINT ["R", "-e", "source('create_table.R'); pr <- plumber::plumb(commandArgs()[4]); pr$run(host = '0.0.0.0', port = 8000)"]
