import os
from pathlib import Path

def get_path():
	return Path(os.getcwd()).as_posix()

def convert_path(tpath):
	return tpath.replace("/","\\\\")