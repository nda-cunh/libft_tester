project('libft_tester', ['c', 'vala'])

file = [  'part2.vala',
          'leak.c',
          'main.vala',
          'SupraTest.vala',
          'Loader.vala',
          'SupraLeak.vala',
          'part1.vala',
          'finder_project.vala',
          'Module.vapi', 'leak.c']

vala_lib = [
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  meson.get_compiler('vala').find_library('posix'),
  meson.get_compiler('c').find_library('bsd')
]

add_project_arguments(['--enable-experimental'], language: 'vala')

executable('libft_tester_dev', file, dependencies: vala_lib, install : true)
