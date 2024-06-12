# -*- coding:utf-8 -*-
import re

pattern = r'\[(.*?)\]'    # 正则表达式: 找到所有中括号内的内容（不包括中括号本身）
LABEL = 'SpecialLabel'

def renumber_citations_by_order(text):
    """
    将非数字形式的文献引用标签（如[a1], [temp2]等）按照在正文中出现的顺序重新排序为数字序列形式。

    假设:
    - 文本中的引用形式为非数字标签，如[a1], [temp2]等
    - 文献列表在文本末尾，每个文献条目间以两个换行符分隔

    参数:
    text (str): 包含文献引用和列表的文本。

    返回:
    str: 文献引用被重新编号为[1], [2], ... ，并按正文出现顺序排序的文本。
    """
    # 分离正文和文献列表
    body, refs_section = text.rsplit('\n\n', 1)
    ref_items = refs_section.strip().split('\n')

    # 预标签，防止用数字替换数字时的问题
    body = re.sub(pattern, rf'[{LABEL}\1]', body)
    for i in range(len(ref_items)):
        if ref_items[i].startswith('['):
            ref_items[i] = '[' + LABEL + ref_items[i][1:]

    # 记录每个引用标签在正文中的绝对位置
    ref_positions = {}
    for m in re.finditer(pattern, body):
        if not m.group(1) in ref_positions:
            ref_positions.update({m.group(1): m.start()})

    # 根据位置对标签排序
    sorted_ref_labels = sorted(ref_positions, key=ref_positions.get)

    # 构建引用标签到新数字编号的映射
    label_to_number = {label: str(index + 1) for index, label in enumerate(sorted_ref_labels)}

    # 文献列表重排序
    ordered_refs = []
    for label in label_to_number:
        if_found = False
        for ref in ref_items:
            if if_found:
                break
            elif ref.startswith('[' + label + ']'):
                ordered_refs.append(ref)
                if_found = True
    ordered_refs = '\n'.join(ordered_refs)

    # 更新正文和文献列表中的引用标签为数字编号
    for old_label, new_number in label_to_number.items():
        body = body.replace(f"[{old_label}]", f"[{new_number}]")
        ordered_refs = ordered_refs.replace(f"[{old_label}]", f"[{new_number}]")

    # 合并正文和更新后的文献列表
    sorted_text = body + '\n\n' + ordered_refs

    return sorted_text


# 示例文本
text_example = """
这是引用[temp2]和[2][1][a1]的示例，支持单个文献的重复引用[1][temp2]。不支持在复数个重复引用中局部调整顺序。
支持的格式是，正文和文献列表之间空一行，其余只有换行没有空行。

[1]: 文献标题C - 摘要...
[2]: 文献标题B - 摘要...
[a1]: 文献标题D - 摘要...
[temp2]: 文献标题A - 摘要...
"""

# 应用函数
sorted_text = renumber_citations_by_order(text_example)

print(sorted_text)
