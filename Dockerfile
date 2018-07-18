FROM python:2.7
 
ENV ANSIBLE_VERSION 2.5.0
ENV TERRAFORM https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
ENV TERRAFORM_OS https://releases.hashicorp.com/terraform-provider-openstack/1.6.0/terraform-provider-openstack_1.6.0_linux_amd64.zip

RUN set -x && \
  apt-get update && \
  apt-get install unzip && \
  pip install --upgrade pip && \
  pip install ansible==${ANSIBLE_VERSION} python-openstackclient shade && \
  cd && curl ${TERRAFORM} > /tmp/terraform.tmp.zip && \
  unzip /tmp/terraform.tmp.zip -d /usr/local/bin/ && \
  mkdir -p /root/.terraform.d/plugin-cache && \
  curl ${TERRAFORM_OS} > /tmp/terraform_os.tmp.zip && \
  unzip /tmp/terraform_os.tmp.zip -d /root/.terraform.d/plugin-cache  && \
  rm /tmp/terraform* && \
  echo "Done"

COPY terraform.rc /root/.terraformrc
 
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
# ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library
 
WORKDIR /ansible/playbooks
 
ENTRYPOINT ["bash"]
