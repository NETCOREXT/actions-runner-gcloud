FROM summerwind/actions-runner:latest as base

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN sudo apt-get update && sudo apt-get install -y google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin kubectl
ENV CREDENTIALS_JSON=
RUN mkdir -p $HOME/.config/gcloud
RUN export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/application_default_credentials.json
RUN if [ ! -z "$CREDENTIALS_JSON" ]; then echo $CREDENTIALS_JSON > $GOOGLE_APPLICATION_CREDENTIALS; fi
RUN if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"; fi
RUN kubectl version --client --output=yaml

FROM base as runner

USER runner

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["entrypoint.sh"]
