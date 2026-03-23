function result = pythonExePath(app)
% PYTHONEXEPATH  Return the path to the Python interpreter.
%
% Prefers the project venv at .venv/bin/python. If the venv does not exist,
% returns 'python3' to use the system Python and global dependencies.
venv_python = fullfile(app.currentFolder, '..', '..', '..', '.venv', 'bin', 'python');
if isfile(venv_python)
    result = venv_python;
else
    result = 'python3';
end
end
