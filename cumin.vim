let g:airline#themes#cumin#palette = {}

let g:airline#themes#cumin#palette.accents = {
      \ 'red': [ '#66d9ef' , '' , 81 , '' , '' ],
      \ }


" Normal mode
let s:N1 = [ '#080808' , '#e6db74' , 188 ,  2  ] " mode
let s:N2 = [ '#f8f8f0' , '#232526' ,  58 , 235 ] " info
let s:N3 = [ '#f8f8f0' , '#465457' , 250 ,  4  ] " statusline

let g:airline#themes#cumin#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#cumin#palette.normal_modified = {
      \ 'airline_c': [ '#080808' , '#e6db74' , 188 , 2 , '' ] ,
      \ }


" Insert mode
let s:I1 = [ '#080808' , '#66d9ef' , 232 , 188 ]
let s:I2 = [ '#f8f8f0' , '#232526' , 58 , 235 ]
let s:I3 = [ '#f8f8f0' , '#465457' , 188 ,  2 ]

let g:airline#themes#cumin#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#cumin#palette.insert_modified = {
      \ 'airline_c': [ '#080808' , '#66d9ef' , 232 , 81 , '' ] ,
      \ }


" Replace mode
let g:airline#themes#cumin#palette.replace = copy(g:airline#themes#cumin#palette.insert)
let g:airline#themes#cumin#palette.replace.airline_a = [ s:I1[0]   , '#ef5939' , s:I1[2] , 166     , ''     ]
let g:airline#themes#cumin#palette.replace_modified = {
      \ 'airline_c': [ '#080808' , '#ef5939' , 232 , 166 , '' ] ,
      \ }


" Visual mode
let s:V1 = [ '#080808' , '#fd971f' , 22  , 148  ]
let s:V2 = [ '#f8f8f0' , '#232526' , 58 , 235  ]
let s:V3 = [ '#f8f8f0' , '#465457' , 237 , 252   ]

let g:airline#themes#cumin#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#cumin#palette.visual_modified = {
      \ 'airline_c': [ '#080808' , '#fd971f' , 232 , 208 , '' ] ,
      \ }


" Inactive
let s:IA = [ '#1b1d1e' , '#465457' , 233 , 67 , '' ]
let g:airline#themes#cumin#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#cumin#palette.inactive_modified = {
      \ 'airline_c': [ '#f8f8f0' , ''        , 253 , ''  , '' ] ,
      \ }
      
let s:WI = [ '#ffffff', '#5f0000', 232, 137 ]
let g:airline#themes#cumin#palette.normal.airline_warning = [
     \ s:WI[0], s:WI[1], s:WI[2], s:WI[3]
     \ ]

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#cumin#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#f8f8f0' , '#465457' , 253 , 67  , ''     ] ,
      \ [ '#f8f8f0' , '#232526' , 253 , 16  , ''     ] ,
      \ [ '#080808' , '#e6db74' , 232 , 144 , 'bold' ] )

