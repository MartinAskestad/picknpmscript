vim9script

import autoload 'popupmenufilter.vim'

export def PickNpmScript()
  var package_json_path = findfile('package.json', '.;')
  if empty(package_json_path)
    return
  endif
  var package_json = json_decode(join(readfile(package_json_path)))
  var scripts: dict<string> = get(package_json, "scripts", {})
  var script_keys: list<string> = keys(scripts)
  echom script_keys

  var options: dict<any> = {
    title: 'Npm scripts',
    wrap: 0,
    pos: 'center',
    maxwidth: &columns - 10,
    maxheight: &lines - 10,
    mapping: false,
    fixed: 1,
    cb: (id: number, result: number) => {
      if result < 0
        return
      endif
      var script = script_keys[result - 1]
      silent execute $"!start cmd /c {scripts[script]}"
      },
  }

  popupmenufilter.PopupMenuFilter(copy(script_keys), options)
enddef

