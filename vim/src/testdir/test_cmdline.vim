" Tests for editing the command line.

func Test_complete_tab()
  call writefile(['testfile'], 'Xtestfile')
  call feedkeys(":e Xtest\t\r", "tx")
  call assert_equal('testfile', getline(1))
  call delete('Xtestfile')
endfunc

func Test_complete_list()
  " We can't see the output, but at least we check the code runs properly.
  call feedkeys(":e test\<C-D>\r", "tx")
  call assert_equal('test', expand('%:t'))
endfunc

func Test_complete_wildmenu()
  call writefile(['testfile1'], 'Xtestfile1')
  call writefile(['testfile2'], 'Xtestfile2')
  set wildmenu
  call feedkeys(":e Xtest\t\t\r", "tx")
  call assert_equal('testfile2', getline(1))

  call delete('Xtestfile1')
  call delete('Xtestfile2')
  set nowildmenu
endfunc
