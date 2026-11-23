#pragma once

#include "settings/rootnode.hpp"
#include "settings/singleton.hpp"
#include "common.hpp"

namespace hel::shell::state {

class PStateRoot : public settings::RootNode {
    STATE_NODE_NO_CTOR(PStateRoot, settings::RootNode)
    QML_ANONYMOUS

    STATE_GLOBAL_PROPERTY(QString, wallpaperPath, {})
    STATE_GLOBAL_PROPERTY(QString, barMode, {})
    STATE_GLOBAL_PROPERTY(bool, doNotDisturb, false)
    STATE_GLOBAL_PROPERTY(bool, inhibitIdle, false)
    STATE_GLOBAL_PROPERTY(qreal, inhibitingIdleSince, -1)

public:
    explicit PStateRoot(const QString& path, PStateRoot* fallback = nullptr, QObject* parent = nullptr);
};

SETTINGS_SINGLETON_DECL(PersistentState, hel::shell::state::PStateRoot, PersistentState)

} // namespace hel::shell::state
