FROM linuxserver/rdesktop:ubuntu-kde
LABEL maintainer="stainless403"
LABEL description="base on linuxserver/rdesktop:ubuntu-kde"

# platform of the build result. Eg linux/amd64, linux/arm/v7, windows/amd64.
ARG TARGETPLATFORM
# OS component of TARGETPLATFORM
ARG TARGETOS
# architecture component of TARGETPLATFORM. Eg amd64, arm64
ARG TARGETARCH
# variant component of TARGETPLATFORM
ARG TARGETVARIANT
# platform of the node performing the build.
ARG BUILDPLATFORM
# OS component of BUILDPLATFORM
ARG BUILDOS
# architecture component of BUILDPLATFORM
ARG BUILDARCH
# variant component of BUILDPLATFORM
ARG BUILDVARIANT

ENV USER_ID         0
ENV GROUP_ID        0

# apt镜像
# ENV APT_SOURCE_HOST "mirrors.ustc.edu.cn"
# ENV APT_SOURCE_HOST "mirrors.tuna.tsinghua.edu.cn"

# 替换默认源，使用加速镜像
# RUN sed -i "s/archive.ubuntu.com/${APT_SOURCE_HOST}/g" /etc/apt/sources.list

# 更新软件列表
RUN apt-get update -y

# 安装一些必须的软件包
RUN apt-get install -y \
  python3-pip \
  fonts-noto-cjk \
  fonts-noto-color-emoji

RUN export LANG=zh_CN.UTF-8 && locale-gen zh_CN.UTF-8
