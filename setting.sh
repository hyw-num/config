sed -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
localedef -c -f UTF-8 -i en_US en_US.UTF-8
