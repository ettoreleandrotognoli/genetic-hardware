import serial
import time

def hex_to_bin(hex_string):
    if hex_string.startswith('0x'):
        hex_string = hex_string[2:]
    hex_string = hex_string.replace(' ','')
    return bin(int(hex_string,16))[2:]


def decode_command(bincmd,first=False):
    el = bincmd[0:9]
    morphOp = bincmd[9:12]
    morphInSelect = bincmd[12]
    logicOp = bincmd[13:17]

    morhpInput = 'Img' if morphInSelect == '1' or first else 'ImgAcc'
    return 'Input:%s\nMorph:%s\n%s\nLogic:%s' % (
        morhpInput,
        decode_morph_op(morphOp),
        el,
        decode_logic_op(logicOp)
    )

def decode_gen(gen):
    gen = hex_to_bin(gen)
    if (len(gen) % 16) is not 0:
        gen = '0' * (16 - (len(gen) % 16))  + gen
    print gen
    first = True
    for i in range(len(gen),0,-16):
        print decode_command(gen[i-16:i],first)
        first = False
        
    
    

def decode_logic_op(logicOp):
    index = int(logicOp,2)
    ops = [
        'Acc Bypass',
        'Morph Bypass',
        'Not Acc',
        'Not Morph',
        'Acc & Morph',
        'Acc | Morph',
        'Acc ^ Morph',
        '~( Acc ^ Morph)'
    ]
    return ops[index]


def decode_morph_op(morphOp):
    index = int(morphOp,2)
    ops = [
        'Bypass',
        'Dil',
        'Ero',
        'Dil Ero',
        'Ero Dil',
        'Dil Dil',
        'Ero Ero',
    ]
    return ops[index]
    

class FPGA(object):

    def __init__(self,port='/dev/ttyUSB0',baud_rate=4800):
        self.tty = serial.Serial(port,baud_rate)
    
    def solve(self,img_pair):
        data = img_pair.decode('hex')
        start_time = time.time()
        self.tty.write(data)
        response = self.tty.read(8)
        end_time = time.time()
        response ="".join([ ("%02x" % ord(byte)) for byte in response])
        duration = end_time - start_time
        return {
            'time' : duration,
            'error' : int(response[0:4],16),
            'cycles' : int(response[4:8],16),
            'gen' : response[8:16]
        }

    def benchmark(self,img_pair,times=100):
        ans = [ self.solve(img_pair) for i in range(times)]
        avg_time = sum([i['time'] for i in ans])/len(ans)
        avg_error = sum([i['error'] for i in ans])/len(ans)
        avg_cycles = sum([i['cycles'] for i in ans])/len(ans)
        solutions = {}
        for i in ans:
            if i['gen'] not in solutions:
                solutions[i['gen']] = 1
                continue
            solutions[i['gen']] += 1
        return {
            'time':avg_time,
            'error':avg_error,
            'cycles':avg_cycles,
            'solutions' : solutions,
            #'data' : ans
        }
        

images = [
    "10381000387c3810",
    "00100000387c3810",
    "00100000386c3810",
    "00181800183c3c18",
    "0040040040e44e04",
]

fpga = FPGA()

for img_pair in images:
    print img_pair
    print fpga.benchmark(img_pair)
        
    
    

