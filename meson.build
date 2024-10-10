project('libft_tester', ['c', 'vala'], default_options : ['optimization=2'])

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

executable('libft_tester',
  file,
  c_args: '-w',
  vala_args: '--enable-experimental',
  dependencies: vala_lib,
  install : true)
