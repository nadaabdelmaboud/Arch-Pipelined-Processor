import re
from bitarray import bitarray
from bitarray.util import ba2hex, int2ba

path = input("please enter your code path : ")

# reading code lines
with open(path) as f:
    lines = f.readlines()


# ===============================
# ========  FIRST PASS  =========
# ===============================

# this pass aims to remove any unnecessary lines and comments
# also aims to save labels and variables addresses

current_address = 0
new_lines = []
addresses = []
labels = {}
reserved_words = ['nop', 'setc', 'clrc', 'mov', 'add', 'sub', 'and', 'or', 'clr', 'not', 'inc', 'dec', 'neg', 'rlc', 'rrc', 'jz', 'jn', 'jc', 'jmp', 'out', 'in', 'iadd',
                  'shl', 'shr', 'ldm', 'ldd', 'std', 'call', 'ret', 'push', 'pop', 'org']
for line in lines:

    # remove trailing whitespaces
    line = " ".join(line.split())

    # remove comments
    contains_comment = line.find("#")
    if contains_comment != -1:
        line = line[:contains_comment]

    # remove empty lines
    if not (len(line)):
        continue

    # separating operands
    line = " ".join(line.replace(",", " ").split())

    # updating current address
    if(re.search(".=", line)):
        current_address = int(line.replace('=', " ").split()[1])
        continue

    # defining labels addresses
    contains_label = line.find(":")
    if contains_label != -1:
        labels[line[:contains_label].split()[0].lower()] = current_address
        line = line[contains_label+1:]
        if not len(line):
            continue

    addresses.append(current_address)
    line = line.split()
    current_address += 1
    for i in range(0, len(line)):
        if line[i].lower() == 'define':
            labels[line[i+1]] = current_address
            break
        elif line[i][0].lower() == 'b':
            # to avoid occupying an extra word for branch instructions
            break
        elif((re.search(r"(#(?=[0-9]))", line[i]) and (i == 1)) or  # (#(?=[0-9])) -> immadiate mode
             (re.search(r"([0-9]+\([rR][0-7]\))", line[i])) or
             # ([jJ][sS][rR]) -> JSR instruction
             (re.search(r"([jJ][sS][rR])", line[i])) or
             (re.search(r"((?![rR][0-7])[a-zA-Z])", line[i]) and (line[i].lower() not in reserved_words))):  # ((?![rR][0-7])[a-zA-Z]) -> relative mode
            current_address += 1

    # new_lines array contains actual code lines
    # without comments and labels
    if line[i].lower() != 'define':
        new_lines.append(line)


# ===============================
# ========  SECOND PASS  ========
# ===============================

# this pass aims to convert code lines to binary

# done
operands_2 = {
    # format
    # 4 bits opcode
    # 6 bits src & 6 for dst
    'mov': '000011',
    'add': '000100',
    'sub': '000101',
    'and':  '000110',
    'or': '000111'
}
# done
no_operands = {
    'nop': '0000000000000000',
    'setc': '0000010000000000',
    'clrc': '0000100000000000',
    'ret':  '1010010000000000'
}
# done
operands_1 = {
    # 1 operand instructions
    # format
    # 5 bits to determine it's a 1 operand
    # 5 bits for opcode
    # 6 bits for operand
    'clr': '001000',
    'not': '001001',
    'inc': '001010',
    'dec': '001011',
    'neg': '001100',
    'rlc': '001101',
    'rrc': '001110'
}
imidite = {
    # branch instructions
    # format
    # 4 bits to determine it's a branch
    # 4 for opcode
    # 8 for address
    'iadd':  '010000',
    'shl': '010001',
    'shr': '010010',
    'ldm': '010011',
    'ldd': '010100',
    'std': '010101'
}
# done
inOrOut = {
    # no operands
    'out': '011000',
    'in': '011001'
}
# done
jump = {
    # Jump sub-routine
    # format
    # 4 bits to determine it's a jsr
    # 2 for opcode
    # 3 for register
    # 7 for address
    'jz':  '100000',
    'jn':  '100001',
    'jc':  '100010',
    'jmp': '100011'
}
# done
stack = {
    'call':  '101000',
    'push':  '101010',
    'pop': '101011'
}

regs = {
    'r0': '00000',
    'r1': '00001',
    'r2': '00010',
    'r3': '00011',
    'r4': '00100',
    'r5': '00101',
    'r6': '00110',
    'r7': '00111',
}


def define_register(reg):
    if re.search('[rR]0', reg):
        return regs['r0']
    elif re.search('[rR]1', reg):
        return regs['r1']
    elif re.search('[rR]2', reg):
        return regs['r2']
    elif re.search('[rR]3', reg):
        return regs['r3']
    elif re.search('[rR]4', reg):
        return regs['r4']
    elif re.search('[rR]5', reg):
        return regs['r5']
    elif re.search('[rR]6', reg):
        return regs['r6']
    elif re.search('[rR]7', reg):
        return regs['r7']


# memory array
memory = ['0000'] * 2048


reached = 0
for i in range(len(new_lines)):
    instruction = new_lines[i][0].lower()
    # index to the next byte if the instruction requires 2 words or more
    counter = 1
    print(addresses[i])
    # no operand instructions
    if instruction in no_operands.keys():
        word_binary = no_operands[instruction]

    elif instruction in imidite.keys():

        word_binary = imidite[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
        word = new_lines[i][2]
        memory[addresses[i] +
               counter] = str(ba2hex(int2ba(int(word), length=16, signed=False)))
        try:
            addresses[i+1] += counter
        except IndexError:
            pass

    # 1 operand instructions
    elif instruction in operands_1.keys():
        word_binary = operands_1[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)

    # 2 operands instructions
    elif instruction in operands_2.keys():
        word_binary = (operands_2[instruction])
        # for loop to check the 2 operands
        for j in [1, 2]:
            word = new_lines[i][j]
            word = word.lower()
            # register
            word_binary += define_register(word)

    # jump instructions
    elif instruction in jump.keys():
        word_binary = jump[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
    # In or out instructions
    elif instruction in inOrOut.keys():
        word_binary = inOrOut[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
    # stack instructions
    elif instruction in stack.keys():
        word_binary = stack[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)

    elif new_lines[i][0].lower() == '.org':
        add = new_lines[i][1]
        addresses[i] = new_lines[i][1]
        pass

    elif new_lines[i][0].isnumeric():
        word_binary = int2ba(int(new_lines[i][0]))
    else:
        raise Exception("Invalid syntax")
    memory[addresses[i]] = str(ba2hex(bitarray(word_binary)))


with open('memory.mem', 'w') as f:
    f.write("// instance=/ram/ram\n")
    f.write("// format=mti addressradix=d dataradix=h version=1.0 wordsperline=1\n")
    for i, item in enumerate(memory):
        f.write("%d: %s\n" % (i, item))
