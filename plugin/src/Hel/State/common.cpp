#include "common.hpp"

#include <qdir.h>
#include <qfileinfo.h>
#include <qstandardpaths.h>

namespace hel::shell::state {

using Qt::StringLiterals::operator""_s;

Q_LOGGING_CATEGORY(lcState, "hel.state", QtInfoMsg)

namespace {

// Older builds used the caelestia directory name
QString migrateLegacyDir(const QString& base) {
    const QString path = base + u"/hel"_s;
    const QString legacy = base + u"/caelestia"_s;
    if (!QFileInfo::exists(path) && QFileInfo::exists(legacy)) {
        if (QDir().rename(legacy, path))
            qCInfo(lcState) << "Migrated" << legacy << "to" << path;
        else
            qCWarning(lcState) << "Failed to migrate" << legacy << "to" << path;
    }
    return path;
}

} // namespace

QString stateDir() {
    static const QString dir = migrateLegacyDir(QStandardPaths::writableLocation(QStandardPaths::GenericStateLocation));
    return dir;
}

QString monitorStateDir() {
    return stateDir() + u"/monitors"_s;
}

} // namespace hel::shell::state
