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
                  'shl', 'shr', 'ldm', 'ldd', 'std', 'call', 'ret', 'push', 'pop']

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
    'ldm': '010011'

}
memImid = {
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
    if(re.search(r".[oO][rR][gG]", line)):
        current_address = int(line.split()[1], base=16)
        continue

    addresses.append(current_address)
    line = line.split()
    current_address += 1
    if line[0].lower() in imidite.keys():
        current_address += 1
    if line[0].lower() in memImid.keys():
        current_address += 1
    # new_lines array contains actual code lines
    # without comments and labels

    new_lines.append(line)


# ===============================
# ========  SECOND PASS  ========
# ===============================

# this pass aims to convert code lines to binary

# done


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
memory = ['0000'] * 1048575


reached = 0
print(new_lines)
for i in range(len(new_lines)):
    instruction = new_lines[i][0].lower()
    # index to the next byte if the instruction requires 2 words or more
    counter = 1
    # no operand instructions
    if instruction in no_operands.keys():
        word_binary = no_operands[instruction]

    elif instruction in imidite.keys():
        e = "error here immidiate"
        word_binary = imidite[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
        word = new_lines[i][2]
        memory[addresses[i] +
               counter] = str(ba2hex(bitarray(int2ba(int(word, base=16), length=16))))

    # 1 operand instructions
    elif instruction in operands_1.keys():
        e = "error here 1"
        word_binary = operands_1[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)

    # 2 operands instructions
    elif instruction in operands_2.keys():
        e = "error here 2"
        word_binary = (operands_2[instruction])
        # for loop to check the 2 operands
        for j in [1, 2]:
            word = new_lines[i][j]
            word = word.lower()
            # register
            word_binary += define_register(word)

    # jump instructions
    elif instruction in jump.keys():
        e = "error here jump"
        word_binary = jump[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
    # In or out instructions
    elif instruction in inOrOut.keys():
        e = "error here inout"
        word_binary = inOrOut[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)
    # stack instructions
    elif instruction in stack.keys():
        e = "error here stack"
        word_binary = stack[instruction]
        word = new_lines[i][1]
        word = word.lower()
        word_binary += '00000'
        word_binary += define_register(word)

    elif instruction in memImid.keys():
        e = "error here stack"
        word_binary = memImid[instruction]
        word = new_lines[i][1].lower()
        word_binary += define_register(word)
        secWord = new_lines[i][2].lower()
        ina = secWord.find("(")
        value = secWord[0:ina]
        reg2 = secWord[ina+1:len(secWord)-1]
        word_binary += define_register(reg2)
        memory[addresses[i] +
               counter] = str(ba2hex(bitarray(int2ba(int(value, base=16), length=16))))

    elif instruction.isnumeric():
        word_binary = int2ba(int(new_lines[i][0], base=16), length=16)

    else:
        print(instruction)
        raise Exception("Invalid syntax")
    memory[addresses[i]] = str(ba2hex(bitarray(word_binary)))


with open('memory.mem', 'w') as f:
    f.write("// instance=/ram/ram\n")
    f.write("// format=mti addressradix=d dataradix=h version=1.0 wordsperline=1\n")
    for i, item in enumerate(memory):
        f.write("%s\n" % (item))
