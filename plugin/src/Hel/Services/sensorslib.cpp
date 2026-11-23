#include "sensorslib.hpp"

#include <qloggingcategory.h>

#include <sensors/sensors.h>

#include <atomic>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <utility>

namespace {

Q_LOGGING_CATEGORY(lcSensorsLib, "hel.services.sensorslib", QtInfoMsg)

} // namespace

namespace hel::shell::services::sensorslib {

namespace {

std::atomic<bool> g_initOk{ false };
std::once_flag g_initFlag;

void doInit() {
    if (sensors_init(nullptr) != 0) {
        qCWarning(lcSensorsLib, "sensors_init failed");
        g_initOk.store(false, std::memory_order_release);
        return;
    }
    g_initOk.store(true, std::memory_order_release);
    std::atexit([] {
        if (g_initOk.load(std::memory_order_acquire)) {
            sensors_cleanup();
        }
    });
}

[[nodiscard]] std::optional<double> readTempInput(const sensors_chip_name* chip, const sensors_feature* feat) {
    const auto* sf = sensors_get_subfeature(chip, feat, SENSORS_SUBFEATURE_TEMP_INPUT);
    if (!sf)
        return std::nullopt;
    double value = 0.0;
    if (sensors_get_value(chip, sf->number, &value) != 0)
        return std::nullopt;
    return value;
}

[[nodiscard]] QByteArray featureLabel(const sensors_chip_name* chip, const sensors_feature* feat) {
    char* raw = sensors_get_label(chip, feat);
    if (!raw)
        return {};
    QByteArray out(raw);
    std::free(raw);
    return out;
}

bool labelEquals(const QByteArray& label, const char* literal) {
    return label == QByteArrayView(literal);
}

bool labelStartsWith(const QByteArray& label, const char* prefix) {
    const auto n = std::strlen(prefix);
    return std::cmp_greater_equal(label.size(), n) && std::memcmp(label.constData(), prefix, n) == 0;
}

// Walks every labelled temperature feature
template <typename F> void forEachTempFeature(F&& fn) {
    int chipNr = 0;
    while (const auto* chip = sensors_get_detected_chips(nullptr, &chipNr)) {
        int featNr = 0;
        while (const auto* feat = sensors_get_features(chip, &featNr)) {
            if (feat->type != SENSORS_FEATURE_TEMP)
                continue;

            const auto label = featureLabel(chip, feat);
            if (label.isEmpty())
                continue;

            fn(chip, feat, label);
        }
    }
}

} // namespace

void ensureInit() {
    std::call_once(g_initFlag, doInit);
}

std::optional<double> cpuPackageTemp() {
    ensureInit();
    if (!g_initOk.load(std::memory_order_acquire))
        return std::nullopt;

    std::optional<double> primary;  // Package id N / Tdie
    std::optional<double> fallback; // Tctl

    forEachTempFeature([&](const sensors_chip_name* chip, const sensors_feature* feat, const QByteArray& label) {
        if (labelStartsWith(label, "Package id ") || labelEquals(label, "Tdie")) {
            if (const auto v = readTempInput(chip, feat))
                primary = v;
        } else if (labelEquals(label, "Tctl")) {
            if (const auto v = readTempInput(chip, feat))
                fallback = v;
        }
    });

    return primary.has_value() ? primary : fallback;
}

} // namespace hel::shell::services::sensorslib
