FROM bitnami/minideb

ENV TAXA https://raw.githubusercontent.com/CornellLabofOrnithology/auk/master/data-raw/ebird-taxonomy.csv

RUN  install_packages r-cran-plumber \
  && R -e "saveRDS(subset(read.csv('${TAXA}'), category == 'species')[['species_code']], 'taxa')"

EXPOSE 8000
ENTRYPOINT ["R", "-e", "taxa <- readRDS('taxa'); pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
