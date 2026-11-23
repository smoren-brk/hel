#pragma once

#include <optional>

namespace hel::shell::services::sensorslib {

void ensureInit();

[[nodiscard]] std::optional<double> cpuPackageTemp();

} // namespace hel::shell::services::sensorslib
