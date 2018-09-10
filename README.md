# docker-nodejs-dev

It's a docker file for quickly building node apps.

You can create a Dockerfile FROM this like the following:

```
FROM optimized/docker-nodejs-dev
ENV HOST 0.0.0.0
ENV PORT 4000
EXPOSE 4000
CMD npm run server
```
