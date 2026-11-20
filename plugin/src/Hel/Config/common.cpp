#include "common.hpp"

#include <qdir.h>
#include <qfileinfo.h>
#include <qstandardpaths.h>

namespace hel::shell::config {

using Qt::StringLiterals::operator""_s;

Q_LOGGING_CATEGORY(lcConfig, "hel.config", QtInfoMsg)

namespace {

// Older builds used the caelestia directory name
QString migrateLegacyDir(const QString& base) {
    const QString path = base + u"/hel"_s;
    const QString legacy = base + u"/caelestia"_s;
    if (!QFileInfo::exists(path) && QFileInfo::exists(legacy)) {
        if (QDir().rename(legacy, path))
            qCInfo(lcConfig) << "Migrated" << legacy << "to" << path;
        else
            qCWarning(lcConfig) << "Failed to migrate" << legacy << "to" << path;
    }
    return path;
}

} // namespace

QString configDir() {
    static const QString dir = migrateLegacyDir(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation));
    return dir;
}

QString monitorConfigDir() {
    return configDir() + u"/monitors"_s;
}

} // namespace hel::shell::config
