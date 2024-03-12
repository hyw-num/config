"适配Linux子系统，能够正常和windows复制粘贴文本
"利用/mnt/c/Windows/System32/clip.exe
func! GetSelectedText()
    normal gv"xy
    let result = getreg("x")
    return result
endfunc
"if !has("clipboard") && executable("/mnt/c/Windows/System32/clip.exe")
"复制ctrl+y 
noremap <silent><C-y> :call system('/mnt/c/Windows/System32/clip.exe', GetSelectedText())<CR>
"剪切ctrl+x
noremap <silent><C-x> :call system('/mnt/c/Windows/System32/clip.exe', GetSelectedText())<CR>gvx
