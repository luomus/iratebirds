FROM bitnami/minideb

ARG PGUSER
ARG PGPASSWORD

ENV TAXA https://raw.githubusercontent.com/CornellLabofOrnithology/auk/master/data-raw/ebird-taxonomy.csv

RUN  install_packages \
       r-cran-plumber \
       r-cran-rpostgresql \
  && echo "PGHOST='postgres'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGUSER='${PGUSER}'" >> /usr/lib/R/etc/Renviron.site \
  && echo "PGPASSWORD='${PGPASSWORD}'" >> /usr/lib/R/etc/Renviron.site \
  && R -e "saveRDS(subset(read.csv('${TAXA}'), category == 'species')[['species_code']], 'taxa')"

COPY create_table.R create_table.R

EXPOSE 8000
ENTRYPOINT ["R", "-e", "source('create_table.R'); taxa <- readRDS('taxa'); pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
