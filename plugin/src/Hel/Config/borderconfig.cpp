#include "borderconfig.hpp"

#include <algorithm>

namespace hel::shell::config {

int BorderConfig::minThickness() {
    return 2;
}

int BorderConfig::clampedThickness() const {
    return std::max(minThickness(), m_thickness);
}

} // namespace hel::shell::config
