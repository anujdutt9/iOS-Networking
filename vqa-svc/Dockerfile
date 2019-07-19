
###########################
# The intermediate image: #
###########################

# https://vsupalov.com/build-docker-image-clone-private-repo-ssh-key/
# https://medium.com/@erika_dike/installing-package-from-a-private-repo-in-your-docker-container-f45b1a4954a2
# https://docs.docker.com/develop/develop-images/multistage-build/

FROM python:3.6 as intermediate

WORKDIR ./

ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN echo "${SSH_PUBLIC_KEY}" > /root/.ssh/id_rsa.pub
RUN chmod 700 /root/.ssh
RUN chmod 644 /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts
RUN cat /root/.ssh/known_hosts

# Create directory for this app, and install requirements:
COPY requirements.txt ./
RUN pip install --no-cache-dir -r ./requirements.txt


####################
# The final image: #
####################

FROM python:3.6

COPY --from=intermediate . .
ADD . .

# Gunicorn configuration variables:
# GUNICORN_WORKER_CLASS: The default worker class (sync) should handle most “normal” types of workloads
# GUNICORN_WORKERS: The number of worker processes for handling requests.
# GUNICORN_THREADS: The number of worker threads for handling requests. Set to 1 when using multiple worker classes
# GUNICORN_BIND: The server host/port to bind.
# GUNICORN_BACKLOG: The maximum number of pending connections.
ENV GUNICORN_WORKER_CLASS=sync
ENV GUNICORN_WORKERS=2
ENV GUNICORN_THREADS=1
ENV GUNICORN_BIND=0.0.0.0:8080
ENV GUNICORN_BACKLOG=4096

ENV APP_MODULE=app:app

# Expose port:
EXPOSE 8080

# Run:
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
