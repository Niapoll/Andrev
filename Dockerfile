# Set alpine as base of image
FROM alpine

# Set build arguments
ARG JDK_VERSION=17
ARG ANDROID_VERSION=33
ARG BUILD_TOOLS_VERSION=33.0.0
ARG APKTOOL_VERSION=2.7.0
ARG BACKSMALI_VERSION=2.5.2
ARG JADX_VERSION=1.4.7
# Remark: Alpine uses musl libc
ARG FRIDA_VERSION=16.1.1
ARG FRIDA_ARCH=x86_64-musl

# Set environment variables
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_JAR=$ANDROID_HOME/platforms/android-$ANDROID_VERSION/android.jar
ENV BUILD_TOOLS_PATH=$ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION
ENV PATH=$BUILD_TOOLS_PATH/jadx/bin:$BUILD_TOOLS_PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

# Install requirements
RUN apk add \
    # Shell
    bash \
    # Android SDK
    openjdk$JDK_VERSION \
    libc++ \
    libgcc \
    gcompat \
    curl \
    # Frida
    python3 \
    py3-pip \
    python3-dev \
    gcc \
    musl-dev

# Install last version of Android SDK
RUN mkdir -p "$ANDROID_HOME/cmdline-tools/latest" && \
    curl -Ls "https://dl.google.com/android/repository/`curl -Ls https://developer.android.com/studio | grep -Eo 'commandlinetools-linux-.*_latest\.zip' | head -1`" -o '/commandlinetools-linux.zip' && \
    unzip -q '/commandlinetools-linux.zip' -d "$ANDROID_HOME/tmp" && \
    mv "$ANDROID_HOME/tmp/cmdline-tools/"* "$ANDROID_HOME/cmdline-tools/latest" && \
    rm -rf "$ANDROID_HOME/tmp/" && \
    rm '/commandlinetools-linux.zip'

# Install required build tools and platforms for Android SDK
RUN yes | sdkmanager --licenses && \
    sdkmanager 'platform-tools' && \
    sdkmanager "build-tools;$BUILD_TOOLS_VERSION" "platforms;android-$ANDROID_VERSION"

# Build debug keystore
RUN keytool -genkey -v -keystore '/root/.android/debug.keystore' -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname 'C=US, O=Android, CN=Android Debug'

# Install required Apktool
RUN curl -Ls "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_$APKTOOL_VERSION.jar" -o "$BUILD_TOOLS_PATH/apktool.jar" && \
    curl -Ls 'https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool' -o "$BUILD_TOOLS_PATH/apktool" && \
    chmod +x "$BUILD_TOOLS_PATH/apktool"

# Install required Backsmali
RUN curl -Ls "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-$BACKSMALI_VERSION.jar" -o "$BUILD_TOOLS_PATH/backsmali.jar" && \
    curl -Ls "https://bitbucket.org/JesusFreke/smali/downloads/smali-$BACKSMALI_VERSION.jar" -o "$BUILD_TOOLS_PATH/smali.jar"

# Install required Jadx
RUN curl -Ls "https://github.com/skylot/jadx/releases/download/v$JADX_VERSION/jadx-$JADX_VERSION.zip" -o '/jadx.zip' && \
    unzip -q '/jadx.zip' -d "$BUILD_TOOLS_PATH/jadx" && \
    rm '/jadx.zip'

# Install required Frida
RUN mkdir -p '/frida-core-devkit' && \
    curl -Ls "https://github.com/frida/frida/releases/download/$FRIDA_VERSION/frida-core-devkit-$FRIDA_VERSION-linux-$FRIDA_ARCH.tar.xz" -o '/frida-core-devkit/frida-core-devkit.tar.xz' && \
    tar -Jxf '/frida-core-devkit/frida-core-devkit.tar.xz' -C '/frida-core-devkit' && \
    FRIDA_CORE_DEVKIT='/frida-core-devkit' pip install frida-tools && \
    rm -rf '/frida-core-devkit'

# Start container
ENTRYPOINT ["/bin/bash"]
