FROM node:22 AS build
RUN wget https://github.com/Brainicism/bgutil-ytdlp-pot-provider/archive/refs/heads/master.zip && unzip master.zip
WORKDIR /bgutil-ytdlp-pot-provider-master/server
RUN npm ci
RUN npx tsc

FROM node:22-slim
WORKDIR /app
COPY --from=build /bgutil-ytdlp-pot-provider-master/server/build /app/build
COPY --from=build /bgutil-ytdlp-pot-provider-master/server/package.json /app/package.json
COPY --from=build /bgutil-ytdlp-pot-provider-master/server/package-lock.json /app/package-lock.json
RUN npm ci --omit=dev

COPY bgutil-ytdlp-pot-provider.sh .
CMD ["/app/bgutil-ytdlp-pot-provider.sh"]
