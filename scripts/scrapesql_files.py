from genericpath import isfile
import os
import re
import json
import textwrap
from typing import Dict, List
from dataclasses import dataclass, asdict
from collections import Counter


@dataclass(frozen=True)
class PicoRuleDTO:
    name: str
    text: str
    is_active: bool
    
    def as_jsonable(self) -> Dict:
        return asdict(self)

BLOCKID_RGX = r"(?:rb\.blockid\s{0,}\:=\s{0,}\')(.*)(?:\')"
BLOCKBODY_RGX = r"(?:rb\.picoruleblock\s{0,}\:=\s{0,}\')([^\']*)(?:\')"
BLOCK_PH = "[[rb_id]]"
BLOCK_MATURITY_LEVEL = r"(?:is_active\s{0,}\:\s{0,})(0|1|2)"

PICORULE_FILE_PATH = "picorules"
PICORULE_FILE_EXT = "prb"

PICORULE_UNI_JSON_FILE_PATH = "json"
PICORULE_UNI_JSON_FILE = "picorule_uni.json"

#include_inactive_ruleblocks = True
#should_unindent = False
#should_replace_rbid = True


include_inactive_ruleblocks = True
should_unindent = True
should_replace_rbid = True


wd = os.path.abspath(os.getcwd())

output_directory = os.path.join(wd, PICORULE_FILE_PATH)
os.makedirs(output_directory, exist_ok=True )

file_list = []


def matchrgx(rgx: str, txt: str):

    return re.findall(rgx, txt)


def readfile(f):
    with open(f, "r") as txtfile:
        return txtfile.read().rstrip()

def minifytxt(s):
    return re.sub(r"\\s{2,}",r"\\s",s)

def writefile(fname, body):
    f_path = os.path.join(wd, PICORULE_FILE_PATH, fname)
    

    with open(f_path, "w") as f:
        f.write(body)


def processfiles():
    blockid_list = []
    blockbody_list = []
    files_created = 0

    picoRuleDTO_list = []

    for path in os.listdir(wd):

        if os.path.isfile(os.path.join(wd, path)):

            fs = readfile(path)
            
            # filter out lines that have been commented out of the PLSQL script
            fs = "\n".join(filter(lambda line: re.match(r"^\s*--", line) == None, fs.splitlines()))

            file_bids = matchrgx(BLOCKID_RGX, fs)
            if file_bids:
                blockid_list.append(file_bids)
                file_bids_size = len(file_bids)

                file_blockbodies = matchrgx(BLOCKBODY_RGX, fs)
                file_bmls = matchrgx(BLOCK_MATURITY_LEVEL, fs)
                if file_blockbodies:
                    file_blockbodies_size = len(file_blockbodies)
                    blockbody_list.append(file_blockbodies)

                if file_bids_size == file_blockbodies_size:
                    print(
                        f"file :{path} | {len(fs)} | ids : {file_bids_size} | bodies {file_blockbodies_size}"
                    )

                    for idx, file_bid in enumerate(file_bids):
                        if 1==1:
                            fb = textwrap.dedent(file_blockbodies[idx]).strip("\n")
                        else:
                            fb = "        " + file_blockbodies[idx].strip()
                            
                            newlines:list[str] = list()
                            lines = fb.splitlines()
                            
                            occurence_count = Counter([spaces for spaces in re.findall("^( *)", fb, flags=re.MULTILINE)])
                            probable_indent = len(occurence_count.most_common(1)[0][0])

                            for line in lines:
                                #un-indent
                                if should_unindent:
                                    line = re.sub(f"^ {{0,{probable_indent}}}", "", line)
                                    line = line.rstrip(' ')

                                newlines.append(line)
                            
                            fb = "\n".join(newlines)
                        
                        if should_replace_rbid:
                            fb = fb.replace(BLOCK_PH, file_bid)
                        

                        #fb = minifytxt(fb)
                        # is_active = True if int(file_bmls[idx])>0 else False
                        active_flag = int(file_bmls[idx]) >= 2

                        print(
                            f"----> writing [{idx}]:active:[{file_bmls[idx]}] | {file_bid} : "
                        )

                        if include_inactive_ruleblocks or active_flag:
                            picoRuleDTO_list.append(
                                PicoRuleDTO(name=file_bid, text=fb, is_active=active_flag)
                            )

                        try:
                            writefile(file_bid + '.' + PICORULE_FILE_EXT, fb)
                            files_created += 1

                        except:
                            print("----> File write Exception!!")
    print(f"Total files created : {files_created}")
    
    if False:   #the combined json file is now managed by picorules_tool.py in the picodomain repository
        #properties are serialized to json in a non deterministic order
        #json_body = PicoRuleDTO.schema().dumps(picoRuleDTO_list, many=True, indent=2, sort_keys=None)

        picoRuleDTO_list = sorted(picoRuleDTO_list, key=lambda pr:pr.name)
        
        #properties seem to be serialized to json in a deterministic order (and in the order as defined in the PicoRuleDTO class)
        json_body = json.dumps(picoRuleDTO_list, default=lambda o: o.as_jsonable(), indent=2)

        try:
            with open(
                os.path.join(wd, PICORULE_UNI_JSON_FILE_PATH, PICORULE_UNI_JSON_FILE), "w"
            ) as json_file:
                json_file.write(json_body)
            print("----> Unified json file created")
        except:
            print("----> Unified json file couldnt be created!!")


if __name__ == "__main__":
    processfiles()
    # writefile('test2.picorule','test text')
