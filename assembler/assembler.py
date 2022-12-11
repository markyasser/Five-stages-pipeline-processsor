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
        if instructionArray[0].upper() == "LDM":
            opcode = opcodeMap[instructionArray[0].upper()]
            rd = regAddressMap[instructionArray[1].upper()]
            imm = f'{int(instructionArray[2]):016b}'
            writeBinaryToFile(f_out, opcode+"000"+rd+shmnt)
            writeBinaryToFile(f_out, imm)
        elif instructionArray[0].upper() == "SHL" or instructionArray[0].upper() == "SHR":
            opcode = opcodeMap[instructionArray[0].upper()]
            rs = regAddressMap[instructionArray[1].upper()]
            shmnt = f'{int(instructionArray[2]):05b}'
            writeBinaryToFile(f_out, opcode+rs+"000"+shmnt)
        else:
            opcode = opcodeMap[instructionArray[0].upper()]
            if instructionArray[1][0] == 'r':
                rs = regAddressMap[instructionArray[1].upper()]
            if instructionArray[2][0] == 'r':
                rd = regAddressMap[instructionArray[2].upper()]
                writeBinaryToFile(f_out, opcode+rs+rd+shmnt)
    return opcode, rs, rd, shmnt,imm


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