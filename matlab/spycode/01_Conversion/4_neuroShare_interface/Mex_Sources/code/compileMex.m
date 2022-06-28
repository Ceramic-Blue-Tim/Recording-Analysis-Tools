function compileMex(pathMexCode)


currArch = computer('arch');
currArchExt = mexext;
if isempty(dir(fullfile(pathMexCode,'..',currArchExt)))
    switch currArchExt
        case 'mexglx'
            string2exec = strcat('mex -output', [' ' pathMexCode filesep '..' filesep], 'mexprog  -Dlinux -', currArch, '-ldl -v ', [' ' pathMexCode filesep], 'main.c', [' ' pathMexCode filesep], 'mexversion.c', [' ' pathMexCode filesep],  'ns.c');
            eval(string2exec);            
        case 'mexa64'
            string2exec = strcat('mex -output', [' ' pathMexCode filesep '..' filesep], 'mexprog  -Dlinux -' , currArch, '-ldl ', [' ' pathMexCode filesep], 'main.c', [' ' pathMexCode filesep], 'mexversion.c', [' ' pathMexCode filesep],  'ns.c');
            eval(string2exec);            
            
        case 'mexw32'
            string2exec = strcat('mex -output', [' ' pathMexCode filesep '..' filesep], 'mexprog  ' , [' ' pathMexCode filesep], 'main.c', [' ' pathMexCode filesep], 'mexversion.c', [' ' pathMexCode filesep],  'ns.c');
            eval(string2exec);
        case 'mexw64'
            string2exec = strcat('mex -output', [' ' pathMexCode filesep '..' filesep], 'mexprog  ', [' ' pathMexCode filesep], 'main.c', [' ' pathMexCode filesep], 'mexversion.c', [' ' pathMexCode filesep],  'ns.c');
            eval(string2exec);
        otherwise
            disp('Unknown current architecture. Impossible to create mex file. Program is exiting');
    end
    
end


