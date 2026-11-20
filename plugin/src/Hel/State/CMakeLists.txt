qml_module(hel-state
    URI Hel.State
    INCLUDE_PREFIX state
    SOURCES
        common.cpp
        rootnodes.cpp
    DEPENDENCIES
        Hel.Settings
)
target_link_libraries(hel-state PUBLIC hel-settings)
