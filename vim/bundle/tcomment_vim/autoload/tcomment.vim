" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2013-03-07.
" @Revision:    1021

" call tlog#Log('Load: '. expand('<sfile>')) " vimtlib-sfile

if !exists("g:tcommentBlankLines")
    " If true, comment blank lines too
    let g:tcommentBlankLines = 1    "{{{2
endif

if !exists("g:tcommentModeExtra")
    " Modifies how commenting works.
    "   >  ... Move the cursor to the end of the comment
    "   >> ... Like above but move the cursor to the next line
    "   #  ... Move the cursor to the position of the commented text 
    "          (NOTE: this only works when creating empty comments using 
    "          |:TCommentInline| from normal or insert mode and should 
    "          not be set here as a global option.)
    let g:tcommentModeExtra = ''   "{{{2
endif

if !exists("g:tcommentOpModeExtra")
    " Modifies how the operator works.
    " See |g:tcommentModeExtra| for a list of possible values.
    let g:tcommentOpModeExtra = ''   "{{{2
endif

if !exists('g:tcommentOptions')
    " Other key-value options used by |tcomment#Comment()|.
    "
    " Example: If you want to put the opening comment marker always in 
    " the first column regardless of the block's indentation, put this 
    " into your |vimrc| file: >
    "   let g:tcommentOptions = {'col': 1}
    let g:tcommentOptions = {}   "{{{2
endif

if !exists('g:tcomment#ignore_char_type')
    " |text-objects| for use with |tcomment#Operator| can have different 
    " types: line, block, char etc. Text objects like aB, it, at etc. 
    " have type char but this may not work reliably. By default, 
    " tcomment handles those text objects most often as if they were of 
    " type line. Set this variable to 0 in order to change this 
    " behaviour. Be prepared that the result may not always match your 
    " intentions.
    let g:tcomment#ignore_char_type = 1   "{{{2
endif

if !exists("g:tcommentGuessFileType")
    " Guess the file type based on syntax names always or for some fileformat only
    " If non-zero, try to guess filetypes.
    " tcomment also checks g:tcommentGuessFileType_{&filetype} for 
    " filetype specific values.
    "
    " Values:
    "   0        ... don't guess
    "   1        ... guess
    "   FILETYPE ... assume this filetype
    let g:tcommentGuessFileType = 0   "{{{2
endif
if !exists("g:tcommentGuessFileType_dsl")
    " For dsl documents, assume filetype = xml.
    let g:tcommentGuessFileType_dsl = 'xml'   "{{{2
endif
if !exists("g:tcommentGuessFileType_php")
    " In php documents, the php part is usually marked as phpRegion. We 
    " thus assume that the buffers default comment style isn't php but 
    " html.
    let g:tcommentGuessFileType_php = 'html'   "{{{2
endif
if !exists("g:tcommentGuessFileType_html")
    let g:tcommentGuessFileType_html = 1   "{{{2
endif
if !exists("g:tcommentGuessFileType_tskeleton")
    let g:tcommentGuessFileType_tskeleton = 1   "{{{2
endif
if !exists("g:tcommentGuessFileType_vim")
    let g:tcommentGuessFileType_vim = 1   "{{{2
endif
if !exists("g:tcommentGuessFileType_django")
    let g:tcommentGuessFileType_django = 1   "{{{2
endif
if !exists("g:tcommentGuessFileType_eruby")
    let g:tcommentGuessFileType_eruby = 1   "{{{2
endif
if !exists("g:tcommentGuessFileType_smarty")
    let g:tcommentGuessFileType_smarty = 1   "{{{2
endif

if !exists("g:tcommentIgnoreTypes_php")
    " In php files, some syntax regions are wrongly highlighted as sql 
    " markup. We thus ignore sql syntax when guessing the filetype in 
    " php files.
    let g:tcommentIgnoreTypes_php = 'sql'   "{{{2
endif

if !exists('g:tcomment#syntax_substitute')
    " :read: let g:tcomment#syntax_substitute = {...}   "{{{2
    " Perform replacements on the syntax name.
    let g:tcomment#syntax_substitute = {
                \ '\C^javaScript\ze\(\u\|$\)': {'sub': 'javascript'},
                \ '\C^js\ze\(\u\|$\)': {'sub': 'javascript'}
                \ }
endif

if !exists('g:tcomment#filetype_map')
    " Keys must match the full |filetype|. Regexps must be |magic|. No 
    " regexp modifiers (like |\V|) are allowed.
    " let g:tcomment#filetype_map = {...}   "{{{2
    let g:tcomment#filetype_map = {
                \ 'rails-views': 'html',
                \ 'mkd': 'html',
                \ }
endif

if !exists('g:tcommentSyntaxMap')
    " tcomment guesses filetypes based on the name of the current syntax 
    " region. This works well if the syntax names match 
    " /filetypeSomeName/. Other syntax names have to be explicitly 
    " mapped onto the corresponding filetype.
    " :read: let g:tcommentSyntaxMap = {...}   "{{{2
    let g:tcommentSyntaxMap = {
            \ 'erubyExpression':   'ruby',
            \ 'vimMzSchemeRegion': 'scheme',
            \ 'vimPerlRegion':     'perl',
            \ 'vimPythonRegion':   'python',
            \ 'vimRubyRegion':     'ruby',
            \ 'vimTclRegion':      'tcl',
            \ 'Delimiter': {
            \     'filetype': {
            \         'php': 'php',
            \     },
            \ },
            \ 'phpRegionDelimiter': {
            \     'prevnonblank': [
            \         {'match': '<?php', 'filetype': 'php'},
            \         {'match': '?>', 'filetype': 'html'},
            \     ],
            \     'nextnonblank': [
            \         {'match': '?>', 'filetype': 'php'},
            \         {'match': '<?php', 'filetype': 'html'},
            \     ],
            \ },
            \ }
endif

if !exists('g:tcomment#replacements_c')
    " Replacements for c filetype.
    " :read: let g:tcomment#replacements_c = {...}   "{{{2
    let g:tcomment#replacements_c = {
                \     '/*': '#<{(|',
                \     '*/': '|)}>#',
                \ }
endif

if !exists("g:tcommentInlineC")
    " Generic c-like comments.
    " :read: let g:tcommentInlineC = {...}   "{{{2
    let g:tcommentInlineC = {
                \ 'commentstring': '/* %s */',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif
if !exists("g:tcommentLineC")
    " Generic c-like block comments.
    let g:tcommentLineC = g:tcommentInlineC
endif
if !exists("g:tcommentBlockC")
    let g:tcommentBlockC = {
                \ 'commentstring': '/*%s */',
                \ 'middle': ' * ',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '\*\+',
                \ 'rxmid': '\*\+',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif
if !exists("g:tcommentBlockC2")
    " Generic c-like block comments (alternative markup).
    " :read: let g:tcommentBlockC2 = {...}   "{{{2
    let g:tcommentBlockC2 = {
                \ 'commentstring': '/**%s */',
                \ 'middle': ' * ',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '\*\+',
                \ 'rxmid': '\*\+',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif

if !exists('g:tcomment#replacements_xml')
    " Replacements for xml filetype.
    " :read: let g:tcomment#replacements_xml = {...}   "{{{2
    let g:tcomment#replacements_xml = {
                \     '-': '&#45;',
                \     '&': '&#38;',
                \ }
endif

if !exists("g:tcommentBlockXML")
    " Generic xml-like block comments.
    " :read: let g:tcommentBlockXML = {...}   "{{{2
    let g:tcommentBlockXML = {
                \ 'commentstring': "<!--%s-->\n  ",
                \ 'replacements': g:tcomment#replacements_xml
                \ }
endif
if !exists("g:tcommentInlineXML")
    " Generic xml-like comments.
    " :read: let g:tcommentInlineXML = {...}   "{{{2
    let g:tcommentInlineXML = {
                \ 'commentstring': "<!-- %s -->",
                \ 'replacements': g:tcomment#replacements_xml
                \ }
endif

let s:typesDirty = 1

let s:definitions = {}

" If you don't explicitly define a comment style, |:TComment| will use 
" 'commentstring' instead. We override the default values here in order 
" to have a blank after the comment marker. Block comments work only if 
" we explicitly define the markup.
"
" NAME usually is a 'filetype'. You can use special suffixes to define 
" special comment types. E.g. the name "FILETYPE_block" is used for 
" block comments for 'filetype'. The name "FILETYPE_inline" is used for 
" inline comments. If no specialized comment definition exists, the 
" normal one with name "FILETYPE" is used.
"
" The comment definition can be either a string or a dictionary.
"
" If it is a string:
" The format for block comments is similar to 'commentstrings' with the 
" exception that the format strings for blocks can contain a second line 
" that defines how "middle lines" (see :h format-comments) should be 
" displayed.
"
" Example: If the string is "--%s--\n-- ", lines will be commented as 
" "--%s--" but the middle lines in block comments will be commented as 
" "--%s".
"
" If it is a dictionary:
" See the help on the args argument of |tcomment#Comment| (see item 1, 
" args is a list of key=value pairs) to find out which fields can be 
" used.
" :display: tcomment#DefineType(name, commentdef, ?cdef={}, ?anyway=0)
function! tcomment#DefineType(name, commentdef, ...)
    let use = a:0 >= 2 ? a:2 : !has_key(s:definitions, a:name)
    if use
        if type(a:commentdef) == 4
            let cdef = copy(a:commentdef)
        else
            let cdef = a:0 >= 1 ? a:1 : {}
            let cdef.commentstring = a:commentdef
        endif
        let s:definitions[a:name] = cdef
    endif
    let s:typesDirty = 1
endf

" :nodoc:
" Return comment definition
function! tcomment#GetCommentDef(name)
    return get(s:definitions, a:name, "")
endf

" :nodoc:
" Return 1 if a comment type is defined.
function! tcomment#TypeExists(name)
    return has_key(s:definitions, a:name)
endf

" :doc:
" A dictionary of NAME => COMMENT DEFINITION (see |tcomment#DefineType|) 
" that can be set in vimrc to override tcomment's default comment 
" styles.
" :read: let g:tcomment_types = {} "{{{2
if exists('g:tcomment_types')
    for [s:name, s:def] in items(g:tcomment_types)
        call tcomment#DefineType(s:name, s:def)
    endfor
    unlet! s:name s:def
endif

call tcomment#DefineType('aap',              '# %s'             )
call tcomment#DefineType('ada',              '-- %s'            )
call tcomment#DefineType('apache',           '# %s'             )
call tcomment#DefineType('asciidoc',         '// %s'            )
call tcomment#DefineType('asm',              '; %s'             )
call tcomment#DefineType('autoit',           '; %s'             )
call tcomment#DefineType('awk',              '# %s'             )
call tcomment#DefineType('c',                g:tcommentLineC    )
call tcomment#DefineType('c_block',          g:tcommentBlockC   )
call tcomment#DefineType('c_inline',         g:tcommentInlineC  )
call tcomment#DefineType('catalog',          '-- %s --'         )
call tcomment#DefineType('catalog_block',    "--%s--\n  "       )
call tcomment#DefineType('cfg',              '# %s'             )
call tcomment#DefineType('chromemanifest',   '# %s'             )
call tcomment#DefineType('clojure',          {'commentstring': '; %s', 'count': 2})
call tcomment#DefineType('clojure_inline',   '; %s'             )
call tcomment#DefineType('clojurescript',    ';; %s'            )
call tcomment#DefineType('clojurescript_inline', '; %s'         )
call tcomment#DefineType('cmake',            '# %s'             )
call tcomment#DefineType('coffee',           '# %s'             )
call tcomment#DefineType('conf',             '# %s'             )
call tcomment#DefineType('conkyrc',          '# %s'             )
call tcomment#DefineType('cpp',              '// %s'            )
call tcomment#DefineType('cpp_block',        g:tcommentBlockC   )
call tcomment#DefineType('cpp_inline',       g:tcommentInlineC  )
call tcomment#DefineType('crontab',          '# %s'             )
call tcomment#DefineType('cs',               '// %s'            )
call tcomment#DefineType('cs_block',         g:tcommentBlockC   )
call tcomment#DefineType('cs_inline',        g:tcommentInlineC  )
call tcomment#DefineType('css',              '/* %s */'         )
call tcomment#DefineType('css_block',        g:tcommentBlockC   )
call tcomment#DefineType('css_inline',       g:tcommentInlineC  )
call tcomment#DefineType('debcontrol',       '# %s'             )
call tcomment#DefineType('debsources',       '# %s'             )
call tcomment#DefineType('desktop',          '# %s'             )
call tcomment#DefineType('dnsmasq',          '# %s'             )
call tcomment#DefineType('docbk',            g:tcommentInlineXML)
call tcomment#DefineType('docbk_block',      g:tcommentBlockXML )
call tcomment#DefineType('docbk_inline',     g:tcommentInlineXML)
call tcomment#DefineType('dosbatch',         'rem %s'           )
call tcomment#DefineType('dosini',           '; %s'             )
call tcomment#DefineType('dsl',              '; %s'             )
call tcomment#DefineType('dustjs',           '{! %s !}'         )
call tcomment#DefineType('dylan',            '// %s'            )
call tcomment#DefineType('eiffel',           '-- %s'            )
call tcomment#DefineType('erlang',           '%%%% %s'          )
call tcomment#DefineType('eruby',            '<%%# %s'          )
call tcomment#DefineType('esmtprc',          '# %s'             )
call tcomment#DefineType('expect',           '# %s'             )
call tcomment#DefineType('form',             {'commentstring': '* %s', 'col': 1})
call tcomment#DefineType('fstab',            '# %s'             )
call tcomment#DefineType('gitcommit',        '# %s'             )
call tcomment#DefineType('gitignore',        '# %s'             )
call tcomment#DefineType('gnuplot',          '# %s'             )
call tcomment#DefineType('go',               '// %s'            )
call tcomment#DefineType('go_block',         g:tcommentBlockC   )
call tcomment#DefineType('go_inline',        g:tcommentInlineC  )
call tcomment#DefineType('groovy',           '// %s'            )
call tcomment#DefineType('groovy_block',     g:tcommentBlockC   )
call tcomment#DefineType('groovy_doc_block', g:tcommentBlockC2  )
call tcomment#DefineType('groovy_inline',    g:tcommentInlineC  )
call tcomment#DefineType('gtkrc',            '# %s'             )
call tcomment#DefineType('haml',             '-# %s'            )
call tcomment#DefineType('haskell',          '-- %s'            )
call tcomment#DefineType('haskell_block',    "{-%s-}\n   "      )
call tcomment#DefineType('haskell_inline',   '{- %s -}'         )
call tcomment#DefineType('html',             g:tcommentInlineXML)
call tcomment#DefineType('html_block',       g:tcommentBlockXML )
call tcomment#DefineType('html_inline',      g:tcommentInlineXML)
call tcomment#DefineType('htmldjango',       '{# %s #}'     )
call tcomment#DefineType('htmldjango_block', "{%% comment %%}%s{%% endcomment %%}\n ")
call tcomment#DefineType('htmljinja',       '{# %s #}'     )
call tcomment#DefineType('htmljinja_block', "{%% comment %%}%s{%% endcomment %%}\n ")
call tcomment#DefineType('hy',               '; %s'             )
call tcomment#DefineType('ini',              '; %s'             ) " php ini (/etc/php5/...)
call tcomment#DefineType('io',               '// %s'            )
call tcomment#DefineType('jasmine',          '# %s'             )
call tcomment#DefineType('java',             '/* %s */'         )
call tcomment#DefineType('java_block',       g:tcommentBlockC   )
call tcomment#DefineType('java_doc_block',   g:tcommentBlockC2  )
call tcomment#DefineType('java_inline',      g:tcommentInlineC  )
call tcomment#DefineType('javaScript',       '// %s'            )
call tcomment#DefineType('javascript',       '// %s'            )
call tcomment#DefineType('javaScript_block', g:tcommentBlockC   )
call tcomment#DefineType('javascript_block', g:tcommentBlockC   )
call tcomment#DefineType('javaScript_inline', g:tcommentInlineC )
call tcomment#DefineType('javascript_inline', g:tcommentInlineC )
call tcomment#DefineType('jproperties',      '# %s'             )
call tcomment#DefineType('lisp',             '; %s'             )
call tcomment#DefineType('lua',              '-- %s'            )
call tcomment#DefineType('lua_block',        "--[[%s--]]\n"     )
call tcomment#DefineType('lua_inline',       '--[[%s --]]'      )
call tcomment#DefineType('lynx',             '# %s'             )
call tcomment#DefineType('m4',               'dnl %s'           )
call tcomment#DefineType('mail',             '> %s'             )
call tcomment#DefineType('matlab',           '%% %s'            )
call tcomment#DefineType('monkey',           ''' %s'            )
call tcomment#DefineType('msidl',            '// %s'            )
call tcomment#DefineType('msidl_block',      g:tcommentBlockC   )
call tcomment#DefineType('nginx',            '# %s'             )
call tcomment#DefineType('nroff',            '.\\" %s'          )
call tcomment#DefineType('nsis',             '# %s'             )
call tcomment#DefineType('objc',             '/* %s */'         )
call tcomment#DefineType('objc_block',       g:tcommentBlockC   )
call tcomment#DefineType('objc_inline',      g:tcommentInlineC  )
call tcomment#DefineType('objcpp',           '// %s'            )
call tcomment#DefineType('ocaml',            '(* %s *)'         )
call tcomment#DefineType('ocaml_block',      "(*%s*)\n   "      )
call tcomment#DefineType('ocaml_inline',     '(* %s *)'         )
call tcomment#DefineType('pac',              '// %s'            )
call tcomment#DefineType('pascal',           '(* %s *)'         )
call tcomment#DefineType('pascal_block',     "(*%s*)\n   "      )
call tcomment#DefineType('pascal_inline',    '(* %s *)'         )
call tcomment#DefineType('perl',             '# %s'             )
call tcomment#DefineType('perl_block',       "=cut%s=cut"       )
call tcomment#DefineType('pfmain',           '# %s'             )
call tcomment#DefineType('php',              {'commentstring_rx': '\%%(//\|#\) %s', 'commentstring': '// %s'})
call tcomment#DefineType('php_2_block',      g:tcommentBlockC2  )
call tcomment#DefineType('php_block',        g:tcommentBlockC   )
call tcomment#DefineType('php_inline',       g:tcommentInlineC  )
call tcomment#DefineType('po',               '# %s'             )
call tcomment#DefineType('prolog',           '%% %s'            )
call tcomment#DefineType('puppet',           '# %s'             )
call tcomment#DefineType('python',           '# %s'             )
call tcomment#DefineType('r',                '# %s'             )
call tcomment#DefineType('racket',           '; %s'             )
call tcomment#DefineType('racket_block',     '#|%s|#'           )
call tcomment#DefineType('rc',               '// %s'            )
call tcomment#DefineType('readline',         '# %s'             )
call tcomment#DefineType('resolv',           '# %s'             )
call tcomment#DefineType('robots',           '# %s'             )
call tcomment#DefineType('ruby',             '# %s'             )
call tcomment#DefineType('ruby_3',           '### %s'           )
call tcomment#DefineType('ruby_block',       "=begin rdoc%s=end")
call tcomment#DefineType('ruby_nodoc_block', "=begin%s=end"     )
call tcomment#DefineType('samba',            '# %s'             )
call tcomment#DefineType('sbs',              "' %s"             )
call tcomment#DefineType('scala',            '// %s'            )
call tcomment#DefineType('scala_block',      g:tcommentBlockC   )
call tcomment#DefineType('scala_inline',     g:tcommentInlineC  )
call tcomment#DefineType('scheme',           '; %s'             )
call tcomment#DefineType('scheme_block',     '#|%s|#'           )
call tcomment#DefineType('scss',             '// %s'            )
call tcomment#DefineType('scss_block',       g:tcommentBlockC   )
call tcomment#DefineType('scss_inline',      g:tcommentInlineC  )
call tcomment#DefineType('sed',              '# %s'             )
call tcomment#DefineType('sgml',             g:tcommentInlineXML)
call tcomment#DefineType('sgml_block',       g:tcommentBlockXML )
call tcomment#DefineType('sgml_inline',      g:tcommentInlineXML)
call tcomment#DefineType('sh',               '# %s'             )
call tcomment#DefineType('slim',             '/%s'              )
call tcomment#DefineType('sls',              '# %s'             )
call tcomment#DefineType('smarty',           '{* %s *}'         )
call tcomment#DefineType('spec',             '# %s'             )
call tcomment#DefineType('sps',              '* %s.'            )
call tcomment#DefineType('sps_block',        "* %s."            )
call tcomment#DefineType('spss',             '* %s.'            )
call tcomment#DefineType('spss_block',       "* %s."            )
call tcomment#DefineType('sql',              '-- %s'            )
call tcomment#DefineType('squid',            '# %s'             )
call tcomment#DefineType('sshconfig',        '# %s'             )
call tcomment#DefineType('sshdconfig',       '# %s'             )
call tcomment#DefineType('st',               '" %s "'           )
call tcomment#DefineType('tcl',              '# %s'             )
call tcomment#DefineType('tex',              '%% %s'            )
call tcomment#DefineType('tpl',              '<!-- %s -->'      )
call tcomment#DefineType('typoscript',       '# %s'             )
call tcomment#DefineType('upstart',          '# %s'             )
call tcomment#DefineType('vhdl',             '-- %s'            )
call tcomment#DefineType('viki',             '%% %s'            )
call tcomment#DefineType('viki_3',           '%%%%%% %s'        )
call tcomment#DefineType('viki_inline',      '{cmt: %s}'        )
call tcomment#DefineType('vim',              '" %s'             )
call tcomment#DefineType('vim_3',            '""" %s'           )
call tcomment#DefineType('websec',           '# %s'             )
call tcomment#DefineType('x86conf',          '# %s'             )
call tcomment#DefineType('xml',              g:tcommentInlineXML)
call tcomment#DefineType('xml_block',        g:tcommentBlockXML )
call tcomment#DefineType('xml_inline',       g:tcommentInlineXML)
call tcomment#DefineType('xs',               g:tcommentInlineC  )
call tcomment#DefineType('xs_block',         g:tcommentBlockC   )
call tcomment#DefineType('xslt',             g:tcommentInlineXML)
call tcomment#DefineType('xslt_block',       g:tcommentBlockXML )
call tcomment#DefineType('xslt_inline',      g:tcommentInlineXML)
call tcomment#DefineType('yaml',             '# %s'             )


function! s:DefaultValue(option)
    exec 'let '. a:option .' = &'. a:option
    exec 'set '. a:option .'&'
    exec 'let default = &'. a:option
    exec 'let &'. a:option .' = '. a:option
    return default
endf

let s:defaultComments      = s:DefaultValue('comments')
let s:defaultCommentString = s:DefaultValue('commentstring')
let s:nullCommentString    = '%s'

" tcomment#Comment(line1, line2, ?commentMode, ?commentAnyway, ?args...)
" args... are either:
"   1. a list of key=value pairs where known keys are (see also 
"      |g:tcommentOptions|):
"         as=STRING        ... Use a specific comment definition
"         count=N          ... Repeat the comment string N times
"         col=N            ... Start the comment at column N (in block 
"                              mode; must be smaller than |indent()|)
"         mode=STRING      ... See the notes below on the "commentMode" argument
"         mode_extra=STRING ... Add to commentMode
"         begin=STRING     ... Comment prefix
"         end=STRING       ... Comment postfix
"         middle=STRING    ... Middle line comments in block mode
"         rxbeg=N          ... Regexp to find the substring of "begin" 
"                              that should be multiplied by "count"
"         rxend=N          ... The above for "end"
"         rxmid=N          ... The above for "middle"
"         mixedindent=BOOL ... If true, allow use of mixed 
"                              characters for indentation
"         commentstring_rx ... A regexp format string that matches 
"                              commented lines (no new groups may be 
"                              introduced, the |regexp| is |\V|; % have 
"                              to be doubled); "commentstring", "begin" 
"                              and optionally "end" must be defined or 
"                              deducible.
"         whitespace       ... Define whether commented text is 
"                              surrounded with whitespace; if
"                              both ... surround with whitespace (default)
"                              no   ... don't use whitespace
"         strip_whitespace ... Strip trailing whitespace: if 1, strip 
"                              from empty lines only, if 2, always strip 
"                              whitespace
"   2. 1-2 values for: ?commentPrefix, ?commentPostfix
"   3. a dictionary (internal use only)
"
" commentMode (see also ¦g:tcommentModeExtra¦):
"   G ... guess the value of commentMode
"   B ... block (use extra lines for the comment markers)
"   i ... maybe inline, guess
"   I ... inline
"   R ... right (comment the line right of the cursor)
"   v ... visual
"   o ... operator
" By default, each line in range will be commented by adding the comment 
" prefix and postfix.
function! tcomment#Comment(beg, end, ...)
    let commentMode   = s:AddModeExtra((a:0 >= 1 ? a:1 : 'G'), g:tcommentModeExtra, a:beg, a:end)
    let commentAnyway = a:0 >= 2 ? (a:2 == '!') : 0
    " TLogVAR a:beg, a:end, commentMode, commentAnyway
    " save the cursor position
    if exists('w:tcommentPos')
        let s:current_pos = copy(w:tcommentPos)
    else
        let s:current_pos = getpos('.')
    endif
    " echom "DBG current_pos=" string(s:current_pos)
    let cursor_pos = getpos("'>")
    " TLogVAR cursor_pos
    let s:cursor_pos = []
    if commentMode =~# 'i'
        let commentMode = substitute(commentMode, '\Ci', line("'<") == line("'>") ? 'I' : 'G', 'g')
        " TLogVAR 1, commentMode
    endif
    let [lbeg, cbeg, lend, cend] = s:GetStartEnd(a:beg, a:end, commentMode)
    if exists('s:temp_options') && has_key(s:temp_options, 'mode_extra')
        let commentMode = s:AddModeExtra(commentMode, s:temp_options.mode_extra, lbeg, lend)
        unlet s:temp_options.mode_extra
    endif
    " TLogVAR commentMode, lbeg, cbeg, lend, cend
    " get the correct commentstring
    let cdef = copy(g:tcommentOptions)
    " TLogVAR 1, cdef
    if exists('b:tcommentOptions')
        let cdef = extend(cdef, copy(b:tcommentOptions))
        " TLogVAR 2, cdef
    endif
    if a:0 >= 3 && type(a:3) == 4
        call extend(cdef, a:3)
        " TLogVAR 3, cdef
    else
        let cdef0 = s:GetCommentDefinition(lbeg, lend, commentMode)
        " TLogVAR 4.1, cdef, cdef0
        call extend(cdef, cdef0)
        " TLogVAR 4.2, cdef
        let ax = 3
        if a:0 >= 3 && a:3 != '' && stridx(a:3, '=') == -1
            let ax = 4
            let cdef.begin = a:3
            if a:0 >= 4 && a:4 != '' && stridx(a:4, '=') == -1
                let ax = 5
                let cdef.end = a:4
            endif
        endif
        " TLogVAR ax, a:0, a:000
        if a:0 >= ax
            let cdef = extend(cdef, s:ParseArgs(lbeg, lend, commentMode, a:000[ax - 1 : -1]))
            " TLogVAR 5, cdef
        endif
        if !empty(get(cdef, 'begin', '')) || !empty(get(cdef, 'end', ''))
            let cdef.commentstring = s:EncodeCommentPart(get(cdef, 'begin', ''))
                        \ . '%s'
                        \ . s:EncodeCommentPart(get(cdef, 'end', ''))
        endif
        let commentMode = cdef.mode
        " TLogVAR 2, commentMode
    endif
    if exists('s:temp_options')
        let cdef = s:ExtendCDef(lbeg, lend, commentMode, cdef, s:temp_options)
        " TLogVAR 6, cdef
        " echom "DBG s:temp_options" string(s:temp_options)
        unlet s:temp_options
    endif
    " TLogVAR 7, cdef
    if has_key(cdef, 'whitespace')
        call s:SetWhitespaceMode(cdef)
    endif
    if !empty(filter(['count', 'cbeg', 'cend', 'cmid'], 'has_key(cdef, v:val)'))
        call s:RepeatCommentstring(cdef)
    endif
    " echom "DBG" string(a:000)
    let cms0 = s:BlockGetCommentRx(cdef)
    " TLogVAR cms0
    " make whitespace optional; this conflicts with comments that require some 
    " whitespace
    let cmtCheck = substitute(cms0, '\([	 ]\)', '\1\\?', 'g')
    " turn commentstring into a search pattern
    " TLogVAR cmtCheck
    let cmtCheck = printf(cmtCheck, '\(\_.\{-}\)')
    " TLogVAR cdef, cmtCheck
    let s:cdef = cdef
    " set commentMode and indentStr
    let [lbeg, lend, indentStr, uncomment] = s:CommentDef(lbeg, lend, cmtCheck, commentMode, cbeg, cend)
    " TLogVAR lbeg, lend, indentStr, uncomment
    let col = get(s:cdef, 'col', -1)
    if col >= 0
        let col -= 1
        let indent = len(indentStr)
        if col > indent
            let cms0 = repeat(' ', col - indent) . cms0
            " TLogVAR cms0
        else
            let indentStr = repeat(' ', col)
        endif
    endif
    if commentAnyway
        let uncomment = 0
    endif
    " go
    " TLogVAR commentMode
    if commentMode =~# 'B'
        " We want a comment block
        call s:CommentBlock(lbeg, lend, commentMode, uncomment, cmtCheck, s:cdef, indentStr)
    else
        " call s:CommentLines(lbeg, lend, cbeg, cend, uncomment, cmtCheck, cms0, indentStr)
        " We want commented lines
        " final search pattern for uncommenting
        let cmtCheck   = escape('\V\^\(\s\{-}\)'. cmtCheck .'\$', '"/\')
        " final pattern for commenting
        let cmtReplace = s:GetCommentReplace(s:cdef, cms0)
        " TLogVAR cmtReplace
        if get(s:cdef, 'mixedindent', 0) && !empty(indentStr)
            let cbeg = strdisplaywidth(indentStr, cbeg)
            let indentStr = ''
        endif
        " TLogVAR commentMode, lbeg, cbeg, lend, cend
        let s:processline_lnum = lbeg
        let cmd = lbeg .','. lend .'s/\V'. 
                    \ s:StartPosRx(commentMode, lbeg, cbeg) . indentStr .'\zs\(\_.\{-}\)'. s:EndPosRx(commentMode, lend, cend) .'/'.
                    \ '\=s:ProcessLine('. uncomment .', submatch(0), "'. cmtCheck .'", "'. cmtReplace .'")/ge'
        " TLogVAR cmd
        exec cmd
        call histdel('search', -1)
    endif
    " reposition cursor
    " TLogVAR 3, commentMode
    " echom "DBG s:cursor_pos" string(s:cursor_pos)
    if !empty(s:cursor_pos)
        let cursor_pos = s:cursor_pos
    endif
    if commentMode =~ '>'
        call setpos('.', cursor_pos)
        if commentMode !~ 'i' && commentMode =~ '>>'
            norm! l^
        endif
    elseif commentMode =~ '#'
        call setpos('.', cursor_pos)
        if exists('w:tcommentPos')
            let w:tcommentPos = cursor_pos
        endif
    else
        call setpos('.', s:current_pos)
    endif
    unlet! s:cursor_pos s:current_pos s:cdef
endf


function! tcomment#SetOption(name, arg) "{{{3
    " TLogVAR a:name, a:arg
    if !exists('s:temp_options')
        let s:temp_options = {}
    endif
    " if index(['count', 'as'], a:name) != -1
        if empty(a:arg)
            if has_key(s:temp_options, a:name)
                call remove(s:temp_options, a:name)
            endif
        else
            let s:temp_options[a:name] = a:arg
        endif
    " endif
endf


function! s:GetStartEnd(beg, end, commentMode) "{{{3
    " TLogVAR a:beg, a:end, a:commentMode
    if type(a:beg) == 3
        let [lbeg, cbeg] = a:beg
        let [lend, cend]   = a:end
    else
        let lbeg = a:beg
        let lend = a:end
        let commentMode = a:commentMode
        " TLogVAR commentMode
        if commentMode =~# 'R'
            let cbeg = col('.')
            let cend = 0
            let commentMode = substitute(commentMode, '\CR', 'G', 'g')
        elseif commentMode =~# 'I'
            let cbeg = col("'<")
            if cbeg == 0
                let cbeg = col('.')
            endif
            let cend = col("'>")
            if cend < col('$') && (commentMode =~# 'o' || &selection == 'inclusive')
                let cend += 1
                " TLogVAR cend, col('$')
            endif
        else
            let cbeg = 0
            let cend = 0
        endif
    endif
    " TLogVAR lbeg, cbeg, lend, cend
    return [lbeg, cbeg, lend, cend]
endf


function! s:SetWhitespaceMode(cdef) "{{{3
    let mode = a:cdef.whitespace
    let cms = s:BlockGetCommentString(a:cdef)
    let mid = s:BlockGetMiddleString(a:cdef)
    let cms0 = cms
    let mid0 = mid
    " TLogVAR mode, cms, mid
    if mode =~ '^\(n\%[o]\|l\%[eft]\|r\%[ight]\)$'
        if mode == 'no' || mode == 'right'
            let cms = substitute(cms, '\s\+\ze%\@<!%s', '', 'g')
            let mid = substitute(mid, '\s\+\ze%\@<!%s', '', 'g')
        endif
        if mode == 'no' || mode == 'left'
            let cms = substitute(cms, '%\@<!%s\zs\s\+', '', 'g')
            let mid = substitute(mid, '%\@<!%s\zs\s\+', '', 'g')
        endif
    elseif mode =~ '^\(b\%[oth]\)$'
        let cms = substitute(cms, '\S\zs\ze%\@<!%s', ' ', 'g')
        let mid = substitute(mid, '\S\zs\ze%\@<!%s', ' ', 'g')
        let cms = substitute(cms, '%\@<!%s\zs\ze\S', ' ', 'g')
        let mid = substitute(mid, '%\@<!%s\zs\ze\S', ' ', 'g')
    endif
    if cms != cms0
        " TLogVAR cms
        let a:cdef.commentstring = cms
    endif
    if mid != mid0
        " TLogVAR mid
        let a:cdef.middle = mid
    endif
    return a:cdef
endf


function! s:RepeatCommentstring(cdef) "{{{3
    " TLogVAR a:cdef
    let cms = s:BlockGetCommentString(a:cdef)
    let mid = s:BlockGetMiddleString(a:cdef)
    let cms_fbeg = match(cms, '\s*%\@<!%s')
    let cms_fend = matchend(cms, '%\@<!%s\s*')
    let rxbeg = get(a:cdef, 'rxbeg', '^.*$')
    let rxend = get(a:cdef, 'rxend', '^.*$')
    let rpbeg = repeat('&', get(a:cdef, 'cbeg', get(a:cdef, 'count', 1)))
    let rpend = repeat('&', get(a:cdef, 'cend', get(a:cdef, 'count', 1)))
    let a:cdef.commentstring = substitute(cms[0 : cms_fbeg - 1], rxbeg, rpbeg, '')
                \. cms[cms_fbeg : cms_fend - 1]
                \. substitute(cms[cms_fend : -1], rxend, rpend, '')
    " TLogVAR cms, a:cdef.commentstring
    if !empty(mid)
        let rxmid = get(a:cdef, 'rxmid', '^.*$')
        let rpmid = repeat('&', get(a:cdef, 'cmid', get(a:cdef, 'count', 1)))
        let a:cdef.middle = substitute(mid, rxmid, rpmid, '')
        " TLogVAR mid, a:cdef.middle
    endif
    return a:cdef
endf


function! s:ParseArgs(beg, end, commentMode, arglist) "{{{3
    let args = {}
    for arg in a:arglist
        let key = matchstr(arg, '^[^=]\+')
        let value = matchstr(arg, '=\zs.*$')
        if !empty(key)
            let args[key] = value
        endif
    endfor
    return s:ExtendCDef(a:beg, a:end, a:commentMode, {}, args)
endf


function! s:ExtendCDef(beg, end, commentMode, cdef, args)
    for [key, value] in items(a:args)
        if key == 'as'
            call extend(a:cdef, s:GetCommentDefinitionForType(a:beg, a:end, a:commentMode, value))
        elseif key == 'mode'
            let a:cdef[key] = a:commentMode . value
        elseif key == 'count'
            let a:cdef[key] = str2nr(value)
        else
            let a:cdef[key] = value
        endif
    endfor
    return a:cdef
endf


function! tcomment#Operator(type, ...) "{{{3
    let commentMode = a:0 >= 1 ? a:1 : ''
    let bang = a:0 >= 2 ? a:2 : ''
    " TLogVAR a:type, commentMode, bang
    if !exists('w:tcommentPos')
        let w:tcommentPos = getpos(".")
    endif
    let sel_save = &selection
    set selection=inclusive
    let reg_save = @@
    try
        if a:type == 'line'
            silent exe "normal! '[V']"
            let commentMode1 = 'G'
        elseif a:type == 'block'
            silent exe "normal! `[\<C-V>`]"
            let commentMode1 = 'I'
        elseif a:type == 'char' && !g:tcomment#ignore_char_type
            silent exe "normal! `[v`]"
            let commentMode1 = 'I'
        else
            silent exe "normal! `[v`]"
            let commentMode1 = 'i'
        endif
        if empty(commentMode)
            let commentMode = commentMode1
        endif
        let lbeg = line("'[")
        let lend = line("']")
        let cbeg = col("'[")
        let cend = col("']")
        " TLogVAR lbeg, lend, cbeg, cend
        " echom "DBG tcomment#Operator" lbeg col("'[") col("'<") lend col("']") col("'>")
        norm! 
        let commentMode = s:AddModeExtra(commentMode, g:tcommentOpModeExtra, lbeg, lend)
        if a:type =~ 'line\|block' || g:tcomment#ignore_char_type
            call tcomment#Comment(lbeg, lend, commentMode.'o', bang)
        else
            call tcomment#Comment([lbeg, cbeg], [lend, cend], commentMode.'o', bang)
        endif
    finally
        let &selection = sel_save
        let @@ = reg_save
        " TLogVAR g:tcommentOpModeExtra
        if g:tcommentOpModeExtra !~ '[#>]'
            if exists('w:tcommentPos')
                " TLogVAR w:tcommentPos
                if w:tcommentPos != getpos('.')
                    call setpos('.', w:tcommentPos)
                endif
                unlet! w:tcommentPos
            else
                echohl WarningMsg
                echom "TComment: w:tcommentPos wasn't set. Please report this to the plugin author"
                echohl NONE
            endif
        endif
    endtry
endf


function! tcomment#OperatorLine(type) "{{{3
    call tcomment#Operator(a:type, 'G')
endf


function! tcomment#OperatorAnyway(type) "{{{3
    call tcomment#Operator(a:type, '', '!')
endf


function! tcomment#OperatorLineAnyway(type) "{{{3
    call tcomment#Operator(a:type, 'G', '!')
endf


" :display: tcomment#CommentAs(beg, end, commentAnyway, filetype, ?args...)
" Where args is either:
"   1. A count NUMBER
"   2. An args list (see the notes on the "args" argument of 
"      |tcomment#Comment()|)
" comment text as if it were of a specific filetype
function! tcomment#CommentAs(beg, end, commentAnyway, filetype, ...)
    if a:filetype =~ '_block$'
        let commentMode = 'B'
        let ft = substitute(a:filetype, '_block$', '', '')
    elseif a:filetype =~ '_inline$'
        let commentMode = 'I'
        let ft = substitute(a:filetype, '_inline$', '', '')
    else 
        let commentMode = 'G'
        let ft = a:filetype
    endif
    if a:0 >= 1
        if type(a:1) == 0
            let cdef = {'count': a:0 >= 1 ? a:1 : 1}
        else
            let cdef = s:ParseArgs(a:beg, a:end, commentMode, a:000)
        endif
    else
        let cdef = {}
    endif
    " echom "DBG" string(cdef)
    call extend(cdef, s:GetCommentDefinitionForType(a:beg, a:end, commentMode, ft))
    keepjumps call tcomment#Comment(a:beg, a:end, commentMode, a:commentAnyway, cdef)
endf


" collect all known comment types
" :nodoc:
function! tcomment#CollectFileTypes()
    if s:typesDirty
        let s:types = keys(s:definitions)
        let s:typesRx = '\V\^\('. join(s:types, '\|') .'\)\(\u\.\*\)\?\$'
        let s:typesDirty = 0
    endif
endf

call tcomment#CollectFileTypes()


" return a list of filetypes for which a tcomment_{&ft} is defined
" :nodoc:
function! tcomment#Complete(ArgLead, CmdLine, CursorPos) "{{{3
    call tcomment#CollectFileTypes()
    let completions = copy(s:types)
    let filetype = s:Filetype()
    if index(completions, filetype) != -1
        " TLogVAR filetype
        call insert(completions, filetype)
    endif
    if !empty(a:ArgLead)
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    let completions += tcomment#CompleteArgs(a:ArgLead, a:CmdLine, a:CursorPos)
    return completions
endf


let s:first_completion = 0

" :nodoc:
function! tcomment#CompleteArgs(ArgLead, CmdLine, CursorPos) "{{{3
    if v:version < 703 && !s:first_completion
        redraw
        let s:first_completion = 1
    endif
    let completions = ['as=', 'col=', 'count=', 'mode=', 'begin=', 'end=', 'rxbeg=', 'rxend=', 'rxmid=']
    if !empty(a:ArgLead)
        if a:ArgLead =~ '^as='
            call tcomment#CollectFileTypes()
            let completions += map(copy(s:types), '"as=". v:val')
        endif
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    return completions
endf


function! s:EncodeCommentPart(string)
    return substitute(a:string, '%', '%%', 'g')
endf


function! s:GetCommentDefinitionForType(beg, end, commentMode, filetype) "{{{3
    let cdef = s:GetCommentDefinition(a:beg, a:end, a:commentMode, a:filetype)
    " TLogVAR cdef
    let cms  = cdef.commentstring
    let commentMode = cdef.mode
    let pre  = substitute(cms, '%\@<!%s.*$', '', '')
    let pre  = substitute(pre, '%%', '%', 'g')
    let post = substitute(cms, '^.\{-}%\@<!%s', '', '')
    let post = substitute(post, '%%', '%', 'g')
    let cdef.begin = pre
    let cdef.end   = post
    return cdef
endf


" s:GetCommentDefinition(beg, end, commentMode, ?filetype="")
function! s:GetCommentDefinition(beg, end, commentMode, ...)
    let ft = a:0 >= 1 ? a:1 : ''
    " TLogVAR ft
    if ft != ''
        let cdef = s:GetCustomCommentString(ft, a:commentMode)
    else
        let cdef = {'mode': a:commentMode}
    endif
    " TLogVAR cdef
    let cms = get(cdef, 'commentstring', '')
    if empty(cms)
        let filetype = s:Filetype(ft)
        if exists('b:commentstring')
            let cms = b:commentstring
            " TLogVAR 1, cms
            return s:GetCustomCommentString(filetype, a:commentMode, cms)
        elseif exists('b:commentStart') && b:commentStart != ''
            let cms = s:EncodeCommentPart(b:commentStart) .' %s'
            " TLogVAR 2, cms
            if exists('b:commentEnd') && b:commentEnd != ''
                let cms = cms .' '. s:EncodeCommentPart(b:commentEnd)
            endif
            return s:GetCustomCommentString(filetype, a:commentMode, cms)
        else
            let [use_guess_ft, altFiletype] = s:AltFiletype(ft)
            " TLogVAR use_guess_ft, altFiletype
            if use_guess_ft
                return s:GuessFileType(a:beg, a:end, a:commentMode, filetype, altFiletype)
            else
                return s:GetCustomCommentString(filetype, a:commentMode, s:GuessCurrentCommentString(a:commentMode))
            endif
        endif
        let cdef.commentstring = cms
    endif
    return cdef
endf

function! s:StartPosRx(mode, line, col)
    " TLogVAR a:mode, a:line, a:col
    if a:mode =~# 'I'
        let col = get(s:cdef, 'mixedindent', 0) ? a:col - 1 : a:col
        return s:StartLineRx(a:line) . s:StartColRx(col)
    else
        return s:StartColRx(a:col)
    endif
endf

function! s:EndPosRx(mode, line, col)
    if a:mode =~# 'I'
        return s:EndLineRx(a:line) . s:EndColRx(a:col)
    else
        return s:EndColRx(a:col)
    endif
endf

function! s:StartLineRx(pos)
    return '\%'. a:pos .'l'
endf

function! s:EndLineRx(pos)
    return '\%'. a:pos .'l'
endf

function! s:StartColRx(pos)
    if a:pos <= 1
        return '\^'
    elseif get(s:cdef, 'mixedindent', 0)
        return '\%>'. a:pos .'v'
    else
        return '\%'. a:pos .'c'
    endif
endf

function! s:EndColRx(pos)
    if a:pos == 0
        return '\$'
    else
        return '\%'. a:pos .'c'
    endif
endf

function! s:GetIndentString(line, start)
    let start = a:start > 0 ? a:start - 1 : 0
    return substitute(strpart(getline(a:line), start), '\V\^\s\*\zs\.\*\$', '', '')
endf

function! s:CommentDef(beg, end, checkRx, commentMode, cstart, cend)
    " TLogVAR a:beg, a:end, a:checkRx, a:commentMode, a:cstart, a:cend
    let beg = a:beg
    let end = a:end
    let mdrx = '\V'. s:StartColRx(a:cstart) .'\s\*'. a:checkRx .'\s\*'. s:EndColRx(0)
    " let mdrx = '\V'. s:StartPosRx(a:commentMode, beg, a:cstart) .'\s\*'. a:checkRx .'\s\*'. s:EndPosRx(a:commentMode, end, 0)
    let line = getline(beg)
    if a:cstart != 0 && a:cend != 0
        let line = strpart(line, 0, a:cend - 1)
    endif
    let uncomment = (line =~ mdrx)
    " TLogVAR 1, uncomment
    let indentStr = s:GetIndentString(beg, a:cstart)
    let il = indent(beg)
    let n  = beg + 1
    while n <= end
        if getline(n) =~ '\S'
            let jl = indent(n)
            if jl < il
                let indentStr = s:GetIndentString(n, a:cstart)
                let il = jl
            endif
            if a:commentMode =~# 'G'
                if !(getline(n) =~ mdrx)
                    let uncomment = 0
                    " TLogVAR 2, uncomment
                endif
            endif
        endif
        let n = n + 1
    endwh
    if a:commentMode =~# 'B'
        let t = @t
        try
            silent exec 'norm! '. beg.'G1|v'.end.'G$"ty'
            if &selection == 'inclusive' && @t =~ '\n$' && len(@t) > 1
                let @t = @t[0 : -2]
            endif
            " TLogVAR @t, mdrx
            let uncomment = (@t =~ mdrx)
            " TLogVAR 3, uncomment
            if !uncomment && a:commentMode =~ 'o'
                let mdrx1 = substitute(mdrx, '\\$$', '\\n\\$', '')
                " TLogVAR mdrx1
                if @t =~ mdrx1
                    let uncomment = 1
                    " TLogVAR 4, uncomment
                    " let end -= 1
                endif
            endif
        finally
            let @t = t
        endtry
    endif
    " TLogVAR 5, uncomment
    return [beg, end, indentStr, uncomment]
endf

function! s:ProcessLine(uncomment, match, checkRx, replace)
    " TLogVAR a:uncomment, a:match, a:checkRx, a:replace
    try
        if !(a:match =~ '\S' || g:tcommentBlankLines)
            return a:match
        endif
        let ml = len(a:match)
        if a:uncomment
            let rv = substitute(a:match, a:checkRx, '\1\2', '')
            let rv = s:UnreplaceInLine(rv)
        else
            let rv = s:ReplaceInLine(a:match)
            let rv = printf(a:replace, rv)
            let strip_whitespace = get(s:cdef, 'strip_whitespace', 0)
            if strip_whitespace == 2 || (strip_whitespace == 1 && ml == 0)
                let rv = substitute(rv, '\s\+$', '', '')
            endif
        endif
        " TLogVAR rv
        " echom "DBG s:cdef.mode=" string(s:cdef.mode) "s:cursor_pos=" string(s:cursor_pos)
        " let md = len(rv) - ml
        if s:cdef.mode =~ '>'
            let s:cursor_pos = getpos('.')
            let s:cursor_pos[2] += len(rv)
        elseif s:cdef.mode =~ '#'
            if empty(s:cursor_pos) || s:current_pos[1] == s:processline_lnum
                let prefix = matchstr(a:replace, '^.*%\@<!\ze%s')
                let prefix = substitute(prefix, '%\(.\)', '\1', 'g')
                let prefix_len = strdisplaywidth(prefix)
                " TLogVAR a:replace, prefix_len
                if prefix_len != -1
                    let s:cursor_pos = copy(s:current_pos)
                    if a:uncomment
                        let s:cursor_pos[2] -= prefix_len
                        if s:cursor_pos[2] < 1
                            let s:cursor_pos[2] = 1
                        endif
                    else
                        let s:cursor_pos[2] += prefix_len
                    endif
                    " echom "DBG s:current_pos=" string(s:current_pos) "s:cursor_pos=" string(s:cursor_pos)
                endif
            endif
        endif
        " TLogVAR pe, md, a:match
        " TLogVAR rv
        if v:version > 702 || (v:version == 702 && has('patch407'))
            let rv = escape(rv, "\r")
        else
            let rv = escape(rv, "\\r")
        endif
        " TLogVAR rv
        " let rv = substitute(rv, '\n', '\\\n', 'g')
        " TLogVAR rv
        return rv
    finally
        let s:processline_lnum += 1
    endtry
endf


function! s:ReplaceInLine(text) "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:cdef.replacements
        return s:DoReplacements(a:text, keys(replacements), values(replacements))
    else
        return a:text
    endif
endf


function! s:UnreplaceInLine(text) "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:cdef.replacements
        return s:DoReplacements(a:text, values(replacements), keys(replacements))
    else
        return a:text
    endif
endf


function! s:DoReplacements(text, tokens, replacements) "{{{3
    if empty(a:tokens)
        return a:text
    else
        let rx = '\V\('. join(map(a:tokens, 'escape(v:val, ''\'')'), '\|') .'\)'
        let texts = split(a:text, rx .'\zs', 1)
        let texts = map(texts, 's:InlineReplacement(v:val, rx, a:tokens, a:replacements)')
        let text = join(texts, '')
        return text
    endif
endf


function! s:InlineReplacement(text, rx, tokens, replacements) "{{{3
    " TLogVAR a:text, a:rx, a:replacements
    let matches = split(a:text, '\ze'. a:rx .'\$', 1)
    if len(matches) == 1
        return a:text
    else
        let match = matches[-1]
        let idx = index(a:tokens, match)
        " TLogVAR matches, match, idx
        if idx != -1
            let matches[-1] = a:replacements[idx]
            " TLogVAR matches
            return join(matches, '')
        else
            throw 'TComment: Internal error: cannot find '. string(match) .' in '. string(a:tokens)
        endif
    endif
endf


function! s:CommentBlock(beg, end, commentMode, uncomment, checkRx, cdef, indentStr)
    " TLogVAR a:beg, a:end, a:uncomment, a:checkRx, a:cdef, a:indentStr
    let t = @t
    let sel_save = &selection
    set selection=exclusive
    try
        silent exec 'norm! '. a:beg.'G1|v'.a:end.'G$"td'
        " TLogVAR @t
        let ms = s:BlockGetMiddleString(a:cdef)
        let mx = escape(ms, '\')
        let cs = s:BlockGetCommentString(a:cdef)
        let prefix = substitute(matchstr(cs, '^.*%\@<!\ze%s'), '%\(.\)', '\1', 'g')
        let postfix = substitute(matchstr(cs, '%\@<!%s\zs.*$'), '%\(.\)', '\1', 'g')
        if a:uncomment
            let @t = substitute(@t, '\V\^\s\*'. a:checkRx .'\$', '\1', '')
            " TLogVAR 1, @t
            if ms != ''
                let @t = substitute(@t, '\V\n'. a:indentStr . mx, '\n'. a:indentStr, 'g')
                " TLogVAR 2, @t
            endif
            let @t = substitute(@t, '^\n', '', '')
            let @t = substitute(@t, '\n\s*$', '', '')
            if a:commentMode =~ '#'
                let s:cursor_pos = copy(s:current_pos)
                let prefix_lines = len(substitute(prefix, "[^\n]", '', 'g')) + 1
                let postfix_lines = len(substitute(postfix, "[^\n]", '', 'g')) + 1
                " TODO: more precise solution (when cursor is placed on 
                " postfix or prefix
                if s:cursor_pos[1] > a:beg
                    let s:cursor_pos[1] -= prefix_lines
                    if s:cursor_pos[1] > a:end - postfix_lines
                        let s:cursor_pos[1] -= postfix_lines
                    endif
                    if s:cursor_pos[1] < 1
                        let s:cursor_pos[1] = 1
                    endif
                endif
                let prefix_len = strdisplaywidth(mx)
                let s:cursor_pos[2] -= prefix_len
                if s:cursor_pos[2] < 1
                    let s:cursor_pos[2] = 1
                endif
            endif
        else
            let cs = a:indentStr . substitute(cs, '%\@<!%s', '%s'. a:indentStr, '')
            if ms != ''
                let ms = a:indentStr . ms
                let mx = a:indentStr . mx
                let @t = substitute(@t, '^'. a:indentStr, '', 'g')
                let @t = ms . substitute(@t, '\n'. a:indentStr, '\n'. mx, 'g')
            endif
            let @t = printf(cs, "\n". @t ."\n")
            if a:commentMode =~ '#'
                let s:cursor_pos = copy(s:current_pos)
                let s:cursor_pos[1] += len(substitute(prefix, "[^\n]", '', 'g')) + 1
                let prefix_len = strdisplaywidth(mx)
                let s:cursor_pos[2] += prefix_len
                " echom "DBG s:current_pos=" string(s:current_pos) "s:cursor_pos=" string(s:cursor_pos)
            endif
        endif
        silent norm! "tP
    finally
        let &selection = sel_save
        let @t = t
    endtry
endf


function! s:Filetype(...) "{{{3
    let ft = a:0 >= 1 && !empty(a:1) ? a:1 : &filetype
    let pos = a:0 >= 2 ? a:2 : 0
    " TLogVAR ft, pos
    let fts = split(ft, '^\@!\.')
    " TLogVAR fts
    " let ft = substitute(ft, '\..*$', '', '')
    let rv = get(fts, pos, ft)
    " TLogVAR fts, rv
    if !exists('s:filetype_map_rx')
        let fts_rx = '^'. join(map(keys(g:tcomment#filetype_map), 'escape(v:val, ''\'')'), '\|') .'$'
    endif
    " TLogVAR fts_rx
    if rv =~ fts_rx
        for [ft_rx, ftrv] in items(g:tcomment#filetype_map)
            " TLogVAR ft_rx, ftrv
            if rv =~ ft_rx
                let rv = substitute(rv, ft_rx, ftrv, '')
                " TLogVAR rv
                break
            endif
        endfor
    endif
    return rv
endf


function! s:AltFiletype(filetype) "{{{3
    let filetype = empty(a:filetype) ? &filetype : a:filetype
    " TLogVAR a:filetype, filetype
    if g:tcommentGuessFileType || (exists('g:tcommentGuessFileType_'. filetype) 
                \ && g:tcommentGuessFileType_{filetype} =~ '[^0]')
        if g:tcommentGuessFileType_{filetype} == 1
            if filetype =~ '^.\{-}\..\+$'
                let altFiletype = s:Filetype(filetype, 1)
            else
                let altFiletype = ''
            endif
        else
            let altFiletype = g:tcommentGuessFileType_{filetype}
        endif
        " TLogVAR 1, altFiletype
        return [1, altFiletype]
    elseif filetype =~ '^.\{-}\..\+$'
        let altFiletype = s:Filetype(filetype, 1)
        " TLogVAR 2, altFiletype
        return [1, altFiletype]
    else
        " TLogVAR 3, ''
        return [0, '']
    endif
endf


" A function that makes the s:GuessFileType() function usable for other 
" library developers.
"
" The argument is a dictionary with the following keys:
"
"   beg ................ (default = line("."))
"   end ................ (default = line("."))
"   commentMode ........ (default = "G")
"   filetype ........... (default = &filetype)
"   fallbackFiletype ... (default = "")
"
" This function return a dictionary that contains information about how 
" to make comments. The information about the filetype of the text 
" between lines "beg" and "end" is in the "filetype" key of the return 
" value. It returns the first discernible filetype it encounters.
" :display: tcomment#GuessFileType(?options={})
function! tcomment#GuessCommentType(...) "{{{3
    let options = a:0 >= 1 ? a:1 : {}
    let beg = get(options, 'beg', line('.'))
    let end = get(options, 'end', line('.'))
    let commentMode = get(options, 'commentMode', '')
    let filetype = get(options, 'filetype', &filetype)
    let fallbackFiletype = get(options, 'filetype', '')
    return s:GuessFileType(beg, end, commentMode, filetype, fallbackFiletype)
endf


" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" s:GuessFileType(beg, end, commentMode, filetype, ?fallbackFiletype)
function! s:GuessFileType(beg, end, commentMode, filetype, ...)
    " TLogVAR a:beg, a:end, a:commentMode, a:filetype, a:000
    " TLogVAR cdef
    let cdef0 = s:GetCustomCommentString(a:filetype, a:commentMode)
    if a:0 >= 1 && a:1 != ''
        let cdef = s:GetCustomCommentString(a:1, a:commentMode)
        " TLogVAR 0, cdef
        let cdef = extend(cdef, cdef0, 'keep')
        " TLogVAR 1, cdef
        if empty(get(cdef, 'commentstring', ''))
            let cdef.commentstring = s:GuessCurrentCommentString(a:commentMode)
        endif
        " TLogVAR 2, cdef
    else
        let cdef = cdef0
        if !has_key(cdef, 'commentstring')
            let cdef = {'commentstring': s:GuessCurrentCommentString(0), 'mode': s:GuessCommentMode(a:commentMode)}
        endif
    endif
    let beg = a:beg
    let end = nextnonblank(a:end)
    if end == 0
        let end = a:end
        let beg = prevnonblank(a:beg)
        if beg == 0
            let beg = a:beg
        endif
    endif
    let n  = beg
    " TLogVAR n, beg, end
    while n <= end
        let m  = indent(n) + 1
        let text = getline(n)
        let le = len(text)
        " TLogVAR m, le
        while m <= le
            let syntaxName = s:GetSyntaxName(n, m)
            " TLogVAR syntaxName, n, m
            let ftypeMap = get(g:tcommentSyntaxMap, syntaxName, '')
            " TLogVAR ftypeMap
            if !empty(ftypeMap) && type(ftypeMap) == 4
                if n < a:beg
                    let key = 'prevnonblank'
                elseif n > a:end
                    let key = 'nextnonblank'
                else
                    let key = ''
                endif
                if empty(key) || !has_key(ftypeMap, key)
                    let ftypeftype = get(ftypeMap, 'filetype', {})
                    " TLogVAR ftypeMap, ftypeftype
                    unlet! ftypeMap
                    let ftypeMap = get(ftypeftype, a:filetype, '')
                else
                    let mapft = ''
                    for mapdef in ftypeMap[key]
                        if strpart(text, m - 1) =~ '^'. mapdef.match
                            let mapft = mapdef.filetype
                            break
                        endif
                    endfor
                    unlet! ftypeMap
                    if empty(mapft)
                        let ftypeMap = ''
                    else
                        let ftypeMap = mapft
                    endif
                endif
            endif
            if !empty(ftypeMap)
                " TLogVAR ftypeMap
                return s:GetCustomCommentString(ftypeMap, a:commentMode, cdef.commentstring)
            elseif syntaxName =~ s:typesRx
                let ft = substitute(syntaxName, s:typesRx, '\1', '')
                " TLogVAR ft
                if exists('g:tcommentIgnoreTypes_'. a:filetype) && g:tcommentIgnoreTypes_{a:filetype} =~ '\<'.ft.'\>'
                    let m += 1
                else
                    return s:GetCustomCommentString(ft, a:commentMode, cdef.commentstring)
                endif
            elseif syntaxName == '' || syntaxName == 'None' || syntaxName =~ '^\u\+$' || syntaxName =~ '^\u\U*$'
                let m += 1
            else
                break
            endif
        endwh
        let n += 1
    endwh
    " TLogVAR cdef
    return cdef
endf


function! s:GetSyntaxName(lnum, col) "{{{3
    let syntaxName = synIDattr(synID(a:lnum, a:col, 1), 'name')
    if !empty(g:tcomment#syntax_substitute)
        for [rx, subdef] in items(g:tcomment#syntax_substitute)
            if !has_key(subdef, 'if') || eval(subdef.if)
                let syntaxName = substitute(syntaxName, rx, subdef.sub, 'g')
            endif
        endfor
    endif
    " TLogVAR syntaxName
    return syntaxName
endf


function! s:AddModeExtra(mode, extra, beg, end) "{{{3
    if a:beg == a:end
        let extra = substitute(a:extra, '\C[B]', '', 'g')
    else
        let extra = substitute(a:extra, '\C[IR]', '', 'g')
    endif
    let mode = a:mode
    if extra =~# 'B'
        let mode = substitute(mode, '\c[gir]', '', 'g')
    endif
    if extra =~# '[IR]'
        let mode = substitute(mode, '\c[gb]', '', 'g')
    endif
    let rv = mode . extra
    " TLogVAR a:mode, a:extra, mode, extra, rv
    return rv
endf


function! s:GuessCommentMode(commentMode) "{{{3
    if a:commentMode =~# '[IRB]'
        return a:commentMode
    else
        return substitute(a:commentMode, '\w\+', 'G', 'g')
    endif
endf

function! s:GuessCurrentCommentString(commentMode)
    " TLogVAR a:commentMode
    let valid_cms = (match(&commentstring, '%\@<!%s') != -1)
    if &commentstring != s:defaultCommentString && valid_cms
        " The &commentstring appears to have been set and to be valid
        return &commentstring
    endif
    if &comments != s:defaultComments
        " the commentstring is the default one, so we assume that it wasn't 
        " explicitly set; we then try to reconstruct &cms from &comments
        let cms = s:ConstructFromComments(a:commentMode)
        if cms != s:nullCommentString
            return cms
        endif
    endif
    if valid_cms
        " Before &commentstring appeared not to be set. As we don't know 
        " better we return it anyway if it is valid
        return &commentstring
    else
        " &commentstring is invalid. So we return the identity string.
        return s:nullCommentString
    endif
endf

function! s:ConstructFromComments(commentMode)
    exec s:ExtractCommentsPart('')
    if a:commentMode =~# 'G' && line != ''
        return line .' %s'
    endif
    exec s:ExtractCommentsPart('s')
    if s != ''
        exec s:ExtractCommentsPart('e')
        return s.' %s '.e
    endif
    if line != ''
        return line .' %s'
    else
        return s:nullCommentString
    endif
endf

function! s:ExtractCommentsPart(key)
    " let key   = a:key != "" ? a:key .'[^:]*' : ""
    let key = a:key . '[bnflrxO0-9-]*'
    let val = substitute(&comments, '^\(.\{-},\)\{-}'. key .':\([^,]\+\).*$', '\2', '')
    if val == &comments
        let val = ''
    else
        let val = substitute(val, '%', '%%', 'g')
    endif
    let var = a:key == '' ? 'line' : a:key
    return 'let '. var .'="'. escape(val, '"') .'"'
endf

" s:GetCustomCommentString(ft, commentMode, ?default="")
function! s:GetCustomCommentString(ft, commentMode, ...)
    " TLogVAR a:ft, a:commentMode, a:000
    let commentMode   = a:commentMode
    let customComment = tcomment#TypeExists(a:ft)
    if commentMode =~# 'B' && tcomment#TypeExists(a:ft .'_block')
        let def = s:definitions[a:ft .'_block']
        " TLogVAR 1, def
    elseif commentMode =~? 'I' && tcomment#TypeExists(a:ft .'_inline')
        let def = s:definitions[a:ft .'_inline']
        " TLogVAR 2, def
    elseif customComment
        let def = s:definitions[a:ft]
        let commentMode = s:GuessCommentMode(commentMode)
        " TLogVAR 3, def
    elseif a:0 >= 1
        let def = {'commentstring': a:1}
        let commentMode = s:GuessCommentMode(commentMode)
        " TLogVAR 4, def
    else
        let def = {}
        let commentMode = s:GuessCommentMode(commentMode)
        " TLogVAR 5, def
    endif
    let cdef = copy(def)
    let cdef.mode = commentMode
    let cdef.filetype = a:ft
    " TLogVAR cdef
    return cdef
endf

function! s:GetCommentReplace(cdef, cms0)
    if has_key(a:cdef, 'commentstring_rx')
        let rs = s:BlockGetCommentString(a:cdef)
    else
        let rs = a:cms0
    endif
    return escape(rs, '"/')
endf

function! s:BlockGetCommentRx(cdef)
    if has_key(a:cdef, 'commentstring_rx')
        return a:cdef.commentstring_rx
    else
        let cms0 = s:BlockGetCommentString(a:cdef)
        let cms0 = escape(cms0, '\')
        return cms0
    endif
endf

function! s:BlockGetCommentString(cdef)
    if has_key(a:cdef, 'middle')
        return a:cdef.commentstring
    else
        return matchstr(a:cdef.commentstring, '^.\{-}\ze\(\n\|$\)')
    endif
endf

function! s:BlockGetMiddleString(cdef)
    if has_key(a:cdef, 'middle')
        return a:cdef.middle
    else
        return matchstr(a:cdef.commentstring, '\n\zs.*')
    endif
endf


function! tcomment#TextObjectInlineComment() "{{{3
    let cdef = tcomment#GuessCommentType({'commentMode': 'I'})
    let cms  = escape(cdef.commentstring, '\')
    let pos  = getpos('.')
    let lnum = pos[1]
    let col  = pos[2]
    let cmtf = '\V'. printf(cms, '\.\{-}\%'. lnum .'l\%'. col .'c\.\{-}')
    " TLogVAR cmtf, search(cmtf,'cwn')
    if search(cmtf, 'cw') > 0
        let pos0 = getpos('.')
        if search(cmtf, 'cwe') > 0
            let pos1 = getpos('.')
            exec 'norm!'
                        \ pos0[1].'gg'.pos0[2].'|v'.
                        \ pos1[1].'gg'.pos1[2].'|'.
                        \ (&sel == 'exclusive' ? 'l' : '')
        endif
    endif
endf


" vi: ft=vim:tw=72:ts=4:fo=w2croql
