#ifndef VK_MESSAGESESSION_H
#define VK_MESSAGESESSION_H

#include <QObject>
#include "vk_global.h"

namespace vk {

class Message;
class Client;
class Reply;
class MessageSessionPrivate;

class MessageSession : public QObject
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(MessageSession)

    Q_PROPERTY(int uid READ uid CONSTANT)
    Q_PROPERTY(Client* client READ client CONSTANT)
public:
    explicit MessageSession(MessageSessionPrivate *data);
    virtual ~MessageSession();
    Client *client() const;
    int uid() const;
public slots:
    virtual Reply *getHistory(int count = 16, int offset = 0) = 0;
    virtual Reply *sendMessage(const QString &body, const QString &subject = QString()) = 0; //FIXME add attachments support
signals:
    void messageAdded(const vk::Message &message);
    void messageDeleted(int id);
    void messageReadStateChanged(int mid, bool isRead);
protected:
    QScopedPointer<MessageSessionPrivate> d_ptr;
};

} // namespace vk

#endif // VK_MESSAGESESSION_H