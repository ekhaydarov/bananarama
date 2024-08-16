logparser-sh:
	cat test/logs.txt | cut -d ' ' -f 2 | uniq -c | sort -bgr

logparser-py:
	python3 logparser.py