FROM nvidia/cuda:12.3.1-devel-ubuntu22.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
      && echo $TZ > /etc/timezone

RUN apt-get update -y \
      && apt-get upgrade -y \
      && apt-get install -y curl \
                            wget \
                            vim \
                            git \
                            tmux \
                            htop \
                            jq \
                            gcc \
                            make \
                            build-essential \
                            libssl-dev \
                            libffi-dev \
                            zlib1g-dev \
                            libbz2-dev \
                            libsqlite3-dev \
                            libreadline-dev \
                            llvm \
                            xz-utils \
                            tk-dev \
                            libxml2-dev \
                            libxmlsec1-dev \
                            liblzma-dev \
                            libncurses5-dev \
                            apt-transport-https \
                            ca-certificates \
                            gnupg \
      && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
      && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
      && apt-get update -y \
      && apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
      && pushd ~/.pyenv && src/configure && make -C src && popd \
      && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
      && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
      && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
      && git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv \
      && echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc