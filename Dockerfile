FROM hashicorp/terraform:1.3.6

# Add packages mandatories
RUN apk add --no-cache bash nano cdrkit p7zip qemu-img

# Copie image and resize it
ADD image /DATA/image
RUN qemu-img resize /DATA/image/*.img 50G

# Create temp key pair
RUN mkdir -m 700 /root/.ssh
RUN yes '' | ssh-keygen -N '' > /dev/null
RUN echo StrictHostKeyChecking no >> /root/.ssh/config
RUN echo UserKnownHostsFile /dev/null >> /root/.ssh/config

# Copie terraform script
ADD content /DATA/content

# Change workdir
WORKDIR /DATA/content/

# Init terraform directory
RUN terraform init

ENTRYPOINT [ "/bin/bash" ]