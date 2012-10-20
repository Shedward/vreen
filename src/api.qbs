import qbs.base 1.0

Product {
    name: "vreen"

    property string versionMajor: '0'
    property string versionMinor: '9'
    property string versionRelease: '90'
    property string version: versionMajor + '.' + versionMinor + '.' + versionRelease

    destination: {
        if (qbs.targetOS === 'windows')
            return "bin";
        else
            return "lib";
    }
    type: ["dynamiclibrary", "installed_content"]

    //cpp.warningLevel: "all"
    cpp.includePaths: [
        "3rdparty",
        "api"
    ]
    cpp.defines: [
        "VK_LIBRARY",
        "K8JSON_INCLUDE_GENERATOR",
        "K8JSON_INCLUDE_COMPLEX_GENERATOR"
    ]
    cpp.cxxFlags: {
        var flags = []
        if (qbs.toolchain !== "msvc") {
            flags.push("-std=c++0x")
        }
        return flags
    }
    cpp.visibility: "hidden"

    files: [
        "api/abstractlistmodel.cpp",
        "api/attachment.cpp",
        "api/audio.cpp",
        "api/audioitem.cpp",
        "api/chatsession.cpp",
        "api/client.cpp",
        "api/commentssession.cpp",
        "api/connection.cpp",
        "api/contact.cpp",
        "api/contentdownloader.cpp",
        "api/dynamicpropertydata.cpp",
        "api/groupchatsession.cpp",
        "api/groupmanager.cpp",
        "api/json.cpp",
        "api/longpoll.cpp",
        "api/message.cpp",
        "api/messagemodel.cpp",
        "api/messagesession.cpp",
        "api/newsfeed.cpp",
        "api/newsitem.cpp",
        "api/photomanager.cpp",
        "api/reply.cpp",
        "api/roster.cpp",
        "api/utils.cpp",
        "api/wallpost.cpp",
        "api/wallsession.cpp",
        "api/dynamicpropertydata_p.h",
        "api/longpoll_p.h",
        "api/roster_p.h",
        "api/client_p.h",
        "api/contact_p.h",
        "api/reply_p.h",
        "api/abstractlistmodel.h",
        "api/attachment.h",
        "api/audio.h",
        "api/audioitem.h",
        "api/chatsession.h",
        "api/client.h",
        "api/commentssession.h",
        "api/connection.h",
        "api/contact.h",
        "api/contentdownloader.h",
        "api/groupchatsession.h",
        "api/groupmanager.h",
        "api/json.h",
        "api/longpoll.h",
        "api/message.h",
        "api/messagemodel.h",
        "api/messagesession.h",
        "api/newsfeed.h",
        "api/newsitem.h",
        "api/photomanager.h",
        "api/reply.h",
        "api/roster.h",
        "api/utils.h",
        "api/vk_global.h",
        "api/wallpost.h",
        "api/wallsession.h"
    ]

    Depends { name: "cpp" }
    Depends { name: "Qt"; submodules: ["core", "network", "gui"] }
    Depends { name: "k8json"}

    Group {
        qbs.installDir: "include/vreen/" + version + "/vreen/private"
        fileTags: ["install"]
        files: [
            "api/dynamicpropertydata_p.h",
            "api/longpoll_p.h",
            "api/roster_p.h",
            "api/client_p.h",
            "api/contact_p.h",
            "api/reply_p.h",
        ]        
    }
    Group {
        qbs.installDir: "include/vreen"
        fileTags: ["install"]
        files: [
            "api/abstractlistmodel.h",
            "api/attachment.h",
            "api/audio.h",
            "api/audioitem.h",
            "api/chatsession.h",
            "api/client.h",
            "api/commentssession.h",
            "api/connection.h",
            "api/contact.h",
            "api/contentdownloader.h",
            "api/groupchatsession.h",
            "api/groupmanager.h",
            "api/json.h",
            "api/longpoll.h",
            "api/message.h",
            "api/messagemodel.h",
            "api/messagesession.h",
            "api/newsfeed.h",
            "api/newsitem.h",
            "api/photomanager.h",
            "api/reply.h",
            "api/roster.h",
            "api/utils.h",
            "api/vk_global.h",
            "api/wallpost.h",
            "api/wallsession.h"
        ]
    }
    ProductModule {
        Depends { name: "cpp" }
        cpp.includePaths: [
            product.buildDirectory + "/include",
            product.buildDirectory + "/include/vreen",
        ]
    }
}
