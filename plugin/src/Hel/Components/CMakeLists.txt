qml_module(hel-components
    URI Hel.Components
    SOURCES
        animatedrepeater.cpp
        lazylistview.cpp
        wavyline.cpp
        buttonrow.cpp
        circularindicatormanager.cpp
        linearindicatormanager.cpp
        sparklineitem.cpp
        visualiserbars.cpp
        roundedmask.cpp
    LIBRARIES
        Qt::Gui
        Qt::Quick
        hel-core
    DEPENDENCIES
        Hel
)

qt_add_shaders(hel-components "components_shaders"
    BATCHABLE OPTIMIZED NOHLSL NOMSL
    GLSL "300es,330"
    PREFIX "/"
    FILES
        shaders/roundedmask.frag
        shaders/roundedmask.vert
)
