#!/usr/bin/env python

'''
little script for converting the fourth field in a bed file to have generic names and setting the score to example value of 100
'''
#@author: Philipp Sehnert
#@contact: philipp.sehnert[a]gmail.com

# imports
import sys, os
from argparse import ArgumentParser
import shlex

def main(argv = None):

  # Setup cmd interface
  parser = ArgumentParser(description = '%s -- converting bed files to have generic name and a generic score' % 
                         (os.path.basename(sys.argv[0])),
                          epilog = 'created by Philipp Sehnert',
                          add_help = True)
  parser.add_argument('--version', action = 'version', version = '%s 1.0' % 
                     (os.path.basename(sys.argv[0])))
  parser.add_argument('-i', dest = 'input', required = True,
                      help = 'input file in bed format')
  parser.add_argument('-o', dest = 'output', default = '.', required = True,
                      help = 'location for output files (default = .)')
  # parse cmd arguments
  args = parser.parse_args()
  # define input
  input = args.input
  
  if __name__ == '__main__':
    
    # open the input und output file
    input = open(args.input, "r")
    output = open(args.output, "w")
    # init counting variable
    count = 0
    # iterate line by line over file
    for line in input:
      # split the line into fields
      x = line.split("\t")
      # assign name to the third field
      x[3] = "read%d" % (count)
      # assign example score for the field
      x[4] = "100"
      # increase the count
      count = count + 1 
      # write converted line to output
      output.write("\t".join(x))
    # close file connections
    input.close
    output.close

sys.exit(main())
