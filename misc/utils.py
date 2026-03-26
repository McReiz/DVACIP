import os
from pathlib import Path

def get_path():
	return Path(os.getcwd()).as_posix()

def get_path_parent():
	return Path(os.getcwd()).parent.as_posix()

def convert_path(tpath):
	return tpath.replace("/","\\\\")