#!/usr/bin/env python

'''
converts a number of .abi files to a multiple fastq file
'''
#@author: Philipp Sehnert
#@contact: philipp.sehnert[a]gmail.com

# imports
import sys, os
from argparse import ArgumentParser
from Bio import SeqIO
import shutil


def convert2fastq(input, output):
	for file in os.listdir(input):
		if file.endswith(".ab1"):
			abi = open(input + os.sep + file, 'rb')
			tmp = output + os.sep + "tmp"
			if not os.path.exists(tmp):
				os.makedirs(tmp)
			out = tmp + os.sep + str(file).split('.')[0] + '.fastq'
			SeqIO.convert(abi , 'abi', out, 'fastq')
	return(tmp)

def combineFastq(folder, outname):
	outfile = open(outname, 'w')
	for file in os.listdir(folder):
		infile = open(folder + os.sep + file, 'r')
		outfile.write(infile.read())

def main(argv = None):

  # Setup cmd interface
  parser = ArgumentParser(description = '%s -- description' % 
                         (os.path.basename(sys.argv[0])),
                          epilog = 'created by Philipp Sehnert',
                          add_help = True)
  parser.add_argument('--version', action = 'version', version = '%s 1.0' % 
                     (os.path.basename(sys.argv[0])))
  parser.add_argument('-i', dest = 'input', help = 'input folder', required = True)
  parser.add_argument('-o', dest = 'output', help = 'output folder', required = True)
  parser.add_argument('-n', dest = 'name', help = 'name for output file', required = True)
  # parse cmd arguments
  args = parser.parse_args()
  
  if __name__ == '__main__':
  	tmp = convert2fastq(args.input, args.output)
  	print tmp
  	combineFastq(tmp, args.output + os.sep + args.name + '.fastq')
  	shutil.rmtree(tmp, ignore_errors=True)


sys.exit(main())
