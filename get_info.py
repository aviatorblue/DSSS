#! /usr/bin/python

import sys, re, os
import binascii

def run(website):
	import urllib2
	response = urllib2.urlopen(website)
	html = response.read()
	string = html[50:150]
	bin = binascii.crc32(string)	
	return bin

def main():
	info = run('http://www.google.com')
	info = list(str(info))
	file = open('info.txt', 'w')
	info_string = '[' + ','.join(info) + ']'
	file.write(info_string)
	file.close()

if __name__ == "__main__":
	main()
	sys.exit()
