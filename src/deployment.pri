defineTest(qtcAddDeployment) {
for(deploymentfolder, DEPLOYMENTFOLDERS) {
    item = item$${deploymentfolder}
    itemsources = $${item}.sources
    $$itemsources = $$eval($${deploymentfolder}.source)
    itempath = $${item}.path
    $$itempath= $$eval($${deploymentfolder}.target)
    export($$itemsources)
    export($$itempath)
    DEPLOYMENT += $$item
}

MAINPROFILEPWD = $$PWD

unix {
    desktopfile.path = /usr/share/applications
    copyCommand =
    for(deploymentfolder, DEPLOYMENTFOLDERS) {
        source = $$MAINPROFILEPWD/$$eval($${deploymentfolder}.source)
        source = $$replace(source, \\\\, /)
        macx {
            target = $$OUT_PWD/$${TARGET}.app/Contents/Resources/$$eval($${deploymentfolder}.target)
        } else {
            target = $$OUT_PWD/$$eval($${deploymentfolder}.target)
        }
        target = $$replace(target, \\\\, /)
        sourcePathSegments = $$split(source, /)
        targetFullPath = $$target/$$last(sourcePathSegments)
        !isEqual(source,$$targetFullPath) {
            !isEmpty(copyCommand):copyCommand += &&
            copyCommand += $(MKDIR) \"$$target\"
            copyCommand += && $(COPY_DIR) \"$$source\" \"$$target\"
        }
    }
    !isEmpty(copyCommand) {
        copyCommand = @echo Copying application data... && $$copyCommand
        copydeploymentfolders.commands = $$copyCommand
        first.depends = $(first) copydeploymentfolders
        export(first.depends)
        export(copydeploymentfolders.commands)
        QMAKE_EXTRA_TARGETS += first copydeploymentfolders
    }

    installPrefix = /usr

    for(deploymentfolder, DEPLOYMENTFOLDERS) {
        item = item$${deploymentfolder}
        itemfiles = $${item}.files
        $$itemfiles = $$eval($${deploymentfolder}.source)
        itempath = $${item}.path
        $$itempath = $${installPrefix}/$$eval($${deploymentfolder}.target)
        export($$itemfiles)
        export($$itempath)
        INSTALLS += $$item
    }
    contains(MEEGO_EDITION,harmattan) {
        installPrefix = /opt/$${TARGET}
        desktopfile.files = $${TARGET}.desktop
        desktopfile.path = /usr/share/applications
        icon.files = ../data/icon-l-$${TARGET}.png
        icon.path = $${installPrefix}/share/icons/
        splash.files = ../data/$${TARGET}-splash.jpg
        splash.path = $${installPrefix}/share/data
        export(splash.files)
        export(splash.path)
        INSTALLS += splash
    } else:exists("/usr/include/sailfishapp/sailfishapp.h") {
        desktopfile.files = $${TARGET}.desktop
        desktopfile.path = /usr/share/applications
        icon86.files += ../data/icons/86x86/$${TARGET}.png
        icon86.path = /usr/share/icons/hicolor/86x86/apps
        icon108.files += ../data/icons/108x108/$${TARGET}.png
        icon108.path = /usr/share/icons/hicolor/108x108/apps
        icon128.files += ../data/icons/128x128/$${TARGET}.png
        icon128.path = /usr/share/icons/hicolor/128x128/apps
        icon172.files += ../data/icons/172x172/$${TARGET}.png
        icon172.path = /usr/share/icons/hicolor/172x172/apps
    }

    target.path = $${installPrefix}/bin
    export(icon86.files)
    export(icon108.files)
    export(icon128.files)
    export(icon172.files)
    export(icon86.path)
    export(icon108.path)
    export(icon128.path)
    export(icon172.path)
    export(desktopfile.files)
    export(desktopfile.path)
    export(target.path)
    INSTALLS += desktopfile icon86 icon108 icon128 icon172 target
}

export (ICON)
export (INSTALLS)
export (DEPLOYMENT)
export (TARGET.EPOCHEAPSIZE)
export (TARGET.CAPABILITY)
export (LIBS)
export (QMAKE_EXTRA_TARGETS)
}
