QT += quick quickcontrols2 widgets printsupport
greaterThan(QT_MAJOR_VERSION, 5): QT += core5compat

CONFIG += c++1z

HEADERS += applicationdata.h
           #../scintilla/lexilla/src/Lexilla.h
SOURCES += applicationdata.cpp\
           main.cpp
           #../scintilla/lexilla/src/Lexilla.cxx\

ARCH_PATH = x86

android {
    # message("hello android !")

    equals(ANDROID_TARGET_ARCH, arm64-v8a) {
        ARCH_PATH = arm64
    }
    equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
        ARCH_PATH = arm
    }
    equals(ANDROID_TARGET_ARCH, armeabi) {
        ARCH_PATH = arm
    }
    equals(ANDROID_TARGET_ARCH, x86)  {
        ARCH_PATH = x86
    }
    equals(ANDROID_TARGET_ARCH, x86_64)  {
        ARCH_PATH = x64
    }
    equals(ANDROID_TARGET_ARCH, mips)  {
        ARCH_PATH = mips
    }
    equals(ANDROID_TARGET_ARCH, mips64)  {
        ARCH_PATH = mips64
    }
}


INCLUDEPATH += ../scintilla/qt/ScintillaEdit ../scintilla/qt/ScintillaEditBase ../scintilla/include ../scintilla/src ../lexilla/include ../lexilla/src ../lexilla/lexlib ../lexilla/access

LIBS += -L$$OUT_PWD/../scintilla/bin-$${ARCH_PATH}/ -lScintillaEditBase
LIBS += $$PWD/../lexilla/bin/liblexilla.a

RESOURCES += quickscintillademoapp.qrc

#DESTPATH = $$[QT_INSTALL_EXAMPLES]/qml/tutorials/extending-qml/chapter1-basics
#target.path = $$DESTPATH

#qml.files = *.qml
#qml.path = $$DESTPATH

#INSTALLS += target qml

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

ANDROID_ABIS = arm64-v8a
