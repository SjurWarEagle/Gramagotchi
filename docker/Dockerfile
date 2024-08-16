FROM ubuntu:24.04 AS buildstep

ENV GODOT_VERSION=4.3
ENV EXPORT_TEMPLATE=release
ENV EXPORT_TEMPLATE_PATH=${GODOT_VERSION}.stable
ENV EXPORT_PRESET_NAME=Web
ENV EXPORT_FILENAME=index.html

RUN apt update && apt install wget unzip libfontconfig1  -y
RUN mkdir -p /build


RUN wget https://downloads.tuxfamily.org/godotengine/4.3/Godot_v4.3-stable_linux.x86_64.zip --output-document godot.zip \
    && unzip godot.zip -d /build/godot \
    && rm godot.zip

RUN mkdir -v -p ~/.local/share/godot/export_templates/${EXPORT_TEMPLATE_PATH}
RUN wget https://downloads.tuxfamily.org/godotengine/4.3/Godot_v4.3-stable_export_templates.tpz --output-document templates.tpz \
    && unzip templates.tpz \
    && mv -v templates/* ~/.local/share/godot/export_templates/${EXPORT_TEMPLATE_PATH} \
    && rm templates.tpz

#RUN ls -al /root/.local/share/godot/
#RUN ls -al /root/.local/share/godot/export_templates/
#RUN ls -al /root/.local/share/godot/export_templates/4.3.stable/

ADD . /project
RUN mkdir -p /export/
RUN mv /build/godot/Godot* /build/godot/godot.x86_64
#   ${GITHUB_WORKSPACE}/godot.x86_64 --headless --path . --export-${EXPORT_TEMPLATE} ${EXPORT_PRESET_NAME} ${GITHUB_WORKSPACE}/${EXPORT_FOLDER}/${EXPORT_FILENAME}
RUN /build/godot/godot.x86_64 --headless --path /project --export-${EXPORT_TEMPLATE} ${EXPORT_PRESET_NAME} /export/${EXPORT_FILENAME}

FROM nginx:latest AS final-image
COPY --from=buildstep /export /usr/share/nginx/html