FROM euleros:2.2 AS installer

RUN groupadd dinstall -g 2001 && \
    useradd -G dinstall -m -d /home/dmdba -s /bin/bash -u 2001 dmdba && \
    chmod 777 /tmp && \
    chown -R root:root /etc/sudo.conf /usr/libexec/sudoers.so /etc/sudoers /etc/sudoers.d
COPY DMInstall.bin /mnt/DMInstall.bin
COPY setup.xml /tmp/setup.xml
RUN sudo -u dmdba /mnt/DMInstall.bin -q /tmp/setup.xml

FROM euleros:2.2 
RUN groupadd dinstall -g 2001 && \
    useradd -G dinstall -m -d /home/dmdba -s /bin/bash -u 2001 dmdba && \
    chmod 777 /tmp && \
    chown -R root:root /etc/sudo.conf /usr/libexec/sudoers.so /etc/sudoers /etc/sudoers.d
COPY --from=installer /home/dmdba/ /home/dmdba/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER root
EXPOSE 5236
ENTRYPOINT [ "/entrypoint.sh" ]
