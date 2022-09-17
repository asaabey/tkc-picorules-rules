from genericpath import isfile
import os
import re

BLOCKID_RGX = r'(?:rb\.blockid\s{0,}\:=\s{0,}\')(.*)(?:\')'
BLOCKBODY_RGX = r'(?:rb\.picoruleblock\s{0,}\:=\s{0,}\')([^\']*)(?:\')'

PICORULE_FILE_PATH = 'picorule_fmt'

wd = os.path.abspath(os.getcwd())
file_list = []

def matchrgx(rgx : str, txt : str):
    
    return re.findall(rgx, txt)




def readfile(f):
    with open(f, 'r') as txtfile:
        return txtfile.read().rstrip()

def writefile(fname, body):
    
    f_path = os.path.join(wd,PICORULE_FILE_PATH,fname)

    with open(f_path, 'w') as f:
        f.write(body)


def processfiles():
    blockid_list = []
    blockbody_list = []

    for path in os.listdir(wd):

        if os.path.isfile(os.path.join(wd,path)):
            
            fs = readfile(path)
            
            file_bids = matchrgx(BLOCKID_RGX, fs)
            if file_bids:
                blockid_list.append(file_bids)
                file_bids_size = len(file_bids)

                file_blockbodies = matchrgx(BLOCKBODY_RGX, fs)
                if file_blockbodies:
                    file_blockbodies_size = len(file_blockbodies)
                    blockbody_list.append(file_blockbodies)
                
                if file_bids_size == file_blockbodies_size:            
                    print(f'file :{path} | {len(fs)} | ids : {file_bids_size} | bodies {file_blockbodies_size}')
                    
                    for idx, file_bid in enumerate(file_bids):
                        fb = file_blockbodies[idx]
                        print(f'----> [{idx}]: {file_bid}' | fb[1..20])
            


if __name__ == '__main__':
    processfiles()
