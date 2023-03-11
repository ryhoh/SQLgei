import json
import math


CREDENTIAL = 'credential.json'


"""
認証情報の読み込み

:@return: 認証情報
"""
def load_credential() -> dict:
    with open(CREDENTIAL, 'r') as f:
        return json.load(f)

"""
    文字列が長すぎる場合に、末尾に...をつけて切り詰める
    最大文字数はrow_size_per_colで指定する
    ただし、日本語の場合は1文字をn文字分の長さとして扱う

    :@param string: 切り詰める文字列
    :@param max_size: 1項目の最大文字数
    :@param n: 1文字を何文字分の長さとして扱うか
    :@return: 切り詰め後の文字列
"""
def cut_string(string: str, max_size: int, n: float = 2.0) -> str:
    ascii_num = count_ascii(string)
    non_ascii_num = count_non_ascii(string)
    if ascii_num + non_ascii_num * n <= max_size:
        return string
    else:
        # 日本語の場合は1文字を2文字分の長さとして扱いつつ、切り詰める
        result = ''
        result_size = 0
        for c in string:
            if c.isascii():
                cur_size = 1
            else:
                cur_size = n
            
            if result_size + cur_size <= max_size - 3:  # 文字cを追加しても3文字分の余裕がある場合
                result += c  # 文字cを追加
                result_size += cur_size  # 文字cの長さを加算
            else:
                result += '...'  # 3文字分の余裕がない場合は...を追加して終了
                break
        return result

"""
文字列のうち、アスキー文字が何文字含まれているかを返す
"""
def count_ascii(s: str) -> int:
    return sum(c.isascii() for c in s)

"""
文字列のうち、アスキー文字以外が何文字含まれているかを返す
"""
def count_non_ascii(s: str) -> int:
    return len(s) - count_ascii(s)
