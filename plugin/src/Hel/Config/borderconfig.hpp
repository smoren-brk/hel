#pragma once

#include "settings/objectnode.hpp"
#include "common.hpp"

namespace hel::shell::config {

class BorderConfig : public settings::ObjectNode {
    CONFIG_NODE(BorderConfig, settings::ObjectNode)

    CONFIG_PROPERTY(int, thickness, 0)
    CONFIG_PROPERTY(int, rounding, 25)
    // Floating panel corners, kept in sync with niri's geometry-corner-radius
    CONFIG_PROPERTY(int, panelRounding, 10)
    CONFIG_PROPERTY(int, smoothing, 20)

    Q_PROPERTY(int minThickness READ minThickness CONSTANT)
    Q_PROPERTY(int clampedThickness READ clampedThickness NOTIFY thicknessChanged)

public:
    [[nodiscard]] static int minThickness();
    [[nodiscard]] int clampedThickness() const;
};

} // namespace hel::shell::config
