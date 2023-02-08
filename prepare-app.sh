#!/bin/bash
. .env.versions

imageVersion=""
verbose=1

echo "ℹ️  将从发布仓库下载源码进行构建"

_content=$(curl -s "https://api.github.com/repos/anyabc/something/releases/latest")

archiveUrl=$(echo $_content | grep -oi 'https://[a-zA-Z0-9./?=_%:-]*MDCx-py-[a-z0-9]\+.[a-z]\+')

if [[ -z "$archiveUrl" ]]; then
  echo "❌ 获取下载链接失败！"
  exit 1
fi

archiveFullName=$(echo $archiveUrl | grep -oi 'MDCx-py-[a-z0-9]\+.[a-z]\+')
archiveExt=$(echo $archiveFullName | grep -oi '[a-z]\+$')
archiveVersion=$(echo $archiveFullName | sed 's/MDCx-py-//g' | sed 's/.[a-z]\+//g')
archivePureName=$(echo $archiveUrl | grep -oi 'MDCx-py-[a-z0-9]\+')

if [[ -n "$verbose" ]]; then
  echo "🔗 下载链接：$archiveUrl"
  echo "ℹ️  压缩包全名：$archiveFullName"
  echo "ℹ️  压缩包文件名：$archivePureName"
  echo "ℹ️  压缩包后缀名：$archiveExt"
fi
echo "ℹ️  已发布版本：$archiveVersion"

appVersion=$archiveVersion

if [[ -n "$archiveUrl" ]]; then
  echo "⏳ 下载文件..."

  archivePath="$archivePureName.rar"
  srcDir=".mdcx_src"
  
  if [[ -n "$verbose" ]]; then
    curl -o $archivePath $archiveUrl -L
  else
    curl -so $archivePath $archiveUrl -L
  fi

  echo "✅ 下载成功"
  echo "⏳ 开始解压..."

  UNRAR_PATH=$(which unrar)
  if [[ -z "$UNRAR_PATH" ]]; then
    echo "❌ 没有unrar命令！"
  else
    rm -rf $srcDir
    # 解压
    unrar x -o+ $archivePath
    # 暂时没发现unrar有类似tar的strip-components这样的参数，
    # 所以解压时会带有项目根目录，需要将目录里的文件复制出来
    mkdir -p $srcDir
    cp -rfp $archivePureName/* $srcDir
    # 删除压缩包
    rm -f $archivePath
    # 删除解压出来的目录
    rm -rf $archivePureName
    echo "✅ 源码已解压到 $srcDir"
  fi
fi

if [[ -n "$archiveUrl" ]]; then
  if [[ -n "$onlyDownload" ]]; then
    exit 0
  fi
fi

if [[ -z "$imageVersion" ]]; then
  imageVersion="$appVersion"
fi

echo "ℹ️  镜像版本为 $imageVersion"

echo "MDCX_IMAGE_VERSION=$imageVersion" >> $GITHUB_OUTPUT
