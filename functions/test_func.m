function test_func(a,b)
	if a == 1
		disp("a is one")
	else
		disp("a does not equal one")
    end
    
    if exist(b,'var')
        disp('second variable added')
    else
        disp('only one variable')
end