import time
import json

def split_input(s):
	l = []
	a = s[0]
	s = s[1:]
	for i in s:
		if i == '+' or i == '-':
			l.append(a)
			a = i
		else:
			a += i
	l.append(a)
	return l

def call_whatsat(inp):
	print inp

def call_iamat(inp):
	l = split_input(inp[1])
	print("{} is at {},{}\n".format(inp[0],l[0],l[1]))
	t = time.time() - float(inp[2])
	print("time passed = +{0}".format(t))

def main():
	command = raw_input()
	inp = command.split(' ')
	if(inp[0] == 'WHATSAT'):
		call_whatsat(inp[1:])
	elif(inp[0] == 'IAMAT'):
		call_iamat(inp[1:])
	else:
		print('? {0}'.format(command))

if __name__ == '__main__':
	main()