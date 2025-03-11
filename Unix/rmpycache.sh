#!/bin/bash

# (src: https://stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script and https://stackoverflow.com/questions/5474732/how-can-i-add-a-help-method-to-a-shell-script)
usage="${0##*/} [-h] ROOT_DIRECTORY TO_DELETE_SUBDIR -- Script to delete specified directories and their contents (default: __pycache__)

Options:
	 -h			Show help text
	ROOT_DIRECTORY		Specify the root directory where __pycache__ directories are located.
				You can use absolute paths (e.g., /home/user/Downloads/venv) or relative paths (e.g., ../../Downloads/venv)
	TO_DELETE_SUBDIR	Name of directories to delete along with all their contents (default: __pycache__)
				If specified, any directories with this name and their contents will be deleted recursively under ROOT_DIRECTORY.

Examples:
	${0##*/}                     # Deletes all __pycache__ directories and their contents in the current directory
	${0##*/} /path/to/root       # Deletes all __pycache__ directories and their contents in the specified root directory
	${0##*/} . temp              # Deletes all 'temp' directories and their contents in the current directory (use with caution)"

if [[ "$1" == "-h" ]]; then
  echo "$usage"
  exit 0
fi

# Setting default variables (src: https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html)
root_dir="${1:-.}"
delete_dir="${2:-__pycache__}"

# src: https://www.baeldung.com/linux/find-delete-files-directories
if find "$root_dir" -type d -name "$delete_dir" | grep -q .; then
  if find "$root_dir" -type d -name "$delete_dir" -exec rm -r {} +; then
    echo "$delete_dir directories under '$root_dir' were successfully deleted."
    exit 0
  else
    echo "Error: Failed to delete '$delete_dir' directories under '$root_dir'."
    echo "Please check the following:"
    echo "  - Check if you have the necessary permissions to delete these directories and their contents."
    echo "  - If the directories are write-protected, try running the script with elevated privileges (e.g., using 'sudo')."
    exit 1
  fi
else
  echo "No '$delete_dir' directories found under '$root_dir'."
  echo "Please check the following:"
  echo "  - Ensure that the root directory ('$root_dir') exists and is accessible."
  echo "  - Verify that directories named '$delete_dir' exist under the specified root directory."
  exit 0
fi
