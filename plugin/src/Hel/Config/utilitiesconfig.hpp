#pragma once

#include <qstring.h>

#include "settings/objectnode.hpp"
#include "common.hpp"

namespace hel::shell::config {

using Qt::StringLiterals::operator""_s;

class UtilitiesToasts : public settings::ObjectNode {
    CONFIG_NODE(UtilitiesToasts, settings::ObjectNode)

    CONFIG_PROPERTY(QString, fullscreen, u"off"_s)
    CONFIG_PROPERTY(bool, configLoaded, true)
    CONFIG_PROPERTY(bool, chargingChanged, true)
    CONFIG_PROPERTY(bool, dndChanged, true)
    CONFIG_PROPERTY(bool, audioOutputChanged, true)
    CONFIG_PROPERTY(bool, audioInputChanged, true)
    CONFIG_PROPERTY(bool, nowPlaying, false)
};

class UtilitiesConfig : public settings::ObjectNode {
    CONFIG_NODE(UtilitiesConfig, settings::ObjectNode)

    CONFIG_PROPERTY(int, maxToasts, 4)
    CONFIG_GLOBAL_SUBOBJECT(UtilitiesToasts, toasts)
};

} // namespace hel::shell::config
