// import QtQuick 1.0 // to target Maemo 5
import QtQuick 1.1
import com.vk.api 1.0

Rectangle {
    id: root

    width: 500
    height: 800

    TextEdit {
        id: login

        onLinkActivated: client.connectToHost()

        z: 10
        anchors.centerIn: parent
        text: qsTr("<a href=\"http://vk.com\">Click to login</a>")
        textFormat: TextEdit.RichText
    }

    DialogsModel {
        id: dialogs
        client: client
    }

    Client {
        id: client
        connection: conn
    }

    OAuthConnection {
        id: conn
        clientId: 1865463 //qutIM id
        displayType: OAuthConnection.Popup
    }

    ListView {
        id: chatsViews

        anchors.fill: parent
        scale: 0
        model: dialogs

        header: Text {
            width: parent.width
            height: 50
            text: qsTr("Last dialogs")
            font.bold: true
            font.pointSize: 11
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }

        delegate: Rectangle {
            id: item

            property QtObject contact: incoming ? from : to;

            Component.onCompleted: {
                from.update();
                to.update();
            }

            width: parent.width
            height: 120
            color: index % 2 ? "transparent" : syspal.alternateBase

            Image {
                id: preview

                width: 75
                height: Math.min(sourceSize.height, 75)

                source: contact.photoSource
                fillMode: Image.PreserveAspectFit
                clip: true
                smooth: true

                anchors {
                    left: parent.left
                    leftMargin: 5
                    top: column.top
                }
            }

            Column {
                id: column

                spacing: 2

                anchors {
                    left: preview.right
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 10
                }

                Text {
                    id: titleLabel
                    width: parent.width
                    font.bold: true
                    text: qsTr("%1 ➜ %2 %3").arg(from.name).arg(to.name).arg(chatId ? qsTr("(from chat)") : "")
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                }
                Text {
                    id: descriptionLabel
                    width: parent.width
                    text: body
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                }
            }

            Text {
                id: dateLabel

                color: syspal.dark
                font.pointSize: 7

                anchors {
                    bottom: hr.top
                    bottomMargin: 3
                    left: column.left
                }
                text: {
                    var info = Qt.formatDateTime(date, qsTr("dddd in hh:mm"));
                    if (unread)
                        info += qsTr(", unread");
                    if (Object.keys(attachments).length > 0)
                        info += qsTr(", has attachments")
                    return info;
                }
            }

            Rectangle {
                id: hr
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: syspal.window
            }
        }

        ScrollDecorator {
            flickableItem: parent
        }
    }

    SystemPalette {
        id: syspal
    }

    Connections {
        target: client

        onOnlineChanged: {
            if (client.online) {
                client.roster.sync();
                dialogs.getDialogs(0, 15, 160);
            }
        }
    }

    states: [
        State {
            name: "chatview"
            when: client.online
            PropertyChanges {
                target: login
                scale: 0
            }
            PropertyChanges {
                target: chatsViews
                scale: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "online"
            NumberAnimation { target: chatsViews; property: "scale"; duration: 400; easing.type: Easing.InOutQuad }
            NumberAnimation { target: login; property: "scale"; duration: 400; easing.type: Easing.InOutQuad }
        }
    ]
}
