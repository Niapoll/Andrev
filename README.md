# 🤖🟢 **Andrev** <br/> Docker image for **And**roid application **rev**erse engineering


## 🛠️ Included Tools
[Android SDK](https://developer.android.com/) - Tools for developing and building Android applications; \
[Apktool](https://ibotpeaches.github.io/Apktool/) - Tool for reverse engineering Android apk files; \
[Backsmali](https://github.com/JesusFreke/smali) - Assembler/disassembler for the dex format used by dalvik, Android's Java VM implementation; \
[Jadx](https://github.com/skylot/jadx) - Dex to Java decompiler; \
[ReFlutter](https://github.com/Impact-I/reFlutter) - Framework for reverse engineering Flutter apps using the patched version of the Flutter library which is already compiled and ready for app repacking; \
[Frida](https://frida.re/) - Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers.


## ⚙️ Build
To build the default container image, use the command:
```bash
docker build -t andrev .
```

You can specify addition build arguments. For example:
```bash
docker build --build-arg JDK_VERSION=11 --build-arg ANDROID_VERSION=29 -t andrev .
```

> [!NOTE]
> The list of all available arguments below.


### Build arguments
| Name                | Description                      |
| ------------------- | -------------------------------- |
| JDK_VERSION         | Version of Open JDK              |
| ANDROID_VERSION     | Version of Android SDK           |
| BUILD_TOOLS_VERSION | Version of Android Build tools   |
| APKTOOL_VERSION     | Version of Apktool               |
| BACKSMALI_VERSION   | Version of Backsmali             |
| JADX_VERSION        | Version of Jadx                  |
| REFLUTTER_VERSION   | Version of ReFlutter             |
| FRIDA_VERSION       | Version of Frida                 |
| FRIDA_ARCH          | Architecture of system for Frida |


## 🏃 Run
To run the default container from image, use the command:
```bash
docker run --name andrev -ti andrev
```

You can resolve addresses in your local network. Specify host argument:
```bash
docker run --name andrev --net=host -ti andrev
```

> [!NOTE]
> It's nessary for *ADB*, *Fastboot*, *Frida*, etc.

Also, we can run container in *detached* mode:
```bash
docker run --name andrev --net=host -dti andrev
```

Then to connect to the container, the command can be used:
```bash
docker attach andrev
```
or
```bash
docker exec -ti andrev /bin/bash
```

> [!NOTE]
> **attach** connects to your primary terminal session. When this session stops the container will be stopped also. **exec** creates new secondary terminal session. This session will be automatically closed after closing of primary session.
