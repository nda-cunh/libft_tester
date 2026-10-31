project('libft_tester', ['c', 'vala'], default_options : ['optimization=2'])

files_vala = files(
  'Versus.vala',
  'delegate.vala',
  'main.vala',
)

subdir('mandatory_test')
subdir('bonus_test')

vala_lib = [
  dependency('supratest'),
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  meson.get_compiler('vala').find_library('posix'),
  meson.get_compiler('c').find_library('bsd'),
  meson.get_compiler('c').find_library('m')
]

executable('libft_tester',
  files_vala,
  c_args: '-w',
  vala_args: '--enable-experimental',
  dependencies: vala_lib,
  install : true)
