#include "chatsession_p.h"
#include "buddy.h"
#include "client.h"
#include "longpoll.h"
#include <QStringBuilder>

namespace vk {

/*!
 * \brief The ChatSession class
 * Api reference: \link http://vk.com/developers.php?oid=-1&p=Расширенные_методы_API
 */

/*!
 * \brief ChatSession::ChatSession
 * \param contact
 */
ChatSession::ChatSession(Contact *contact) :
    QObject(contact),
    d_ptr(new ChatSessionPrivate(this, contact))
{
    Q_D(ChatSession);
    auto longPoll = d->contact->client()->longPoll();
    connect(longPoll, SIGNAL(messageAdded(vk::Message)),
            this, SIGNAL(messageAdded(vk::Message)));
    connect(longPoll, SIGNAL(messageDeleted(int)),
            this, SIGNAL(messageDeleted(int)));
}

ChatSession::~ChatSession()
{

}


Contact *ChatSession::contact() const
{
    return d_func()->contact;
}

void ChatSession::markMessagesAsRead(QList<int> ids, bool set)
{
    Q_D(ChatSession);
    QString request = set ? "messages.markAsRead"
                          : "messages.markAsNew";
    QVariantMap args;
    args.insert("mids", d->split(ids));
    auto reply = d->contact->client()->request(request, args);
    reply->setProperty("mids", qVariantFromValue(ids));
    reply->setProperty("set", set);

}

QString ChatSession::title() const
{
    return contact()->name();
}

void ChatSession::getHistory(int count, int offset)
{
    Q_D(ChatSession);
    QVariantMap args;
    args.insert("count", count);
    args.insert("offset", offset);
    args.insert("uid", d->contact->id()); //TODO chat_id support!

    auto reply = d->contact->client()->request("messages.getHistory", args);
    connect(reply, SIGNAL(resultReady(QVariant)), SLOT(_q_history_received(QVariant)));
}

void ChatSessionPrivate::_q_history_received(const QVariant &response)
{
    auto list = response.toList();
    Q_UNUSED(list.takeFirst());
    foreach (auto item, list) {
        Message message(item.toMap(), contact->client());
        emit q_func()->messageAdded(message);
    }
}

void ChatSessionPrivate::_q_message_read_state_updated(const QVariant &response)
{
    Q_Q(ChatSession);
    auto reply = qobject_cast<Reply*>(q->sender());
    if (response.toInt() == 1) {
        auto set = reply->property("set").toBool();
        auto ids = reply->property("mids").value<IdList>();
        foreach(int id, ids)
            emit q->messageReadStateChanged(id, set);
    }
}

QString ChatSessionPrivate::split(IdList ids)
{
    QString result;
    if (ids.isEmpty())
        return result;

    result = QString::number(ids.takeFirst());
    foreach (auto id, ids)
        result += QLatin1Literal(",") % QString::number(id);
    return result;
}

} // namespace vk

#include "moc_chatsession.cpp"