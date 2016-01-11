# Utility scripts

Some usefull scripts.

## Share files

`share_files.sh`

Copy local files to your own server. Possibility to mark files secret so a
different location will be used.

| Flag | Description                           |
| ---- | ------------------------------------- |
| -f   | a file or a list of files in a string |
| -s   | use a secret location for files       |

One file:
`./share_files -f file`

Multiple files:
`./share_files -f "file1 file2"`

Secret files:
`./share_files -s -f secret_file`


## Share screenshot

`share_ss.sh`

Take a screenshot from selected area, copy it to the server and add image URL
to the clipboard.

Dependencies: `ImageMagick`

| Flag | Description                     |
| ---- | ------------------------------- |
| -k   | appends `-keep` to the file name|

`./share_ss`

`./share_ss -k`