import os
import re
import json
from typing import Dict, List
from dataclasses import dataclass, asdict


@dataclass(frozen=True)
class PicoRuleBlock:
    name: str
    text: str
    is_active: bool

    def as_jsonable(self) -> Dict:
        return asdict(self)


def read_sql_file(file_path: str):
    with open(file_path, "r") as f:
        return f.read()


def extract_prb_from_sql(sql_text: str) -> List[PicoRuleBlock]:
    prb_name_pattern = r"^(?:[ \t]*)rb\.blockid(?:\W*):=(?:\W*)'([\w]*)';"
    prb_text_pattern = r"^(?:[ \t]*)rb\.picoruleblock(?:\W*):=(?:\W*)'([\w\W]+?)';"
    prb_names: List[str] = re.findall(prb_name_pattern, sql_text, flags=re.M)
    prb_texts: List[str] = re.findall(prb_text_pattern, sql_text, flags=re.M)
    # fail if it didnt find an equal amount of prb names and contents
    assert len(prb_names) == len(prb_texts)
    return [
        PicoRuleBlock(name.strip(), text.strip(), True)
        for name, text in zip(prb_names, prb_texts)
        if "test" not in name
    ]


def write_to_json(
    prb_collection: List[PicoRuleBlock], output_path: str = "./prb_latest.json"
):
    with open(output_path, "w+") as f:
        json.dump(prb_collection, f, default=lambda o: o.as_jsonable(), indent=2)


if __name__ == "__main__":

    import_dir = "./"
    file_filter = "insert-ruleblock"
    output_path: str = "./json/prb_latest.json"

    prb_collection: List[PicoRuleBlock] = []
    for file in os.listdir(import_dir):
        if file_filter in file:
            print("processing file:", file)
            file_path = os.path.join(import_dir, file)
            sql_text = read_sql_file(file_path)
            prb_collection.extend(extract_prb_from_sql(sql_text))

    write_to_json(prb_collection, output_path)
    print("found", len(prb_collection), "ruleblocks", "exported to", output_path)
