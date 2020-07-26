project('local.sample.sensors', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
libdir = join_paths(prefix, get_option('libdir'))
icondir = join_paths(datadir, 'icons', 'hicolor')

glib = dependency('glib-2.0')
granite = dependency('granite', version: '>= 5.2.0')
gtk = dependency('gtk+-3.0')
gee = dependency('gee-0.8')
gio = dependency('gio-2.0')
gobject = dependency('gobject-2.0')
wnck = dependency('libwnck-3.0')
wingpanel = dependency('wingpanel-2.0')
gdk_x11 = dependency('gdk-x11-3.0')

config_data = configuration_data()
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())

configure_file(output: 'config.h', configuration: config_data)
config_h_dir = include_directories('.')

icons_gresource = gnome.compile_resources(
    'gresource_icons', 'data/icons/icons.indicator.gresource.xml',
    source_dir: 'data/icons',
    c_name: 'as1'
)

css_gresource = gnome.compile_resources(
    'gresource_css', 'data/css.gresource.xml',
    source_dir: 'data',
    c_name: 'as2'
)

c_args = [
    '-include', 'config.h',
    '-DWNCK_I_KNOW_THIS_IS_UNSTABLE',
    '-w',
]

executable(
    meson.project_name(),
    icons_gresource,
    css_gresource,
    'src/Sensors.vala',
    'src/MainWindow.vala',

    'src/Services/DBusServer.vala',
    'src/Services/Sensor.vala',

    'src/Models/SensorRecord.vala',

    'src/Views/MainList.vala',
    c_args: c_args,
    dependencies: [
        glib,
        granite,
        gtk,
        gee,
        gio,
        gobject,
        wnck,
        gdk_x11,
        meson.get_compiler('c').find_library('m', required : false),
        meson.get_compiler('vala').find_library('posix'),
    ],
    vala_args: [
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install: true
)

shared_module(
    'sensors',
    'src/Indicator/Indicator.vala',

    'src/Indicator/Widgets/DisplayWidget.vala',
    'src/Indicator/Widgets/MenuWidget.vala',
    'src/Indicator/Widgets/TemperatureWidget.vala',

    'src/Indicator/Services/DBusClient.vala',
    icons_gresource,
    c_args: c_args,
    dependencies: [
        glib,
        granite,
        gobject,
        gtk,
        wingpanel
    ],
    install: true,
    install_dir : wingpanel.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir]),
)

meson.add_install_script('meson/post_install.py')

subdir('data')
subdir('po')