let g:DUMMY_SCOPE_CONTENT = {'abc': 'ABC', 'def': 'DEF'}
let g:dummy_scope = deepcopy(g:DUMMY_SCOPE_CONTENT)
let g:the_reference_of_dummy_scope = g:dummy_scope
call vspec#hint({'scope': 'g:dummy_scope'})

describe ':ResetContext'
  it 'should reset to the state when vspec#hint() is called'
    Expect g:dummy_scope ==# g:DUMMY_SCOPE_CONTENT

    let g:dummy_scope['abc'] = 'aabbcc'  " Modify an existing variable.
    unlet g:dummy_scope['def']  " Delete an existing variable.
    let g:dummy_scope['ghi'] = 'gghhii'  " Add a new variable.

    ResetContext

    Expect g:dummy_scope ==# g:DUMMY_SCOPE_CONTENT
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope
  end
end

describe ':SaveContext'
  it 'should save the current state for :ResetContext'
    ResetContext

    Expect g:dummy_scope ==# g:DUMMY_SCOPE_CONTENT
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope

    let g:dummy_scope['abc'] = 'aabbcc'  " Modify an existing variable.
    unlet g:dummy_scope['def']  " Delete an existing variable.
    let g:dummy_scope['ghi'] = 'gghhii'  " Add a new variable.
    SaveContext

    Expect g:dummy_scope ==# {'abc': 'aabbcc', 'ghi': 'gghhii'}
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope

    let g:dummy_scope['abc'] = 'cba'
    let g:dummy_scope['def'] = 'fed'
    unlet g:dummy_scope['ghi']

    Expect g:dummy_scope ==# {'abc': 'cba', 'def': 'fed'}
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope

    ResetContext

    Expect g:dummy_scope ==# {'abc': 'aabbcc', 'ghi': 'gghhii'}
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope

    call filter(g:dummy_scope, '0')
    call extend(g:dummy_scope, deepcopy(g:DUMMY_SCOPE_CONTENT), 'force')

    Expect g:dummy_scope ==# g:DUMMY_SCOPE_CONTENT
    Expect g:dummy_scope is# g:the_reference_of_dummy_scope
  end
end
