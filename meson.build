project('libft_tester', ['c', 'vala'], default_options : ['optimization=2'])

files_vala = files(
  'finder_project.vala',
  'Loader.vala',
  'delegate.vala',
  'main.vala',
  'SupraLeak.vala',
  'SupraTest.vala',
  'Module.vapi',
  'leak.c'
)

subdir('mandatory_test')
subdir('bonus_test')

vala_lib = [
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  meson.get_compiler('vala').find_library('posix'),
  meson.get_compiler('c').find_library('bsd')
]

executable('libft_tester',
  files_vala,
  c_args: '-w',
  vala_args: '--enable-experimental',
  dependencies: vala_lib,
  install : true)
