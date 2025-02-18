# using IB's ubuntu 20.04 image as a proxy for "this broke on WSL 20.04 once"
FROM registry1.dso.mil/ironbank/canonical/ubuntu-pro-stig:20.04 AS base

RUN apt-get update && \
    apt-get install build-essential jq curl file git ruby-full locales vim-tiny --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# install linuxbrew under a new linuxbrew user
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# let's not update everything more than once in this run
ENV HOMEBREW_AUTO_UPDATE_SECS=600

# this one takes a while, let's get it in our docker layer cache
# to speed up local test iterations of our install-each script below
RUN brew install go

# add your local checkout of this repo (homebrew-tools-public) as a tap
WORKDIR /home/linuxbrew
ADD . ./homebrew-tools-public

# trust this local git repo so linuxbrew will do its thing
RUN git config --global --add safe.directory /home/linuxbrew/homebrew-tools-public/./.git

# enter our docker clone of this repo, add the tap, install each formula
WORKDIR /home/linuxbrew/homebrew-tools-public
RUN brew tap bigbang/tools-public .
RUN ./scripts/install-and-test-each-formula.sh