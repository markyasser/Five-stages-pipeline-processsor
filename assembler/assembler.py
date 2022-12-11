import re
assemblyFilePath = "assembly.txt"
outputPath = "binary.txt"

opcodeMap = {
    "NOP": "00000",
    "SETC":	"00001",
    "CLRC":	"00010",
    "OUT":  "00011",
    "IN":   "00100",
    "PUSH": "00101",
    "POP":  "00110",
    "LDD":  "00111",
    "JMP":  "01000",
    "JZ":   "01001",
    "JN":   "01010",
    "JC":   "01011",
    "STD": 	"01100",
    "CALL":	"01101",
    "RET":	"01110",
    "RTI":	"01111",
    "INC": 	"10000",
    "DEC": 	"10001",
    "MOV":  "10010",
    "ADD":  "10011",
    "NOT":  "10100",
    "SUB":  "10101",
    "AND":  "10110",
    "OR": 	"10111",
    "SHL": 	"11000",
    "SHR": 	"11001",
    "LDM": 	"11010"
}
regAddressMap = {
    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111",
}

def writeHexToFile(file,binary):
    file.write(f'{int(binary, 2):X}'+"\n")

def writeBinaryToFile(file,binary):
    file.write(binary+"\n")

def assemblyToBinary(line):
    instructionSplit = re.split(" |, ", line)
    instructionArray = []
    for i in range(len(instructionSplit)):
        if (instructionSplit[i] != ""):
            instructionArray.append(instructionSplit[i])
    print(instructionSplit)
    # print args
    opcode = "00000"
    rd = "000"
    rs = "000"
    shmnt = "00000"
    imm = ""
    if (len(instructionArray) == 1):
        opcode = opcodeMap[instructionArray[0].upper()]
        writeBinaryToFile(f_out, opcode+rs+rd+shmnt)
    if (len(instructionArray) == 2):
        opcode = opcodeMap[instructionArray[0].upper()]
        if instructionArray[1][0] == 'r':
            rd = regAddressMap[instructionArray[1].upper()]
        writeBinaryToFile(f_out, opcode+rs+rd+shmnt)
    elif (len(instructionArray) == 3):
        opcode = opcodeMap[instructionArray[0].upper()]
        if instructionArray[1][0] == 'r':
            rs = regAddressMap[instructionArray[1].upper()]
        if instructionArray[2][0] == 'r':
            rd = regAddressMap[instructionArray[2].upper()]
            writeBinaryToFile(f_out, opcode+rs+rd+shmnt)
        else:
            # Write immediate value
            writeBinaryToFile(f_out, opcode+rs+rd+shmnt)
    # if (instructionArray[0] == "mov"):
    #     if (len(instructionArray) != 3):
    #         return '', '', '', ''
    #     opcode = opcodeMap[instructionArray[0].upper()]
    #     if instructionArray[1][0] == 'r':
    #         rd = regAddressMap[instructionArray[1].upper()]
    #     if instructionArray[2][0] == 'r':
    #         rs = regAddressMap[instructionArray[2].upper()]
    #     f_out.write(opcode+rs+rd)
    # elif (instructionArray[0] == "add"):
    #     if (len(instructionArray) != 3):
    #         return '', '', '', ''
    #     opcode = opcodeMap[instructionArray[0].upper()]
    #     if instructionArray[1][0] == 'r':
    #         rd = regAddressMap[instructionArray[1].upper()]
    #     if instructionArray[2][0] == 'r':
    #         rs = regAddressMap[instructionArray[2].upper()]
    #     f_out.write(opcode+rs+rd)

    # # elif (instructionArray[0] == "sll"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 0
    # #     func = 0
    # #     rd = int(instructionArray[1][1:])
    # #     rs = int(instructionArray[2][1:])
    # #     rt = int(instructionArray[3][1:])
    # elif (instructionArray[0] == "sub"):
    #     if (len(instructionArray) != 3):
    #         return '', '', '', ''
    #     opcode = opcodeMap[instructionArray[0].upper()]
    #     if instructionArray[1][0] == 'r':
    #         rd = regAddressMap[instructionArray[1].upper()]
    #     if instructionArray[2][0] == 'r':
    #         rs = regAddressMap[instructionArray[2].upper()]
    #     f_out.write(opcode+rs+rd)
    # elif (instructionArray[0] == "and"):
    #     if (len(instructionArray) != 3):
    #         return '', '', '', ''
    #     opcode = opcodeMap[instructionArray[0].upper()]
    #     if instructionArray[1][0] == 'r':
    #         rd = regAddressMap[instructionArray[1].upper()]
    #     if instructionArray[2][0] == 'r':
    #         rs = regAddressMap[instructionArray[2].upper()]
    #     f_out.write(opcode+rs+rd)
    # elif (instructionArray[0] == "and"):
    #     if (len(instructionArray) != 3):
    #         return '', '', '', ''
    #     opcode = opcodeMap[instructionArray[0].upper()]
    #     if instructionArray[1][0] == 'r':
    #         rd = regAddressMap[instructionArray[1].upper()]
    #     if instructionArray[2][0] == 'r':
    #         rs = regAddressMap[instructionArray[2].upper()]
    #     f_out.write(opcode+rs+rd)
    # # elif (instructionArray[0] == "nand"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 0
    # #     func = 3
    # #     rd = int(instructionArray[1][1:])
    # #     rs = int(instructionArray[2][1:])
    # #     rt = int(instructionArray[3][1:])
    # # elif (instructionArray[0] == "nor"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 0
    # #     func = 4
    # #     rd = int(instructionArray[1][1:])
    # #     rs = int(instructionArray[2][1:])
    # #     rt = int(instructionArray[3][1:])
    # # elif (instructionArray[0] == "bez"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 1
    # #     rt = 0
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "bnez"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 1
    # #     rt = 1
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "bgez"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 1
    # #     rt = 2
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "blez"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 1
    # #     rt = 3
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "bgz"):
    # #     if (len(instructionArray) != 3):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 1
    # #     rt = 4
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "blz"):
    # #     if (len(instructionArray) != 3):
    # #         return 0
    # #     opcode = 1
    # #     rt = 5
    # #     rs = int(instructionArray[1][1:])
    # #     imm = int(instructionArray[2])
    # # elif (instructionArray[0] == "lw"):
    # #     if (instructionArray[-1] == ''):
    # #         instructionArray = instructionArray[0:-1]
    # #     if (len(instructionArray) != 3 and len(instructionArray) != 4):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 2
    # #     rt = int(instructionArray[1][1:])
    # #     if (len(instructionArray) == 3):
    # #         imm = 0
    # #         rs = int(instructionArray[2][1:])
    # #     else:
    # #         imm = int(instructionArray[2])
    # #         rs = int(instructionArray[3][1:])
    # # elif (instructionArray[0] == "sw"):
    # #     if (instructionArray[-1] == ''):
    # #         instructionArray = instructionArray[0:-1]
    # #     if (len(instructionArray) != 3 and len(instructionArray) != 4):
    # #         return 0, 0, 0, 0, 0, 0
    # #     opcode = 3
    # #     rt = int(instructionArray[1][1:])
    # #     if (len(instructionArray) == 3):
    # #         imm = 0
    # #         rs = int(instructionArray[2][1:])
    # #     else:
    # #         imm = int(instructionArray[2])
    # #         rs = int(instructionArray[3][1:])
    # # else:
    # #     return 0, 0, 0, 0, 0, 0
    return opcode, rs, rd, imm
    # pass



# -------------Main---------------
f = open(assemblyFilePath, "r")
f_out = open(outputPath, "w")


for line in f:
    if line[0] == "#" or line[0] == "" or line[0] == "\n":
        continue
    line = re.sub('\n', '', line)
    print(assemblyToBinary(line.lower()))
    pass

f_out.close()